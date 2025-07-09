---
title: "Claude Codeでスクリーンショットを瞬時に分析！自動化システム「claude-screenshot」を作った"
emoji: "📸"
type: "tech"
topics: ["claude", "screenshot", "automation", "macos", "windows"]
published: true
---

# Claude Codeでスクリーンショットを瞬時に分析！自動化システム「claude-screenshot」を作った

## 概要

Claude Codeでスクリーンショットを分析したい時、毎回ファイルを探してドラッグ&ドロップするのは面倒ですよね。そこで、**スクリーンショットを撮った瞬間にClaude Codeで`/ss`と入力するだけで、最新のスクリーンショットを自動で分析してくれるシステム**を作りました。

![claude-screenshot-demo](https://github.com/miyashita337/claude-screenshot/raw/main/docs/demo.gif)

## 🚀 このシステムでできること

### 1. ワンコマンドでスクリーンショット分析
```bash
# 1. Command+Shift+4でスクリーンショット
# 2. Claude Codeで「/ss」と入力
# 3. 瞬時に画像が表示され、Claudeが分析開始！
```

### 2. 多彩なClaude Codeコマンド
- `/ss` - 最新のスクリーンショットを表示
- `/sslist` - 最近のスクリーンショット一覧
- `/ssshow 3` - 3番目のスクリーンショットを表示

### 3. 自動整理とObsidian連携
- スクリーンショットを自動でObsidian vaultに参照追加
- メタデータ（日時、ファイルサイズ等）も自動記録
- マークダウン形式で美しく整理

## 💡 メリット

### 🔥 作業効率の劇的向上
- **従来**: スクリーンショット → ファイル探し → ドラッグ&ドロップ → 分析
- **改善後**: スクリーンショット → `/ss` → 分析完了

### 🔒 セキュリティ重視
- **2段階インストール**: ダウンロード→検証→実行で安全
- **SHA256整合性検証**: ファイル改ざんを検出
- **オープンソース**: 全コードがGitHubで公開済み

### 🌍 マルチプラットフォーム対応
- **Windows**: PowerShell完全対応
- **macOS**: ネイティブ統合
- **Linux**: 基本機能サポート

### 🛠️ 高度な自動化
- **リアルタイム監視**: 新しいスクリーンショットを自動検出
- **バッチ処理**: 既存ファイルも一括処理
- **シェル統合**: 便利なエイリアスコマンド

## 📦 導入方法

### 🔒 セキュアインストール（推奨）

**macOS/Linux**:
```bash
curl -sSL https://raw.githubusercontent.com/miyashita337/claude-screenshot/main/safe-install.sh | bash
```

**Windows**:
```powershell
Invoke-WebRequest -Uri "https://raw.githubusercontent.com/miyashita337/claude-screenshot/main/install.ps1" -OutFile "install.ps1"
.\install.ps1
```

### ⚡ クイックインストール

**macOS/Linux**:
```bash
curl -sSL https://raw.githubusercontent.com/miyashita337/claude-screenshot/main/install.sh | bash
```

**Windows**:
```powershell
Invoke-WebRequest -Uri "https://raw.githubusercontent.com/miyashita337/claude-screenshot/main/install.ps1" -OutFile "install.ps1"; .\install.ps1 -Force
```

## 🎯 実際の使用例

### 基本的な使い方

```bash
# 1. スクリーンショットを撮影
Command+Shift+4  # macOS
Win+Shift+S      # Windows

# 2. Claude Codeで分析
/ss
```

### 高度な使い方

```bash
# 最近のスクリーンショット一覧
/sslist

# 特定のスクリーンショットを選択
/ssshow 2

# 自動監視開始
screenshot-monitor

# 既存ファイルを処理
screenshot-process
```

## 🔧 技術的な特徴

### アーキテクチャ
```
claude-screenshot/
├── install.sh              # macOS/Linux インストーラー
├── install.ps1             # Windows インストーラー
├── safe-install.sh         # セキュアインストーラー
├── scripts/                # コアスクリプト群
│   ├── screenshot_manager.sh
│   ├── claude_integration.sh
│   └── clipboard_handler.sh
└── claude-commands/        # Claude Codeカスタムコマンド
    ├── ss.md
    ├── sslist.md
    └── ssshow.md
```

### セキュリティ機能
- **SHA256ハッシュ値検証**: ファイル整合性チェック
- **段階的インストール**: 内容確認後の実行
- **最小権限**: 必要最小限の権限のみ要求

### クロスプラットフォーム対応
- **macOS**: fswatch + AppleScript
- **Windows**: FileSystemWatcher + PowerShell
- **Linux**: inotify + bash

## 🎉 実際に使ってみた結果

### Before（従来の方法）
1. スクリーンショット撮影 📸
2. Finderでファイル探し 🔍
3. ドラッグ&ドロップ 🖱️
4. Claude Codeで分析 🤖

**所要時間**: 約30秒

### After（claude-screenshot使用）
1. スクリーンショット撮影 📸
2. Claude Codeで`/ss` ⚡
3. 瞬時に分析開始 🤖

**所要時間**: 約3秒

**→ 90%の時間短縮を達成！**

## 🔮 今後の展開

### Phase 2: パッケージマネージャー対応
- Homebrew Tap
- Scoop (Windows)
- winget対応

### Phase 3: バイナリ配布
- GitHub Releases
- GPG署名付きバイナリ
- 自動更新機能

### 機能拡張
- 動画キャプチャ対応
- OCR機能統合
- AI自動タグ付け

## 🌟 まとめ

Claude Codeでのスクリーンショット分析を**劇的に効率化**するシステムを作りました。特に：

- **90%の時間短縮**を実現
- **セキュリティ重視**の設計
- **マルチプラットフォーム**対応
- **完全オープンソース**

エンジニアの日常業務で「スクリーンショットをAIに分析してもらう」シーンが増えている今、このツールが皆さんの生産性向上に貢献できれば嬉しいです！

## 📚 参考リンク

- **GitHub**: https://github.com/miyashita337/claude-screenshot
- **日本語README**: https://github.com/miyashita337/claude-screenshot/blob/main/README_ja.md
- **オリジナルGist**: https://gist.github.com/miyashita337/9cf694f01ee19c3c16e6d34afab64e8e

---

**試してみた感想や改善提案があれば、GitHubのIssueやコメントでお聞かせください！** 🚀