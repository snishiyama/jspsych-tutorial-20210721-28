# jspsych-tutorial-20210721-28

本チュートリアルは 2021/07/21, 28 に京都大学教育学研究科の「心理データ解析演習」の授業内で実施されたものです。

:+1::sparkles: **チュートリアルのフォルダをダウンロードする場合は，本ページの右上にある緑色のボタン`Code`から「Download ZIP」を選択してください。**
もちろん，`git clone` も可能なので，git になじみのある方はそちらでも問題ありません。

チュートリアルの目的は以下の 2 つです。

1. シンプルな課題・調査で構成されたオンライン実験を作成し，jsPsych の使い方に触れる
2. jsPsych で吐き出されたデータを R や Python で整理できるようになる

また，2 つのサブの目的を設けています。

1. 作成者の「ぼくのかんがえたさいきょうの研究用フォルダ構成」を紹介する
2. 作成者が最近ハマっている jsPsych 実験のコードの書き方を紹介する

チュートリアルについては別途資料（`tutorial`フォルダ内）を見てください。ここではサブの内容について触れておきます。

## :open_file_folder: フォルダ構成

研究を立ち上げる時に，このレポジトリのようなフォルダ構成で始めるのがいいと考えています。
これをそのまま Github や OSF などで共有してしまえば，データだけでなく，実験スクリプトもまとめて公開にできてしまいます。
これは一例ではありますが，データ公開の重要性が叫ばれる今日このごろ，研究開始時点で研究のオープン化を意識して整えておくだけで，ハードルがぐっと下がるはずです（といっている本人が，こういう実践をした研究を 2021/7 現在まだ出版・公開できていないのが心苦しいところです）。

こうすると，実験や分析の際にファイルの参照が面倒だなと思うかもしれませんが，それほど難しくありません。
jsPsych (html) であれば直接を相対リンクが有効ですし，分析の際も，R であれば`~~.Rproj`を作っておけば`here`パッケージを使うことで手軽に相対リンクでファイルを参照できるようになります。
詳しくは，実験・分析のそれぞれのスクリプト（`exp1.html`，`exp1.R`）を見てください。
ディレクトリについての知識が少し必要というのは心理的なハードルを上げているんだろうなと思います。

この構成は，基本的にプログラミングで実験やデータ分析をする場合に適していると考えていますが，GUI ベースのツールで実験（e.g., Psychopy Builder）やデータ分析（SPSS, JASP）をしている場合でもそれらのファイルを同様に保存しておけばいいと思います。

```sh
.
├── analysis          # 分析スクリプト用のフォルダ
│   └── R
│       └── exp1.R    # 必ずしも実験ごとにスクリプトを分ける必要はないかも
├── docs              # プロジェクトに関する文書用のフォルダ
│   ├── ethics-review # 倫理審査
│   └── manuscript    # 原稿
└── exp               # 実験関連のファイルを保存する
    ├── data
    │   └── exp1      # 実験ごとにデータフォルダを作る
    ├── (materials)   # 今回はないですが，刺激画像とかがあればここに入れる
    ├── js            # 実験用の細かいスクリプト（後述）
    └── exp1.html
```

## :muscle: 最近ハマっている jsPsych 実験の作り方

1. 実験のそれぞれの課題ごとに `js` ファイルを作成する（`flanker.js`など）
1. それらの課題を実施するためのタイムラインだけが書かれた`js`を作成する（`exp1.js`）
1. 実験用の`html`ではそのリンクを書くだけ

という書き方にハマっています（多くの人が書きそうな実験スクリプトは`exp1_casual.html`にあります）。
こういう書き方をすると，複数の実験をするときにコピペされるコードの量が減ったりしていいのかなと思っています。
課題の`js`ファイルではさらに変な書き方をしていますが，今回は説明を割愛します。

チュートリアルとはかけ離れた内容ですし，好みの分かれるところな気もするので，「こういうこともできるんだなぁ」と参考程度に見てもらえればと思います。

```sh
./exp
├── data
│   └── exp1
├── exp1.html
├── js
│   ├── bis-bas.js
│   ├── exp1.js
│   ├── flanker.js
│   ├── jspsych-6.3.1
│   └── util.js
└── write_data.php
```
