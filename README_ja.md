# Claude Screenshot System

macOSとWindows対応の包括的なスクリーンショット自動化システム。Claude CodeとObsidian vaultとの統合機能付き。

## 機能

- 🖼️ **自動スクリーンショット管理**: 専用ディレクトリでスクリーンショットを整理
- 📝 **Obsidian統合**: メタデータ付きマークダウン参照を自動生成
- 🤖 **Claude Code統合**: AI支援のための`/ss`コマンドをシームレスサポート
- 📋 **クリップボード対応**: ファイルとクリップボード両方のスクリーンショットに対応
- 🔍 **スマート監視**: 新しいスクリーンショットのリアルタイム検出
- ⚡ **クイックコマンド**: 効率的なワークフローのためのシェルエイリアス
- 🪟 **マルチプラットフォーム**: Windows、macOS、Linux対応

## クイックスタート

### 🔒 セキュアインストール（推奨）

**macOS/Linux:**
```bash
# セキュア2段階インストール
curl -sSL https://raw.githubusercontent.com/miyashita337/claude-screenshot/main/safe-install.sh | bash
```

**Windows:**
```powershell
# PowerShellインストーラーをダウンロードして実行
Invoke-WebRequest -Uri "https://raw.githubusercontent.com/miyashita337/claude-screenshot/main/install.ps1" -OutFile "install.ps1"
.\install.ps1
```

### ⚡ ダイレクトインストール（上級者向け）

**macOS/Linux:**
```bash
curl -sSL https://raw.githubusercontent.com/miyashita337/claude-screenshot/main/install.sh | bash
```

**Windows:**
```powershell
Invoke-WebRequest -Uri "https://raw.githubusercontent.com/miyashita337/claude-screenshot/main/install.ps1" -OutFile "install.ps1"; .\install.ps1 -Force
```

### 📸 使用方法

**macOS:**
- `Command+Shift+4` - ファイルに保存
- `Command+Shift+Control+4` - クリップボードにコピー

**Windows:**
- `Win+Shift+S` - Snipping Tool
- スクリーンショットを `%USERPROFILE%\Pictures\Screenshots` に保存

**Claude Code統合:**
- `/ss` コマンドで最新のスクリーンショットをClaudeに表示
- 新しいコマンドを読み込むためにClaude Codeを再起動

## インストール方法

### 🔒 方法1: セキュアインストール（推奨）

**最高のセキュリティを求めるmacOS/Linuxユーザー向け:**

```bash
# ステップ1: セキュアインストーラーをダウンロード
curl -sSL https://raw.githubusercontent.com/miyashita337/claude-screenshot/main/safe-install.sh | bash

# セキュアインストーラーは以下を行います:
# 1. メインインストーラーをダウンロード
# 2. SHA256整合性を検証
# 3. インストーラー内容のプレビューを表示
# 4. 実行前に確認を求める
```

**Windows ユーザー向け:**
```powershell
# 確認用にインストーラーをダウンロード
Invoke-WebRequest -Uri "https://raw.githubusercontent.com/miyashita337/claude-screenshot/main/install.ps1" -OutFile "install.ps1"

# スクリプトを確認（オプションですが推奨）
Get-Content install.ps1 | Select-Object -First 50

# インストーラーを実行
.\install.ps1
```

### ⚡ 方法2: ダイレクトインストール

**macOS/Linux:**
```bash
curl -sSL https://raw.githubusercontent.com/miyashita337/claude-screenshot/main/install.sh | bash
```

**Windows:**
```powershell
Invoke-WebRequest -Uri "https://raw.githubusercontent.com/miyashita337/claude-screenshot/main/install.ps1" -OutFile "install.ps1"; .\install.ps1 -Force
```

### 🛠️ 方法3: 手動/開発者向けセットアップ

1. **リポジトリをクローン**:
   ```bash
   git clone https://github.com/miyashita337/claude-screenshot.git
   cd claude-screenshot
   ```

2. **プラットフォーム固有のインストーラーを実行**:
   ```bash
   # macOS/Linux
   ./install.sh
   
   # Windows (PowerShell)
   .\install.ps1
   ```

### 📋 インストールされる内容

**全プラットフォーム共通:**
- スクリーンショット管理スクリプト
- Claude Codeカスタムコマンド（`/ss`, `/sslist`, `/ssshow`）
- 設定ファイルとエイリアス

**macOS/Linux固有:**
- Homebrew依存関係（fswatch）
- macOSスクリーンショット場所の設定
- `.bashrc`/`.zshrc`のシェルエイリアス

**Windows固有:**
- PowerShellベースのスクリーンショット監視
- Windowsファイルシステムウォッチャー
- PowerShellプロファイル設定
- スクリーンショットフォルダへのデスクトップショートカット

## コンポーネント

### コアスクリプト

| スクリプト | 目的 |
|--------|---------|
| `screenshot_manager.sh` | メインスクリーンショット監視と整理 |
| `clipboard_handler.sh` | クリップボードスクリーンショット処理 |
| `claude_integration.sh` | Claude Code統合と`/ss`機能 |
| `ss` | `/ss`コマンド用シンプルラッパー（レガシー） |
| `master_setup.sh` | 完全システムセットアップと設定 |
| `claude_commands_setup.sh` | Claude Codeカスタムコマンドセットアップ |
| `install.ps1` | Windows PowerShellインストーラー |
| `safe-install.sh` | セキュア2段階インストーラー |

### Claude Code カスタムコマンド

| コマンドファイル | 目的 |
|--------------|---------|
| `~/.claude/commands/ss.md` | `/ss` - 最新スクリーンショットを表示 |
| `~/.claude/commands/sslist.md` | `/sslist` - 最近のスクリーンショット一覧 |
| `~/.claude/commands/ssshow.md` | `/ssshow NUMBER` - 指定番号のスクリーンショット表示 |

### シェルエイリアス

セットアップ後、以下のエイリアスが利用可能になります：

```bash
# スクリーンショット管理
screenshot-monitor     # 新しいファイルスクリーンショットを監視
screenshot-process     # 既存スクリーンショットを処理

# クリップボード処理
clipboard-monitor      # クリップボードスクリーンショットを監視
clipboard-save         # 現在のクリップボードスクリーンショットを保存

# Claude統合
ss                     # 最新スクリーンショットのパスを取得（/ssコマンド）
sslist                 # 最近のスクリーンショット一覧
ssselect               # インタラクティブなスクリーンショット選択
```

## 使用方法

### スクリーンショット撮影

**ファイルスクリーンショット**: `Command+Shift+4` (macOS) / `Win+Shift+S` (Windows)
- `~/Pictures/Screenshots`に直接保存
- 自動的に処理され`Screenshots.md`に追加

**クリップボードスクリーンショット**: `Command+Shift+Control+4` (macOSのみ)
- クリップボードのみに保存
- `clipboard-save`を使用してファイルに保存・処理

### Claude Code統合

1. `Command+Shift+4`でスクリーンショットを撮影
2. Claude Codeで`/ss`を使用して最新のスクリーンショットを表示
3. Claudeが自動的に画像を読み込み分析

### 監視

自動監視を開始：
```bash
screenshot-monitor    # ファイルスクリーンショットを監視
clipboard-monitor     # クリップボードスクリーンショットを監視
```

### 手動処理

既存スクリーンショットを処理：
```bash
screenshot-process    # 既存スクリーンショットの参照を追加
```

## ファイル構造

```
~/Pictures/Screenshots/
├── screenshot_manager.sh          # メイン監視スクリプト
├── clipboard_handler.sh           # クリップボード処理
├── claude_integration.sh          # Claude Code統合
├── ss                             # /ssコマンドラッパー（レガシー）
├── master_setup.sh               # 完全セットアップスクリプト
├── claude_commands_setup.sh      # Claude コマンドセットアップ
├── README.md                     # このファイル
└── *.png                         # スクリーンショットファイル

~/.claude/commands/
├── ss.md                         # /ss カスタムコマンド
├── sslist.md                     # /sslist カスタムコマンド
└── ssshow.md                     # /ssshow カスタムコマンド

~/my-vault/test/
└── Screenshots.md                # 自動生成される参照
```

## 設定

### スクリーンショットディレクトリ
デフォルト: `~/Pictures/Screenshots`

変更方法:
```bash
# 各スクリプトのSCREENSHOT_DIR変数を編集
SCREENSHOT_DIR="$HOME/path/to/your/directory"
```

### Vaultディレクトリ
デフォルト: `~/my-vault/test`

変更方法:
```bash
# 各スクリプトのVAULT_DIR変数を編集
VAULT_DIR="$HOME/path/to/your/vault"
```

### サポートされる形式
- PNG（プライマリ）
- JPG/JPEG
- GIF
- BMP

## 高度な機能

### 自動起動

ログイン時の自動スクリーンショット監視を有効化：
```bash
launchctl load ~/Library/LaunchAgents/com.claude.screenshot-monitor.plist
```

無効化：
```bash
launchctl unload ~/Library/LaunchAgents/com.claude.screenshot-monitor.plist
```

### インタラクティブ選択

最近のスクリーンショットから選択：
```bash
ssselect
```

### バッチ処理

既存スクリーンショットをすべて処理：
```bash
screenshot-process
```

## トラブルシューティング

### スクリーンショットがディレクトリに保存されない

1. macOS設定を確認：
   ```bash
   defaults read com.apple.screencapture location
   ```

2. 必要に応じてリセット：
   ```bash
   defaults write com.apple.screencapture location ~/Pictures/Screenshots
   killall SystemUIServer
   ```

### 監視が動作しない

1. fswatch がインストールされているか確認：
   ```bash
   brew install fswatch
   ```

2. スクリプト権限を確認：
   ```bash
   chmod +x ~/Pictures/Screenshots/*.sh
   ```

### Claude Code `/ss`コマンドが動作しない

1. ssコマンドをテスト：
   ```bash
   ~/Pictures/Screenshots/ss
   ```

2. スクリーンショットの存在を確認：
   ```bash
   ls ~/Pictures/Screenshots/*.png
   ```

### Screenshots.mdに参照がない

1. 手動処理を実行：
   ```bash
   screenshot-process
   ```

2. vaultディレクトリの存在を確認：
   ```bash
   mkdir -p ~/my-vault/test
   ```

## ログファイル

システムアクティビティを監視：
```bash
# スクリーンショット監視ログ
tail -f ~/Library/Logs/claude-screenshot-monitor.log

# エラーログ
tail -f ~/Library/Logs/claude-screenshot-monitor.error.log
```

## 使用例

### 基本ワークフロー

1. スクリーンショット撮影: `Command+Shift+4`
2. Claudeに分析依頼: Claude Codeで`/ss`
3. Claudeが自動的に画像を確認・分析

### クリップボードワークフロー

1. クリップボードスクリーンショット撮影: `Command+Shift+Control+4`
2. ファイルに保存: `clipboard-save`
3. Claudeで使用: `/ss`

### バッチ整理

既存スクリーンショットを整理：
```bash
# すべてのスクリーンショットをディレクトリで処理
screenshot-process

# 処理されたスクリーンショットをすべて一覧表示
sslist
```

## 必要要件

- macOS 12.0+ (Monterey, Ventura, Sonoma) または Windows 10+ または Linux
- macOS: Homebrew（fswatch インストール用）
- Windows: PowerShell 5.1+
- Claude Code（`/ss`統合用）
- Obsidian（vault統合用、オプション）

## リポジトリ

- **GitHub**: https://github.com/miyashita337/claude-screenshot
- **イシュー**: https://github.com/miyashita337/claude-screenshot/issues
- **ライセンス**: CC0 1.0 Universal（パブリックドメイン）

## クレジット

- 元インスピレーション: [miyashita337によるGist](https://gist.github.com/miyashita337/9cf694f01ee19c3c16e6d34afab64e8e)
- 開発者: Claude AI Assistant
- 日付: 2025-07-09

## 貢献

1. リポジトリをフォーク
2. 機能ブランチを作成
3. 変更を行う
4. macOSで徹底的にテスト
5. プルリクエストを送信

## セキュリティ

このプロジェクトはセキュリティを重視して設計されています：

- **セキュア2段階インストール**: ダウンロード→検証→実行
- **SHA256整合性検証**: ファイルの改ざん検出
- **ユーザー確認プロンプト**: 意図しない実行の防止
- **最小権限の原則**: 必要最小限の権限のみを要求

## プライバシー

- スクリーンショットはローカルに保存されます
- 外部サーバーへのデータ送信はありません
- すべての処理はローカルマシンで実行されます

---

*質問やサポートについては、[イシューを開く](https://github.com/miyashita337/claude-screenshot/issues)かトラブルシューティングセクションを参照してください。*