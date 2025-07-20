# Windows版修正ガイド

このガイドは、Windows環境（特にWSL環境）でclaude-screenshotを動作させるための修正方法を説明します。

## 現在の問題点

1. **パスの問題**
   - 現在の実装はWSLのパスを想定していない
   - 正しいWindowsパス: `C:\Users\{ユーザー名}\Pictures\Screenshots`
   - WSLからのアクセス: `/mnt/c/Users/{ユーザー名}/Pictures/Screenshots`

2. **ファイル名の問題**
   - Windowsのスクリーンショットファイル名にはスペースが含まれる
   - 例: `Screenshot 2024-01-20 at 10.30.45.png`
   - シェルスクリプトでは必ずダブルクォートで囲む必要がある

## 修正方法

### 1. PowerShellスクリプトの作成

`scripts/windows/screenshot_manager.ps1`:
```powershell
# Windows Screenshot Manager for Claude
param(
    [Parameter(Mandatory=$true)]
    [string]$Action
)

$ScreenshotDir = "$env:USERPROFILE\Pictures\Screenshots"

function Start-Monitoring {
    Write-Host "Starting screenshot monitoring..."
    
    $watcher = New-Object System.IO.FileSystemWatcher
    $watcher.Path = $ScreenshotDir
    $watcher.Filter = "*.png"
    $watcher.NotifyFilter = [System.IO.NotifyFilters]::FileName
    
    Register-ObjectEvent -InputObject $watcher -EventName "Created" -Action {
        $path = $Event.SourceEventArgs.FullPath
        $name = $Event.SourceEventArgs.Name
        Write-Host "New screenshot detected: $name"
        # ファイル名にスペースが含まれていても正しく処理される
    }
    
    Write-Host "Monitoring $ScreenshotDir for new screenshots..."
    while ($true) { Start-Sleep -Seconds 1 }
}

switch ($Action) {
    "monitor" { Start-Monitoring }
    "list" { 
        Get-ChildItem -Path $ScreenshotDir -Filter "*.png" | 
        Sort-Object -Property LastWriteTime -Descending |
        Select-Object -First 10 |
        ForEach-Object { Write-Output $_.FullName }
    }
    "latest" {
        $latest = Get-ChildItem -Path $ScreenshotDir -Filter "*.png" | 
        Sort-Object -Property LastWriteTime -Descending |
        Select-Object -First 1
        if ($latest) { Write-Output $latest.FullName }
    }
}
```

`scripts/windows/claude_integration.ps1`:
```powershell
# Claude Integration for Windows
param(
    [string]$Command = "latest"
)

$ScreenshotDir = "$env:USERPROFILE\Pictures\Screenshots"

function Get-LatestScreenshot {
    $latest = Get-ChildItem -Path $ScreenshotDir -Filter "*.png" | 
    Sort-Object -Property LastWriteTime -Descending |
    Select-Object -First 1
    
    if ($latest) {
        # ダブルクォートで囲んで出力
        Write-Output "`"$($latest.FullName)`""
    }
}

function Get-ScreenshotList {
    Get-ChildItem -Path $ScreenshotDir -Filter "*.png" | 
    Sort-Object -Property LastWriteTime -Descending |
    Select-Object -First 10 |
    ForEach-Object { 
        # 各ファイルパスをダブルクォートで囲む
        Write-Output "`"$($_.FullName)`""
    }
}

switch ($Command) {
    "latest" { Get-LatestScreenshot }
    "list" { Get-ScreenshotList }
}
```

### 2. WSL対応版の作成

WSL環境では、bashスクリプトを修正してWindowsのパスにアクセスします。

`scripts/screenshot_manager.sh`の修正（WSL検出部分を追加）:
```bash
#!/bin/bash

# WSL環境の検出
if grep -qi microsoft /proc/version 2>/dev/null; then
    IS_WSL=true
    # WSLの場合、WindowsユーザーのPicturesフォルダを使用
    WIN_USER=$(cmd.exe /c "echo %USERNAME%" 2>/dev/null | tr -d '\r\n')
    SCREENSHOT_DIR="/mnt/c/Users/${WIN_USER}/Pictures/Screenshots"
else
    IS_WSL=false
    SCREENSHOT_DIR="${HOME}/Pictures/Screenshots"
fi

# ファイル操作時は常にダブルクォートを使用
process_screenshot() {
    local file="$1"  # ダブルクォートで囲む
    echo "Processing: \"$file\""
    # 他の処理...
}
```

### 3. install.ps1の修正

```powershell
# Windows版インストーラーの修正箇所

# スクリーンショットディレクトリの作成
$ScreenshotDir = "$env:USERPROFILE\Pictures\Screenshots"
if (!(Test-Path $ScreenshotDir)) {
    New-Item -ItemType Directory -Path $ScreenshotDir -Force
    Write-Host "Created screenshot directory: $ScreenshotDir"
}

# PowerShellスクリプトのダウンロードと配置
$ScriptsDir = "$env:USERPROFILE\Pictures\Screenshots\scripts"
New-Item -ItemType Directory -Path $ScriptsDir -Force

# ファイルのダウンロード（スペースを含むパスに対応）
$files = @(
    "scripts/windows/screenshot_manager.ps1",
    "scripts/windows/claude_integration.ps1"
)

foreach ($file in $files) {
    $url = "https://raw.githubusercontent.com/odentools/claude-screenshot-system/main/$file"
    $dest = Join-Path $ScriptsDir (Split-Path $file -Leaf)
    Invoke-WebRequest -Uri $url -OutFile $dest
}

# PowerShellプロファイルへのエイリアス追加
$profileContent = @"
# Claude Screenshot System aliases
function ss { & "$ScriptsDir\claude_integration.ps1" -Command latest }
function sslist { & "$ScriptsDir\claude_integration.ps1" -Command list }
"@

Add-Content -Path $PROFILE -Value $profileContent
```

### 4. Claude Codeコマンドの修正

`claude-commands/ss.md`をOS対応に修正:
```markdown
---
input: optional
output: read-files
---

Get the latest screenshot path based on the operating system:

- On Windows (PowerShell): Run `powershell -File "$env:USERPROFILE\Pictures\Screenshots\scripts\claude_integration.ps1" -Command latest`
- On WSL: Check `/mnt/c/Users/$USER/Pictures/Screenshots` for latest PNG file
- On macOS/Linux: Run `~/Pictures/Screenshots/claude_integration.sh latest`

Then read the screenshot file at the returned path.
```

## テスト手順

1. **Windows（PowerShell）での動作確認**
   ```powershell
   # スクリプトの直接実行
   .\scripts\windows\screenshot_manager.ps1 -Action latest
   
   # スペースを含むファイル名のテスト
   New-Item -Path "$env:USERPROFILE\Pictures\Screenshots\Screenshot 2024-01-20 at 10.30.45.png" -ItemType File
   .\scripts\windows\screenshot_manager.ps1 -Action latest
   ```

2. **WSL環境での動作確認**
   ```bash
   # WSL環境の確認
   grep -qi microsoft /proc/version && echo "WSL detected" || echo "Not WSL"
   
   # Windowsパスへのアクセステスト
   ls -la "/mnt/c/Users/$(cmd.exe /c 'echo %USERNAME%' | tr -d '\r\n')/Pictures/Screenshots/"
   ```

## 注意事項

1. **権限の問題**
   - WSLからWindowsファイルシステムへのアクセスには適切な権限が必要
   - PowerShellスクリプトの実行にはExecutionPolicyの設定が必要

2. **パフォーマンス**
   - WSLからWindowsファイルシステムへのアクセスは遅い場合がある
   - 大量のファイルがある場合は検索に時間がかかる可能性

3. **文字エンコーディング**
   - WindowsとWSL間でファイル名の文字エンコーディングに注意
   - 日本語ファイル名の扱いには特に注意が必要