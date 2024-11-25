#!/usr/bin/env bash
str="hello123"
# if [[ $str =~ ^h\D+\d+$ ]]; then    # \D and \d are not supported in bash
if [[ $str =~ ^h[a-zA-Z]+[0-9]+$ ]]; then
  echo "aaaaaa"
else
  echo "bbbbbb"
fi
