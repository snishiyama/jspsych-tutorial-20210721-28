# 今回使用するライブラリ（R）・パッケージ（Py）

## R

```r
if(!require(pacman)) install.packages("pacman")
pacman::p_load(tidyverse, here, jsonlite)
```

使用するのは，`pacman`, `tidyverse`, `here`, `jsonlite` の 4 つです。
それぞれの概要は以下のとおりです。

- `pacman`: パッケージ管理ツール。`p_load` 関数が便利。基本は `library()` と同じだが， もしパッケージがインストールされてなければ `install.packages()` してくれる。`()`内にパッケージ名を並べられるのも良い。
- `tidyverse`: データ整理・分析用のツール（群）
  - 実際に使うのは，そのうちの `dplyr`, `tidyr`, `readr`, `purrr`, `fs`
  - それぞれの具体的な棲み分けは [このサイト](https://heavywatal.github.io/rstats/dplyr.html) などを参照してください
- `here`: `.Rproj` ファイルを起点にパスを指定できるようにする
- `jsonlite`: json 形式のデータ（`survey-likert`が吐き出すデータ）を扱いやすくする。

## Python

```python
import pathlib
import json
import pandas as pd
```

3 つのパッケージを使用します。

- `pathlib`: ファイルパスをいい感じに指定する（組み込みパッケージ）
- `json`: json 形式のデータをいい感じに扱う（組み込みパッケージ）
- `pandas`: データ整理・分析用（要インストール）
