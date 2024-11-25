## Bash script fundmentals

### Use `[[ ... ]]` over `[ ... ]`
- spaces after `[` and before `]` are required.
- `[[ ... ]]` is newer and more powerful, and can do all the tasks that `[ ... ]` can do in bash scripts.
- only advantage of `[[ ... ]]` is that it is compatable with other flavor of shell scripting such as `Sh (Bourne Shell)`, `zsh`, and `fish`.


### Regular expression in bash
`[[ $string =~ pattern ]]` operator chack if a string matches a regex pattern.

Bash regex engine does not support short-hand regex pattern like `\d` and `\D`. It support the following POSIX charater classes:
- `[:digit:]`
- `[:alpha:]`
- `[:alnum:]`
- `[:space:]`
- `[:punct:]`

Example: save the code below as bash-scripts/regex.sh and run it.
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

## bash code snippets

### check positional parameters

```sh
if [[ $# eq 0 ]]; then
    echo "provide a xxxxx"
    exit 1
fi
```
