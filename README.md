# Matra Language Core

> **Unified language for document, data, and code representation**

[![License: MIT](https://img.shields.io/badge/license-MIT-blue.svg)](LICENSE)
[![Node.js](https://img.shields.io/badge/node-%3E%3D22-green.svg)](https://nodejs.org/)
[![Language](https://img.shields.io/badge/lang-Peggy%2FESM-orange.svg)](https://peggyjs.org/)

---

## 🧭 概要 / Overview

**Matra** は、文書・データ・プログラムを単一の構造体系で表現するための新しいメタ言語です。
Markdown・HTML・JSON・JavaScript（ESTree）を統合的に扱い、
「構造そのものを操作する」ことを目的としています。

---

### 🔶 キーコンセプト

| 項目         | 内容                                                          |
| ------------ | ------------------------------------------------------------- |
| **中間形式** | Matrast (`[tag, props, body]`)                                |
| **パーサ**   | Peggy (`.pegjs`) で実装                                       |
| **評価系**   | `evaluate()` により構文木を実行可能                           |
| **出力系**   | `toHTML()`, `toJSON()`, `toCanvas()`, `toTeX()`, `toESTree()` |
| **哲学**     | 「構造＝意味」を統合する構造的ラーニング言語                  |

---

## 🚀 セットアップ / Setup

### 1. 依存関係のインストール

```bash
git clone https://github.com/YOUR_USERNAME/matra-lang.git
cd matra-lang
npm install
```

### 2. パーサのビルド

```bash
npm run build
```

> `src/matra.pegjs` → `src/parser.mjs` が自動生成されます。

### 3. テスト実行

```bash
npm test
```

---

## 💡 使用例 / Examples

### 例 1：Matra 構文 → HTML

```matra
div {
  h1 { "Matra Render Test" }
  p { "Matra v0.5 rendering to HTML works correctly." }
  code[fileType=text] { "console.log('Hello Matra!')" }
}
```

→ 出力：

```html
<div>
  <h1>Matra Render Test</h1>
  <p>Matra v0.5 rendering to HTML works correctly.</p>
  <pre><code class="lang-text">console.log(&#039;Hello Matra!&#039;)</code></pre>
</div>
```

---

### 例 2：toCanvas() で描画命令生成

```matra
div {
  text { "Canvas Example" }
  circle[x=100,y=100,r=30,color="red"]
  text[x=90,y=180,color="blue"] { "Matra!" }
}
```

→ 出力：

```json
[
  { "op": "circle", "x": 100, "y": 100, "r": 30, "color": "red" },
  { "op": "text", "x": 90, "y": 180, "text": "Matra!", "color": "blue" }
]
```

ブラウザでの描画例：
[`examples/canvas.html`](examples/canvas.html)

---

## 🧩 モジュール構成 / Modules

```
src/
 ├── parser.mjs        # 自動生成PEGパーサ
 ├── evaluate.mjs      # AST評価系
 ├── render.mjs        # HTML / Canvas / TeX / ESTree 出力
 └── matra.pegjs       # 文法定義
examples/
 ├── basic.matra
 ├── canvas.matra
 └── canvas.html
tests/
 ├── syntax.test.mjs
 ├── eval.test.mjs
 └── render.test.mjs
```

---

## 🧠 設計思想 / Philosophy

> すべての表現は「構造」であり、構造は変換可能である。
> Matra は、文書・データ・コードの垣根を超えた「構造的思考の共通言語」である。

Matra の設計は、スクウェア（現スクウェア・エニックス）の RPG シリーズに登場する青魔法
**「マトラマジック（Matra Magic）」** の理念 “Learning” に由来する。
異なる言語体系を「学習し取り込み再構築する」構造を体現している。

---

## 🧾 白書 / White Paper

📘 [Matra Language White Paper v0.6 (日本語版)](./docs/matra-whitepaper-v0.6.md)
本書は、理念・文法・評価・描画仕様を包括的にまとめた公式文書です。
PDF 版・英語版も順次公開予定。

---

## 🧱 ライセンス / License

MIT License
© 2025 Yuki Iwabuchi / Matra Language Design Team

---

## ✨ 次フェーズ / Next

- [ ] Self-hosting Matra (Matra で Matra を書く)
- [ ] toSVG / toThree / toMusicXML 出力
- [ ] Web IDE 実装 (Matra Playground)
- [ ] 国際仕様（Matra International Specification）

---

## 🌐 コミュニティ / Community

- GitHub Issues — 提案・議論
- Discussions — 構文・哲学・拡張提案
- Discord — コラボレーション（準備中）

---

> Matra is not just a language — it’s a structure that learns.
