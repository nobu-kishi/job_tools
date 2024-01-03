# output_git_log.sh
対象ディレクトリのリポジトリからコミットログを一括出力する。


## 前提
本シェルの実行は、以下のような階層構造のディレクトリを想定。
```
.
├── {repository_name_a}
├── {repository_name_b}
├── {repository_name_c}
├── {repository_name_d}
└── {repository_name_e}
```


## 実行方法
```
sh output_git_log
```


## $REPOSITORY_LIST_FILEを指定する場合
{リポジトリ名の一覧を記載したファイル}を指定した場合、記載のあるリポジトリに対して実行する。
```
REPOSITORY_LIST_FILE=YOUR_REPOSITORY_LIST_TEXT
```

### 記載例 {リポジトリ名の一覧を記載したファイル}
```
{repository_name_a}
{repository_name_c}
{repository_name_e}
```


## REPOSITORY_LIST_FILEを指定しない場合
$REPOSITORYS_DIR配下の全リポジトリに対して実行する。