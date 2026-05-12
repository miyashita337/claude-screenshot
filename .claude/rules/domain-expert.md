# ドメインエキスパート: Claude Screenshot System

## プロジェクト概要

macOS / Linux / Windows / WSL2 対応の shell script ベースのスクリーンショット自動化ツール。Claude Code (`/ss` 等のカスタムコマンド) および Obsidian と統合し、「問題発生 → スクリーンショット → AI 分析 → 解決」のサイクルを最適化する。

- **プロダクトタイプ**: CLI / shell script tool（Node.js プロジェクトではない）
- **配布形態**: GitHub repo + `install.sh` / `safe-install.sh` (macOS/Linux), `install.ps1` (Windows)
- **主要ユーザー操作**: OS のスクリーンショットホットキー → Claude Code 内で `/ss` 実行 → AI が画像を分析

## ドメイン知識

### 中核コンセプト

| 用語 | 意味 |
|---|---|
| **screenshot-driven development** | 視覚的問題 → 即時キャプチャ → AI 分析 → 修正のループ。本プロジェクトの設計思想 |
| **`/ss` コマンド** | Claude Code のカスタムスラッシュコマンド。最新スクリーンショットを Claude セッションに渡す |
| **`/sslist` / `/ssshow N`** | 番号付き一覧と特定番号画像を渡すコマンド |
| **screenshot 保存先** | macOS デフォルト `~/Pictures/Screenshots/`、WSL2 では `/mnt/c/Users/$USER/Pictures/Screenshots/` |

### スクリーンショットファイル命名規則

- macOS: `Screenshot YYYY-MM-DD at HH.MM.SS.png`
- WSL2 (Windows ネイティブ命名): `スクリーンショット YYYY-MM-DD HHMMSS.png`（日本語 + 半角スペース）
- 命名規則変更時は `find` パターンと `claude_integration.sh` の検索ロジックを同期させること

### プラットフォーム検出ロジック

1. `$WSL_DISTRO_NAME` 存在 → WSL2 として `/mnt/c/Users/$USER/Pictures/Screenshots/` を採用
2. `$OSTYPE = darwin*` → macOS パス
3. `$OSTYPE = linux*` → Linux 標準パス
4. `$SCREENSHOT_DIR` が設定されていれば最優先で上書き

### ディレクトリ構成

| パス | 役割 |
|---|---|
| `scripts/` | 機能本体（claude_integration.sh, screenshot_manager.sh, clipboard_handler.sh, master_setup.sh 等） |
| `claude-commands/` | Claude Code カスタムコマンド定義 (`ss.md`, `sslist.md`, `ssshow.md`) |
| `~/.claude/commands/` | install.sh により上記が配置される先 |
| `~/Pictures/Screenshots/` | スクリプト + スクリーンショット本体 |

### install.sh の副作用（重要）

- `defaults write com.apple.screencapture location` → macOS のシステム設定変更
- `killall SystemUIServer` → UI サーバー再起動（変更を反映）
- `~/.zshrc` / `~/.bashrc` への alias 追記
- `brew install fswatch` の自動実行（Homebrew 未導入時は brew 自体もインストール）

これらは **可逆だがユーザーの環境に副作用がある**。安易な再実行・上書きは避け、`grep -q "Claude Screenshot System"` で冪等性を担保している。

## 技術スタック

| 領域 | 採用技術 | 備考 |
|---|---|---|
| Shell (Unix) | bash 3.2+ / zsh | macOS 標準 bash 3.2 互換必須（`mapfile` / `readarray` 禁止、`while-read` で配列構築） |
| Shell (Windows) | PowerShell 5.1+ | `install.ps1`, `install_latest.ps1` |
| File watcher (macOS) | `fswatch`（Homebrew） | screenshot_manager.sh が監視に使用 |
| File watcher (Linux) | `inotify` 系 | fswatch の代替 |
| File watcher (Windows) | .NET FileSystemWatcher | PowerShell 経由 |
| Package manager | Homebrew (macOS) | install.sh が未導入時に自動セットアップ |
| Error handling | `set -euo pipefail` | 全 shell script で必須 |
| Debug | `DEBUG=1` 環境変数 | 特に WSL2 path resolution のトレース用 |
| Integrity verify | SHA256 (`install.sh.sha256`) | `safe-install.sh` の二段階検証 |

## レビュー時の重点チェック項目

### Shell script 共通

- [ ] **`set -euo pipefail`** が冒頭にあるか
- [ ] **bash 3.2 互換**: `mapfile` / `readarray` / 連想配列 (`declare -A`) を使っていないか
- [ ] **`$VAR` 直後の全角文字**: 日本語メッセージで `${VAR}` 形式を使い、`$VAR` ではないか（RW-006 と同型回避）
- [ ] **silent fallback 禁止**: `2>/dev/null || true` は意図的な箇所のみ、コメントで理由明記
- [ ] **shebang**: `#!/bin/bash`（`/bin/sh` ではない、配列のため）
- [ ] **権限**: 実行スクリプトは `chmod +x`（755）

### クロスプラットフォーム

- [ ] **WSL2 検出**: `$WSL_DISTRO_NAME` で分岐しているか（hardcode された Unix path のみは WSL2 で破綻）
- [ ] **パス区切り**: PowerShell 側は `\`、bash 側は `/`、相互変換が必要な箇所で `wslpath` 等を使用
- [ ] **ファイル名の Unicode/空白**: 日本語スクリーンショット名・スペース付きパスを `"$VAR"` で必ず quote
- [ ] **macOS bash 3.2 vs Linux bash 5**: 構文・ビルトインの差異を CI または `bash -n` で検証

### install.sh / 配布スクリプト

- [ ] **冪等性**: 同じスクリプトを 2 回実行しても壊れない（alias 二重追記回避、ファイル上書き判定）
- [ ] **副作用の事前告知**: 対話プロンプトで明示（macOS defaults 変更、shell rc 編集、brew install）
- [ ] **rollback 手順**: README に uninstall 方法または手動復元手順があるか
- [ ] **`ln -s` の検証**: Windows / 権限不足で recursive copy にフォールバックしていないか（RW-005 同型）
- [ ] **`.bak` 退避**: 既存ユーザーファイルを silent に消失させていないか（RW-004 同型）

### Claude Code integration

- [ ] **`/ss` コマンドの定義**: `claude-commands/*.md` の frontmatter / 本文が Claude Code の slash command 仕様に準拠
- [ ] **screenshot 検索**: `find` の `-path` パターン、ファイル名空白・Unicode 対応
- [ ] **DEBUG モード**: `DEBUG=1` で path resolution のトレースが取れること

### セキュリティ

- [ ] **curl | bash** パターン: `safe-install.sh` の二段階検証経路を推奨、SHA256 検証必須
- [ ] **権限の最小化**: 755 を超える権限を要求していないか
- [ ] **screenshot 内の機密**: README で「screenshot に credentials を写さない」旨を注意喚起
- [ ] **`defaults write`** の対象: 必要最小限（`com.apple.screencapture location` のみ等）

### ドキュメント整合性

- [ ] **README.md / README_ja.md** 同期
- [ ] **CHANGELOG.md** 更新（VERSION ファイルとの整合）
- [ ] **WINDOWS_FIX_GUIDE.md** の手順が現行 `install.ps1` と一致

## RW（手戻り）パターン参照

agent-base 共通 RW のうち、本プロジェクトで再現しやすいもの:

- **RW-005** (Windows symlink silent fallback): install.ps1 系で同型注意
- **RW-006** (`$VAR` + 全角文字 ロケール依存): 日本語ログメッセージで頻発しうる
- **RW-031** (Mac/Win 二重実装の Writer/Reader キー不一致): screenshot_manager の Mac/WSL2 配分で同型注意
- **RW-028** (bash 3.2 readarray): macOS 既定 shell 互換性で頻発

新規 RW 発生時は agent-base 側 `rules/general/rework-patterns.md` ではなく、プロジェクト固有 RW として本ファイル末尾または `.claude/rules/rework-patterns-project.md` に記録する（運用方針はユーザーと合意のうえ決定）。
