# データの読み込み

今回は以下のように `exp/data/exp1/` フォルダに参加者ごとにデータが保存されています。

```sh
exp/data/
└── exp1
    ├── 0pu18xqt8ws6_flanker-BB_exp1.csv
    ├── 1f96wckn5emk_flanker-BB_exp1.csv
    # 省略
    ├── pe7l2asv0cml_flanker-BB_exp1.csv
    └── qf7aafx8dmog_flanker-BB_exp1.csv
```

## まずは 1 つ

まずは csv ファイルを一つ読み込んでみて，少し離れたフォルダに保存されたファイルを読み込む方法に触れてみましょう。

### R

`readr::read_csv()` を使って csv ファイルを読み込みます[^a]。
引数に読み込みたいファイルのパスを指定して実行するとデータフレームとして読み込まれます。

[^a]: 組み込み関数の `read.csv()` を使っても構いません。それほど変わりません。

```r
readr::read_csv(
  here::here("exp/data/exp1/0pu18xqt8ws6_flanker-BB_exp1.csv"),
  na = c("", "NA", "null")
)
```

ファイルパスの指定に `here::here()` を使用しています。
`here::here()`は（たぶん）最寄りの`.Rproj`ファイルがあるディレクトリを返します。
引数にさらにパスを指定すると，`.Rproj` ファイルがあるディレクトリを起点としてパスにすることができます。
そのため，`.Rproj` ファイルさえ作っておけば，`here::here()` を組み合わせることで，作業ディレクトリに依存せずファイルパスを指定できるようになります。

2 つ目に指定している `na = c("", "NA", "null")` という引数は，csv ファイル内の何を `NA` （欠損値）として認識するかを指定しています。
jsPsych が吐き出すファイルにそれなりに含まれている `null` を`read_csv` はデフォルトで， `NA` として認識しないので，このような指定をしています。

ちなみに， `readr::read_csv()` とか `here::here()` は `ライブラリ名::関数名` というライブラリ名を明示できる記法になっています。
この記法を使うと，プログラムを実行する前にライブラリを読み込む必要がなくなったり，同名の関数が複数のライブラリに存在する場合に生じる誤動作を防ぐことができたり，といった恩恵があります。
今回はそういうケースに当てはまらないので，`read_csv()`, `here()` だけでも同じ動作をします。
ただし，今回の資料では，前者の書き方をします。
プログラム実行上のメリットではないのですが，シンプルにライブラリ名がわかりやすくて検索しやすくなったりするという利点があります。

### Python

`pandas.read_csv()` を使って csv ファイルを読み込みます。
引数に読み込みたいファイルパスを指定します。

```python
dir_root = pathlib.Path(__file__).parent.parent.parent # 分析ファイルの保存先によって変わる
dir_data_exp1 = dir_root / 'exp' / 'data' / 'exp1'
pd.read_csv(dir_data_exp1 / '0pu18xqt8ws6_flanker-BB_exp1.csv')
```

`pathlib` は `/` で直感的に，かつ OS に依存せずパスを指定できるので便利です。
`.Rproj` + `here` のようなものはないので，最初に，今開いているファイルのパス（`pathlib.Path(__file__)`）を取得し，そこからたどってプロジェクトのルートディレクトリを取得し（今回であれば，`parent.parent.parent` と 3 つ上のディレクトリ）変数に格納しています。

今回は，`exp1`のデータが保存されたディレクトリのパスも変数に格納しています。

## 全部まとめて読み込む

上のコードを参加者分だけコピペして読み込むのはさすがに非効率的です。
第 1 回で BIS/BAS の質問項目の設定を `for` 文でまとめて処理したのと同様に，

- まとめてファイルパスを取得し
- `for` 文などで読み込む処理を繰り返し
- それぞれのデータフレームを 1 つに結合する

とすると，うまく関数や組み込みの構文を使えば，R では 2 行，Python では 1 行ですべてのデータを一つのデータフレームとして読み込むことができます。

### R

- まとめてファイルパスを取得する

`fs::dir_ls()` を使います。
引数に，データが保存されたフォルダのパスとファイルの拡張子をそれぞれ指定すると，データが保存された一連の csv ファイルのパスがベクトル形式が得られます。

```r
fs::dir_ls(path = here::here("exp/data/exp1"), glob = "*.csv")

# Macなら以下のような出力（3つ目以降省略
# /..プロジェクトフォルダまでのパス../jspsych-tutorial-20210721-28/exp/data/exp1/0pu18xqt8ws6_flanker-BB_exp1.csv
# /..プロジェクトフォルダまでのパス../jspsych-tutorial-20210721-28/exp/data/exp1/1f96wckn5emk_flanker-BB_exp1.csv
# /..プロジェクトフォルダまでのパス../jspsych-tutorial-20210721-28/exp/data/exp1/31h414f13x6x_flanker-BB_exp1.csv
```

- `for` 文などで読み込む処理を繰り返す

得られたファイルパスのベクトルの要素それぞれに対して，`readr::read_csv` を実行します。
`for` 文を使ってもいいのですが，ここでは `purrr::map()` という関数を使います[^1]。

[^1]: 必ずしも実行速度が上がるわけではない（はず）ですが，`purrr::map` の場合は パイプ演算子 `%>%` を使ってコード全体をスッキリさせられます。

`purrr::map` はベクトルやリストを第 1 引数にとり，第 2 引数に関数を指定します。
第 3 引数以降は関数の第 1 引数以外の引数を指定します。
実行結果はリストが返されます。

```r
purrr::map(1:3, log, base = 2) # 1,2,3の底2のlogを計算
# [[1]]
# [1] 0

# [[2]]
# [1] 1

# [[3]]
# [1] 1.584963
```

これをファイルパスのベクトルに応用します。

```r
fs::dir_ls(path = here::here("exp/data/exp1"), glob = "*.csv") %>%
  purrr::map(readr::read_csv, na = c("", "NA", "null"))
```

これを実行すると，各 csv を読み込んだデータフレームのリストが得られます。

なお，この `%>%` はパイプ演算子と呼ばれるもので，左の項（改行している場合は上の項）の計算結果を右の項（同じく下の項）の第 1 引数に代入するという演算子です。
詳しくは [このサイト](https://heavywatal.github.io/rstats/dplyr.html) を参照してください。

- データフレームのリストを 1 つのデータフレームに結合する

データフレームのリストは`dplyr::bind_rows()` で縦に連結できます。
以下のようにするだけで OK。

```r
fs::dir_ls(path = here::here("exp/data/exp1"), glob = "*.csv") %>%
  purrr::map(readr::read_csv, na = c("", "NA", "null")) %>%
  dplyr::bind_rows()
```

なお，それぞれのファイルを読み込んでデータフレームを結合するという処理は `purrr::map_dfr` という関数でまとめて実行できる。

```r
fs::dir_ls(path = here::here("exp/data/exp1"), glob = "*.csv") %>%
  purrr::map_dfr(readr::read_csv, na = c("", "NA", "null"))
```

こういう関数が用意されているのは，同じフォーマットのファイルが多数あって，それをそれぞれ読み込んでまとめるというケースが多いということなのかもしれません。

### Python

Python ならリスト内包表記という文法があるおかげで一行で書けます。
やっていることは R と同じです。

```python
df_e1 = pd.concat([pd.read_csv(f) for f in dir_data_exp1.glob("*.csv")])
```

リスト内包表記を使わなかったら以下のようになります。

```python
list_df = []
for f in dir_data_exp1.glob('*.csv'):
	list_df.append(pd.read_csv(f))

df_e1 = pd.concat(list_df)
```

- まとめてファイルパスを取得する

`.glob()`は`Path`オブジェクトのメソッドで，そのオブジェクトがディレクトリパスを指している場合，フォルダ内のファイルの一覧をリストとして取得する[^2]。
引数に`'*.csv'`と指定すれば csv ファイルだけの一覧を作る[^3]。

[^2]: 厳密にはリストではなくイテレータ。for 文で使う分にはどちらの型かを気にする必要はありません。
[^3]: 引数で指定しているのは正規表現ではありません。

- `for` 文などで読み込む処理を繰り返す

まさにこの通りで，for 文を使って，ファイルパスのリストから要素を一つずつ取り出して，csv ファイルの読み込み `pd.read_csv()` → 別のリストに格納 `list_df.append()` という処理を繰り返します。

- 1 つのデータフレームに結合する

`pd.concat()` でリストに格納されたデータフレームを縦方向に結合できます。
