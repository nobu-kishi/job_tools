#!/bin/bash
# 対象ディレクトリのリポジトリからコミットログを一括出力する
# 
# usage: sh output_git_log.sh

set -eu

# 環境設定
readonly REPOSITORIES_DIR=""
readonly OUTPUT_DIR=""
readonly REPOSITORY_LIST_FILE=""

#
# 環境設定の解析
#
function usage() {
  cat <<EOS >&2
  [エラー] 環境設定に不足があります
    - REPOSITORIES_DIR      [必須]リポジトリのあるディレクトリ（末尾に「/」必須）
    - OUTPUT_DIR            [必須]git logコマンドの格納先ディレクトリ（末尾に「/」必須）
    - REPOSITORY_LIST_FILE  [任意]\$REPOSITORIES_DIRの特定リポジトリを指定する場合に設定
EOS
  exit 1
}

function parse_environment() {
  if [[ -z "$REPOSITORIES_DIR" || -z "$OUTPUT_DIR" ]]; then
      usage
  fi
}

#
# 関数定義
#
function get_repository_names() {
  if [[ "$REPOSITORY_LIST_FILE" ]]; then
    # テキストファイルからリポジトリ名を一覧取得
    tr '\n' ' ' < "${REPOSITORY_LIST_FILE}"
  else
    # ディレクトリ名を一覧取得
    find "$REPOSITORIES_DIR" -maxdepth 1 -mindepth 1 -type d -exec basename {} \;
  fi
}

function output_commit_log() {
  local output_text="$1"
  # 実行毎にファイルは再作成する
  echo "----------------------------------------" > "$output_text"
  git branch >> "$output_text"
  echo "----------------------------------------" >> "$output_text"
  git log --date=format-local:'%Y/%m/%d %H:%M:%S' >> "$output_text"
}

function main() {
  local -r dirs="$(get_repository_names "$REPOSITORY_LIST_FILE")"

  # ループ前に実行結果の出力先を作成
  mkdir -p "$OUTPUT_DIR"

  # 実行後、元のディレクトリに戻るためサブプロセスで実行
  (
    for dir in $dirs; do
      echo "${REPOSITORIES_DIR}${dir}" 
      cd "${REPOSITORIES_DIR}${dir}" || exit

      # main/masterが存在しない場合、次のループに移行
      git switch main || git switch master || continue

      output_commit_log "${OUTPUT_DIR}${dir}.txt"
    done
  )
}

if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
  parse_environment
  main
fi