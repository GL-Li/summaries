## Linux: bash script run as command

**Summary**: place all well-written bash script under `~/bin` and add `~/bin` to PATH so the bash scripts can be run just like any terminal command.

Create a minimal example and name it `aaa.sh`

```bash
#! /usr/bin/bash

echo "collecting all file names in current directory"
echo "save them in file all_files.txt"
ls -ltr | tee all_files.txt
```

Run it from terminal locally

```shell
bash aaa.sh
```

Convert to executable file, which can be run as `$ path/to/aaa` without `bash`

```shell
cd                    # back to home diretory
mkdir bin             # create a bin to hold all bash script
mv aaa.sh aaa         # rename to just xxx
chmod +x aaa          # change to executable file
```

To run it from anywhere as a terminal command, add the path to `.bashrc`. Restart terminal to add the new path.

```text
# add to the end of .bashrc
PATH="$PATH:$HOME/bin"
```



## Bash script fundmentals

### Use `[[ ... ]]` over `[ ... ]`
- spaces after `[` and before `]` are required.
- `[[ ... ]]` is newer and more powerful, and can do all the tasks that `[ ... ]` can do in bash scripts.
- only advantage of `[[ ... ]]` is that it is compatable with other flavor of shell scripting such as `Sh (Bourne Shell)`, `zsh`, and `fish`.


### Regular expression in bash
`[[ $string =~ pattern ]]` operator chack if a string matches a regex pattern.

Bash regex engine does not support short-hand regex pattern like `\d` and `\D`. It support the following POSIX charater classes:
- `[:digit:]`, can be replaced with `[0-9]`
- `[:alpha:]`, better with `[a-zA-Z]`
- `[:alnum:]`
- `[:space:]`
- `[:punct:]`

Example: save the code below as bash-script-examples/regex.sh and run it.
```bash
#!/usr/bin/env bash
str="hello123"
# if [[ $str =~ ^h\D+\d+$ ]]; then    # \D and \d are not supported in bash
if [[ $str =~ ^h[^0-9]+[0-9]+$ ]]; then
  echo "The string starts with 'h' and ends with a number"
else
  echo "The string does not starts with 'h' and ends with a number"
fi
```


### function

```bash
# define the function
checkHomeDirectory() {
  pattern="/home/[a-zA-Z][a-zA-z0-9]*$"
  # $1 is the first parameters to the function
  if [[ $1 =~ $pattern ]]; then
    echo "$1 is a valid home directory"
  else
    echo "$1 is an invalid home directory"
  fi
}

# call the function
input="/home/xyz"
checkHomeDirectory "$input"

input="/home/3aa"
checkHomeDirectory "$input"
```


### find ... | while read xxx; do ...
`find ...` output directories or files line by line and `while read xxx` read each line into `xxx` for future processing in a loop.

Example: in `bash-script-examples/` run `bash while_read_dir_fname.sh tmp0` to check the output of the code below.
```bash
#!/bin/bash

data_dir="$1"

echo "Print all .txt and .csv files in $data_dir and its subdirectories"

# list $data_dir and all its subdirectories recursively and then find
# .txt and .csv files in each directory. Typically use dir in place of aaa
# and fname in place of bbb.
find "$data_dir" -type d | while read aaa; do
  find "$aaa" -type f \( -name "*.csv" -or -name "*.txt" \) | while read bbb; do
    echo -e "\n$bbb =============="  # -e to enable \n
    cat "$bbb"
  done
done

echo "finished printing"
```


## bash code snippets

### check positional parameters

```sh
if [[ $# eq 0 ]]; then
    echo "provide a xxxxx"
    exit 1
fi
```
