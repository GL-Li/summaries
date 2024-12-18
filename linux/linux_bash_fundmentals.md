# Linux environment

## Environmental variables
`export`: to create a new environment variable or send an existing variable to global environment. The environment variable is available to all sub-sessions.

```bash
# create a new environment variable
export AAA="bbbb"  

# send a existing variable to global environment
BBB="bbbbb"
export BBB
```

To view all environment variables in current Linux session, run
- `$ env`

To remove an environment variable from current session, run
- `$ unset AAA`


## .profile vs .bashrc
Manage shell environments.

Loading order:
- `.profile` is sourced when logged into a system.
- `.bashrc` is sourced every time opening a terminal that is not log in.
- To ensure `.basrc` is also loaded at log in, add the following conditional sourcing to `.profile`
    ```sh
      # Source .bashrc if it exists
      if [ -f "$HOME/.bashrc" ]; then
        . "$HOME/.bashrc"
      fi
    ```

Typical use cases
- `.profile`: setting up environment variables
    ```sh
      # add $HOME/bin before existing $PATH
      export PATH="$HOME/bin:$PATH"
      # Environment variables
      export EDITOR='nano'
      export JAVA_HOME='/usr/lib/jvm/java-11-openjdk'
    ```
- `.bashrc`: alias, functions, and others that are only used in interactive terminal session
    ```sh
      # Aliases
      alias ll='ls -la'
      alias grep='grep --color=auto'
      # Prompt customizations
      PS1='[\u@\h \W]\$ '
      # Source other scripts
      source ~/.bash_aliases
    ```



# Core concepts and operations
Do not rely on specific utilities.

## Shell expansion
Shell expansion enables complex values using simple simbols. 

### brace expansion using {}

**Note**: no space between elements in `{}` in brace expansion.

```shell
touch {a,b,c}_{1,2,3}.{txt,pdf} # create files a1.txt, a2.txt, ..., c3.pdf
rm {*.txt,*.pdf}                # delete all txt and pdf files
echo a{11,22,33}b               # generate a11b, a22b, a33b
echo {10..1}                    # 10, 9, 8, ..., 1
echo {a..h}                     # a, b, c, d, e, f, g, h
echo {1..10..3}                 # 1, 4, 7, 10
echo {a..h..2}                  # a, c, e, g
echo month_{01..12}             # month_01, month_02, ..., month_12
```


### tilde expansion for directories
`~user_2`, `~+`, `~-`. ~ not in quote, use `$HOME` if have to

- `~` for home directory
- `~root` for user root's home directory
- `~+` for `$PWD`
- `~-` for `$OLDPWD`

```shell
# to switch back and forth between two directories
$ cd ~-     # to previous
$ cd ~-     # switch back
```


### variable / parameter expansion
`$x` returns the value of variable `x`.

Examples:
```shell
x="aaa  bbb"
echo $x
```


### command substitution 
Output the result of a command.

use round `()` instead of curly `{}`.

```shell
# command substitution
echo "Hello $USER, the time right now is $(date +%H:%m:%S)"

# assign command substitution to a variable
time=$(date +%H:%m:%S)  # use time to substitute command date and its format
echo "Hello $USER, the time right now is $time"
```

### arithmatic expansion
Add, subtract, multiply, divide, module for integers

Math expression in `$(())`. **Only work with integers**.

- `+`, `-`, `*`, `/`, `**` (exponential), `%` (remainder),

```bash
echo $((3 + 4))   # print out 7
echo $(( (1 + 3) * 5 ))  # 20
x=9
y=3
echo $(($x / $y))  # print 3
echo $((x / y))  # save some typing
echo $((8 / 3))  # print 2 !!!!!!!!!!!!!!!!!!
```

### file name expansion
Using wildcards `*`, `?`, and `[` in file / directory names

**Note**: these wildcards only work in pathnames like file and directory names. `/` in pathname cannot be matched. Wildcards are similar to, but not, regular expressions.

- `*` any number of strings
- `?` any single character
- `[abcd]` any one character in string "abcd"
- `[!abcd]` any one character not in string "abcd"

```shell
man ? glob          # manual page of wildcard matching
grep abc *.R        # find lines containing "abc" in all .R files
grep abc file?.R    # find lines containing "abc" in file1, fileA, ...
grep abc file[0-3]  # find lines containing "abc" in file0, ..., file5
```


### process expansion / substitution
The output of a command is treated as a temporary file witn `<(command)`.

example:
```shell
diff <(ls /path/to/dir_1) <(ls /path/to/dir_2)
```


## Command processing

### 5 steps to process command line

- tokenization
- command identification
- shell expansions
  - stage 1: brace expansion
  - stage 2:
    - parameter expansion like `$myname`
    - arithmetic expansion like `$((1 + 2))`
    - command substituion like `$(ls -ltr)`
    - tilde expansion like `~gl`, `~root`
  - stage 3: word splitting at `$IFS`
  - stage 4: globbing filepath with wildcards
- quote removal
- redirections

### quoting, single quote and double quote are different

Quoting is about removing special meanings. Backslash removes special meaning of next character, single quote remove all inside, double quote removes all but dollar sign `$`, backtick `, and those in **command substitution**.

- `\`: next character
- `'xxxxx'`: all characters inside
- `"xxxxx"`: all character except dollar signs `$` and backtick and command substitution.

```shell
echo aaa \& bbb # print aaa & bbb, backslash \ removes special meaning of &
filepath="C:\Users\xxx"   # or single quote
echo "My $filepath"       # double quote only as we have $
```

### token, metacharacter, word, operator

- Token is a sequence of characters that is considered as a single unit by the shell.
- metacharacter: special character include `|`, `&`, `;`, `(`, `)`, `<`, `>`, space, tab, and newline.
- word: token that does not contain any unquoted metacharacters
- operator: token that contains at least one unquoted metacharater

```shell
# in the command below, the metacharacters include three spaces and one >.
# words include echo, $NAME, and file.txt
# operator is >
$ echo $NAME > file.txt
```

### simple command, compound command

**simple command**s: one line command, separeted by control operators

```shell
echo a b echo c d  # print a b echo c d. The command is terminated by newline
echo a b; echo c d # print a b then c d. The two commands are terminated by ";" and new line respectively
```

**compound commands**: such as if statement and loops

```bash
if [[ 2 -gt 1]]; then
  echo "hello world"
fi
```

### brace expansion cannot contain any other expansions

Expansion in later stage cannot be used in expansion in early stage.

- stage 1: brace expansion, which mean no other expansion used in brace expansion
- stage 2:
  - parameter expansion like `$myname`
  - arithmetic expansion like `$((1 + 2))`
  - command substituion
  - tilde expansion
- stage 3: word splitting
- stage 4: globbing

```bash
# exemple below will not print 1,2,...,10 as brace expansion occurrs before arithmetic expansion.
x=10
echo {1..$x}  # print {1..10} instead of 1 2 3 4 5 6 7 8 9 10
```

### word splitting, use quote if not wanting word splitting

**Word splitting** is a process the shell performs to split the result of some unquoted expansions into separate words at `$IFS`. Only  performed on the results of unquoted parameter expansions, command substitutions, and arithmetic expansions.

**IFS (internal field separator)**: by default it contains space, tab, and new line, so it is invisible if we check with `$ echo $IFS`.

```shell
# to view IFS, using @Q to view quoted output
$ echo ${IFS@Q}  # print ' \t\n'
```

**Examples**

```shell
# use default IFS
$ aaa="a b c"
$ touch $a.txt    # create 3 files named "a", "b", and "c.txt", ".txt only with c
                  # equivalent to $ touch a b c.txt
$ touch "$a.txt"  # "a b c.txt" as "$a.txt" is quoted
$ touch "a b c"  # only one file named "a b c". No word splitting as "a b c" is quoted

# change IFS
$ bbb="1,2,3"
$ touch $bbb   # create single file "1,2,3" with default IFS
$ IFS=","      # set IFS to "," for current session, but it does not change $IFS
$ touch $bbb   # create 3 files, 1, 2, and 3
$ unset IFS    # to cancel IFS=","
```

### quote removal, use quote whenever possible

During quote removal, the shell removes all unquoted backslashes, single quote, and double quote that did not result from a shell expansion.

```shell
echo \$HOME  # print $HOME, unquoted backslash is removed
echo '\$HOME' # print \$HOME, single quote removed but backslash not as it is quoted
echo "C:\Users\gl\Downloads"  # correct path
```


### shell operators - execution order and precedence
Among the three types of operators:
1. grouping and subshells `(...)`: highest precedence
2. redirection `>` and `2>`: second highest precedence
3. logical operators `&&` and `||`: lowest 

There are several other operators. If not sure which one come first, group commands in `(...)` to clarify the relationships.

Example
```shell
# the following has two command: ls and llll > stdut.log 2> stderr.log.
# therefore, output of ls is not redirected to stdout.log
# command llll doest not exist, will have a stderr
ls && llll > stdout.log 2> stderr.log

# to redirect the stdout of ls to stdot.log, use command below
(ls && llll) > stdout.log 2> stderr.log
```



### control operators `&&` `||` `;`  `\` `;;` `;&` `;;&` `|&` `(` `)` `|` new line

- `command1 && command2`: command2 runs only if comand1 has exit status 0.

  ```shell
  cd /root && echo ok  # bash: cd: /root: Permission denied
  ```

- `command1 || command2`: command2 runs only if command1 has non-zero exit status.

  ```shell
  $ cd /root || echo ok  # bash: cd: /root: Permission denied
                         # ok
  ```

- `command1; command2`: run command1 and then command2 no matter what the exit status of command1

  ```shell
  $ cd /root ; echo ok       # bash: cd: /root: Permission denied
                            # ok
  $ cd ~/Download; echo ok  # ok
  ```

- `command1 &`: when ampersand `&` is at the end of a command, the command will run at background while you use the terminal for new commands

  ```shell
  sleep 10 &     # sleep 10 sec and the terminal is ready for new command
  sleep 10 & ls  # ls does not wait for sleep to finish
  ```

- `command \`: end of line backslash indicates command input continuous on next line

  ```shell
  $ ls \
  > -ltr    # the two line equals to $ ls -ltr
  ```



## streams - stdin, stdout, stderr

### redirection, data streams, `<` `>` `>>` stdin stout, sterr

**Three streams**: each command has stdin 0, stdout 1, stderr 2

**Examples**:

```shell
# 0< for direct input to command, where 0 or both 0< can be ignored
$ cat 0< file.txt  # ok
$ cat < file.txt   # ok, simplified
$ cat file.txt     # ok, simplified
$ 0< file.txt cat  # ok
$ < file.txt cat   # ok
$ file.txt cat     # not working, file.txt treated as command

# 1> 1>> redirects output to a file, one can be removed
$ echo "xxx" 1> output.txt
$ echo "xxx" > output.txt

# 2> 2>> redirect error message to a file
$ cd /root  # bash: cd: /root: Permission denied
$ cd /root 2> error.txt  # error message saved to error.txt
$ cd /root 2> /dev/null  # when a file is sent to /dev/null, it is just deleted

# &> redirect both stdout and sterror to a file
$ cd /root &> stdoutstderr.txt
```

### tee: redirect to file while printing on terminal

```bash
# redirect stdout while print stdout and stderr
(ls && llll) | tee stdout.log
# redirect stderr while print both
(ls && llll) 2> >(tee stdout.log)  # >(...) use process substitute
# redirect both while printing, &1 for stdout file descriptor
(ls && llll) 2>&1 | tee std.log
```

### How is stream passed through pipe `|`

For most command in `command_1 | command_2`, the stdout of command_1 will be passed as stdin for command_2.

Above command is equivalent to `command_1 | command_2 -`, where the dash `-` represent the stdout of `command_1`, or represent stdin of `command_2`. It can be ignored.

However, for `vim` the dash is required, for example `ls -ltr | vim -`, in which `vim` must be followed by a dash.



## Bash scripts

### positional parameters $1, $2, $3, ..., ${10}, ${11},
  Allow bash script to read arguments from terminal. Note that when there are over 10 positional parameters, put double digit into {}. Otherwise the shell will interpret it as $1 and 0. Better keep the number of positional parameters no more than 9.

  **example**:

  Create file and save it as testPosParam

  ```bash
  #!/bin/bash
  echo "The first parameter is $1"
  echo "The second parameter is $2"
  echo "The third parameter is ${3:-999}"  # set default 999 if not given, otherwise empty
  ```

  Run from terminal

  ```shell
  $ bash testPosParam 123 abc  # The first parameter is 123
                               # The second parameter is abc
                               # The third parameter is 999
  ```

### special parameters `$#`, `$0`, `$*`, `$@`, `"$@"`, `"$*"`

**$#**: number of positional parameters, can be used to specify number of positional parameters as condition

**$0**: when used in a bash script, it is the name of the script file.

```bash
#!/bin/bash

if [[ $# -ne 2]]; then
 echo "You did not enter exactly 2 parameters"
 echo "Usage: $0 param1 param1"
 exit 1
fi
```

**$@**: refer to all positional parameters $1 $2 ... $N. Let's save the script below as `dollarat` and run it as

 `$ dollarat "monthly sales" "annual report"`

and see what we get.

```bash
#!/bin/bash

echo $@      # print monthly sales annual report
echo "$@"    # print monthly sales annual report
touch $@     # create four files: monthly, sales, annual, report, allow word splitting
touch "$@"   # create two files" `monthly sales` and `annual report`
```

**`$*`**:   unquoted `$*` is the same as `$@`. Quoted `"$*"` represent "S1,$2,..,$N"

```bash
echo $*      # print monthly sales annual report
IFS=,
echo "$*"    # print monthly sales,annual report. Separate by IFS instead of space, no splitting
```

**application example**: calculate from command line. Save the script as `calculate` and run

`$ bash calculate 1 + 6 - 3`

```bash
#!/bin/bash

echo $(( $@ ))  # $@ replace whole thing 1 + 6 - 3
```

### read command for interactive input, options -p, -t, -s

The input is saved in `$REPLY` shell variable or custom variables

- `-p`: add prompt
- `-t`: time out option, expire if no input within the time limit
- `-s`: secret option, the user input will not show in terminal
- `-N 4`: input must be 4 characters.
- `-n 4`: input up to 4 characters

```shell
# saved in $REPLY
$ read        # presss enter and enter aaaaaaaaa
$ echo $REPLY # print aaaaaaaa

# saved in animal1 aninal2
$ read animal1 animal2 # press enter and input two values cat dog
$ echo $animal1        # print cat
$ echo $animal2        # print dog

# prompt
$ read -p "The first animal: " animal1
$ read -p "The second animal: " animal2
$ echo $animal1
$ echo $snimal2
```


### `select ... in ... do ... done`, space is the delimiter, not `,`

Select from options each separated by space, not `,`.  Keep in quote if not want to split a option.

```bash
PS3="What is the day of the week?: "       #$PS3 for the shell prompt of select
select day in Mon Tue Wed Thu Fri Sat Sun; do
 echo "The day of the week is $day"
 break    # to break the do - done loop, other wise loop back to select.
done
```

### test commands and operators, `[ space=around ]` or `[[ ... ]]`, `!` to negate
Space is required in `[ ` and ` ]` or `[[ ` and ` ]]`.

Return exit status 0 if true, exit status 1 if false.

**integer test operators** only for integers eq ne gt lt geq leq

```bash
[ 2 -eq 2 ] ; echo $?    # 0
[ ! 2 -eq 2 ] ; echo $?  # 1, ! for not
[ 2 -eq 3 ] ; echo $?    # 1
```

**string test operators**, =, !=, -z, -n

```bash
a=hello
b=world
[ $a = $b ] ; echo $?
[ -z $c ] ; echo $?       # -z to check if empty or null string
[ -n $a ] ; echo $?       # -n to check if string exists
```

**file test operators**, -e, -f, -d, -x, -r, -w

```shell
[[ -e file1 ]]   # check if file1 exits
[[ -f fname ]]   # check if a regular file, not directory
[[ -d fname ]]   # check for directory
[[ -x fname ]]   # check for executable file
```

### if ... elif ... else ... fi

if statement check the exit status of a  command

```bash
# dummy example
if [ 2 -gt 1 ] ; then
 echo "test passed"
elif [ 2 -eq 0 ]; then
 echo "test passed"
elif [ 4 -ne 6 ] && [ 7 -lt 8 ]; then   # each [] for one simple test
 echo "random try"
else
 echo "test failed"
fi

# example 2
a=$(cat file1.txt)
b=$(cat file2.txt)
c=$(cat file3.txt)
if [ $a = $b ] && [ $a = $c]; then
 rm file2.txt file3.txt
else
 echo "Files do not match"
fi
```

### `case ... esac`, double quote, `;;` and `)`

Must put variable in double quote to prevent word splitting, each case must end with `;;`, which is a specific operator only for `case` statement.

```bash
read -p "Please enter a number: " number
case "$number" in
 [0-9]) echo "you have entered a single digit number";;
 [0-9][0-9]) echo "you have entered a double digit number";;
 [0-9][0-9][0-9]) echo "you have entered a three digit number";;
 *) echo "You have entered a number that is more than three digits";;
esac
```

### `while` loop

```bash
read -p "Enter your number: " num

while [ $num -gt 10 ]; do
 echo $num
 num=$(( $num - 1 ))
done
```

### `getopts`, define options for bash script

Save the code as fc_converter, which convert temperature between F and C. The command has two options: `-c` and `-f`. The value of the option is stored in `$OPTARG`.

```bash
#!/bin/bash

# define options here, allow -f and -c, 
# selection passed to variable temp_unit and
# value is passed to OPTARG
while getopts "f:c:" temp_unit; do    
 case "$temp_unit" in
  c) result=$(echo "scale=2; ($OPTARG * (9 / 5)) + 32" | bc);;
  f) result=$(echo "scale=2; ($OPTARG -32) * (5 / 9)" | bc);;
  \?) ;;   # for any other single character
 esac
done
echo "$result"
```

Run the command as

```shell
fc_converter -c 0   # 32
fc_converter -f 32  # 0
```

**example**: count down by seconds from an input minutes (-m) and seconds (-s).

`$ bash countdown -m 1 -s 9`

```bash
#!/bin/bash

# the code block adds up all time from selection -m and -s
time=0
while getopts "m:s:" opt; do
 case "$opt" in
  m) time=$(($time + 60 * $OPTARG));;
  s) time=$(($time + $OPTARG));;
 esac
done

while [ $time -gt 0 ]; do
 echo $time
 sleep 1s
 time=$(( $time - 1 ))
done

exit 0
```

### read-while loop to iterate over the lines of files or process substitution `<( command )`

process substitution: `<(command)`

This is fixed struct

```bash
# read line by line of a file
while read line; do
 # do whatever by each line here
 echo "$line"
done < "$1"      # put input file here

# read line by line of a command output using process substitution
while read line; do
 # do whatever by each line here
 echo "$line"
done < <( ls $HOME)
```

### indexed array

Index starts from 0.

```shell
$ number=(111 222 333 444)
$ echo $number    # only first element 111
$ echo ${number[2]} # third element 333
$ echo ${number[@]} # all element
$ echo ${number[@]:1}  # from second element to the end, slicing
$ echo ${number[@]:1:2} # two elements from the second
$ number+=(555)  # add new element to the end
$ unset number[2] # delete the third element, it also deleted the index 2.
                  # the remaining index are 0 1 3 4
$ echo ${!number[@]}  # check index
$ number[0]=999   # change a element

```

### `readarray` to generate index arrays

Read standard input into an array line by line. Each element has a `\n` at the end, which may mess up with string processing.

- `-t` to remove trailing `\n`

```shell
# read from a file
$ readarray days < weekday.txt
$ echo ${days[@]}
$ echo ${days[@]@Q}  # show the raw string, which ends with \n

# the prefered readarray
$ readarray -t days < weekday.txt

# read from other command output using process substitution, space between < <
$ readarray -t files < <(ls)
```

### for loop, on-the-fly list, array, no quote for index

When use the index of an array in for loop, do not quote it.

```bash
# using on-the-fly list
for element in first second third; do
 echo "This is $element"
done

# using array
readarray -t files < <(ls)
for file in "${files[@]}"; do
 if [ -f "$file" ]; then       # "" to avoid word splitting
  echo "     File: $file"
 elif [ -d "$file" ]; then
  echo "Directory: $file"
 else
  echo "  Invalid: $file"
 fi
done

```

**Example**, loop over array index

```bash
#!/bin/bash

readarray -t urls < urls.txt
readarray -t fnames < <(cut urls.txt -f 2 -d ".")
indeces=${!urls[@]}
for idx in ${indeces[@]}; do               # no quote, otherwise just "0 1 2 ...".
 fname="${fnames[$idx]}.txt"            # We want word split here
 curl --head "${urls[$idx]}" > "$fname"
done

exit 0
```


# ---
# Basic utilities
Frequently used utilites that need to internalized in brain.

## Manage Linux system

### timedatectl to set system time

The ultimate solution is to install ntp

- `$ sudo apt install ntp` which installs ntp services and it is enabled automatically. The system should be able to sync with the standard time.

Ways to check and manually set

- `$ timedatectl` to show system time
- `$ sudo timedatectl set-time 2023-02-29` to set date
- `$ sudo timedatectl set-time 17:23:55` to set time

### systemd/systemctl to automatically start a service

**Use case**: docker is not automatically started in some Linux distros. User will have to manually start it with `sudo service docker start` to start it.

**What is systemd**:
- `systemd` is the first program to run when a Linux computer starts. It mamages all services at start.
- **ref: youtube video**: [Systemd Deep-Dive: A Complete, Easy to Understand Guide for Everyone](https://www.youtube.com/watch?v=Kzpm-rGAXos)

**Most commonly used systemd commands**
- `$ systemctl status docker` to check the status of a service
- `$ sudo systemctl start docker` to start a service
- `$ sudo systemctl stop docker` to stop a running service
- `$ sudo systemctl restart docker` to restart a stopped service with the same configuration
- `$ sudo systemctl enable docker` to start the service when the computer starts
- `$ sudo systemctl disable docker` to stop starting the service when computer starts


## Work with network

### ssh key for github or any Linux server

**ssh for github**:
    - `$ ssh-keygen -t rsa` to generate public key. Just press enter when asked for setting passwords. The key file is saved in `~/.ssh/` by default
    - `$ cat .ssh/id_rsa.pub` to view and copy the public key.
    - To use it in github, for example, go to github seetings --> SSH and GPG keys to add a new SSH key and paste the public key.
    - The computer is ready to clone repos in your github account
**ssh public key for linux server**:
    - `$ ssh-copy-id xxx@192.168.1.111` to copy this computer's ssh public key to file `autorized_keys` in server's `~/.ssh/` directory. Need password.
    - `ssh xxx@192.168.1.111` to connect. No password asked.

### set up computer so can be connected with ssh

- Install on Debian host:
  - `$ sudo apt install openssh-server`
  - `$ sudo systemctl status ssh` to check status. Should be automatically enabled after installation.
- Install on Ubuntu host:
  - `$ sudo apt install openssh-server` on the host computer
  - `$ sudo systemctl enable openssh` if not enabled automatically after installation
- Install on Fedora host:
  - `$ sudo dnf install openssh-server`
  - `$ sudo systemctl enable sshd`. It is named as `sshd`
- From client
  - `$ ssh usrname@192.168.0.12` to ssh to the host computer from another computer.

### remote server, ssh, scp

```shell
ssh usename@12.345.678.90
scp /path/to/local/file username@12.345.678.90:/path/to/remote/directory
scp username@12.345.678.90:/path/to/remote/file /path/to/local/directory
```




## Work with hardware

### mount and unmount a drive
In a Linux without desktop enabled, the system cannot recognize the newly plugged USB drive or other block devices. This is the time `mount` is used to mount the device to the file system.

**View mounted drives**:
```shell
lsblk
```

**Unmount a partition**:
```shell
sudo umount /dev/sdb1
```

**Rename the directory name of a mounted system**: simply rename the directory
```shell
sudo mv oldname newnam
```

**Mount a new hard disk**: To mount a hard disk to  `/mnt/d/`.
```shell
# create directory
$ cd /mnt/
$ mkdir d
# check available disks to mount
$ sudo fdisk -l    # find disk such as /dev/sdb
# mount disk to direct d
$ sudo mount /dev/sdb1 /mnt/d    # sdb1, the first of sdb.
```

### burn an iso image onto a USB drive

- Run `$ lsblk` to check which is the USB drive, for example, `/dev/sdd/`
- `sudo dd bs=4M if=archlinux-2023.09.01-x86_64.iso of=/dev/sdd status=progress oflag=sync` to burn the iso image to USB.
  - be extremely careful. If a wrong disc, the data on the disc will be wiped out
  - explain:
    - `dd`: command that converts and copies a file
    - `bs`: block size
    - `if`: input file, an arch linux iso image in above example
    - `of`: output file. Device is a file in Linux


## Work with directories and files

### Search directories, files, and file contents

#### locate to search path names
`locate` search all path names in a database, which is updated one time a day. To search for new files, update the database.

- `-i` ignore case
- `-e` check the file actually exists

```shell
# install mlocate if updatedb not found
$ sudo updatedb         # update database before search by locate
$ locate abc            # search path name containing "abc"

# to use wildcard in search path, the path must represent full path
$ locate abc*.md        # the path start with abc and end with .md
$ locate *abc*.md       # the path contains abc and end with .md
```

#### find to search files by name, type, size,
**`find` has many options**

- `-maxdepth 2` search up to second level, only one `-`, not `--`
- `-type f` show only files, `-type d` only directories
- `-name "file.txt"` search by name, must be exact file or directory name or using wildcards, not partial string
- `-size +100k`  file size > 100k, `-size +100k -size -1M`  size in 100k - 1M, `-size -100k -o -size +1M` size < 100k or > 1M.

```shell
$ find                        # show all diretories and files in current diretory
$ find eee/                   # list everything in eee/
$ find -name "*01"            # find path end with 01, quote to
                              # avoid shell expansion.
$ find -type d | grep src     # find all directories having src in the path
```

**find files and execute on the found**

- `{}`: placeholder for files found
- `-exec` or `-ok`,  perform command on each file found.
- `\;`, end the execution of one file and then start execution of another one
- `+`: run execution on all files at once if possible.
- works with standard input and output.

```shell
# use quoted filenames
$ find -name "file1*" -exec cp {} copy_to_folder \;
$ find -name "file1*" -ok cp {} copy_to_folder \;    # to confirm for each file
$ find -name "file1*" -ok cat {} \;                  # print files on terminal, y or n
$ find -name "file1*" -exec cat {} +
$ find -maxdepth 1 -name "*.R" -exec vim {} \;  # open one by one
$ find -maxdepth 1 -name "*.R" -exec vim {} +   # open all in buffer

# append a line to all found files. sh -c for shell command
$ find -name "file1*" -exec sh -c `echo "abc 123" >> {}` \;

# insert "abcd efg hijk" before the first line of all found files
find -name "file?" -exec sh -c 'sed -i "1 i\abcd efg hijk" {}' \;

# delete all directories starting with "xtmp" that are not accessed within 2 weeks 
- `$ find /mnt/d/ -type d -name "xtmp*" -atime +14 -exec rm -rf {} +`
```

#### grep recursively

```shell
grep -r "Linux" --include=*.R --exclude=*model*  # all .R files that do not have "model" in path names under current directory
```

### compress files and directories

#### tar command, tarball, archive, compression

Create a tar ball

- `-c` create a new archive
- `-v` verbose
- `-f`, `--file=ARCHIVE` use archive file
- `-z` compress with `gzip`
- `-j` compress with `bzip2`

```shell
tar -cvf xxx.tar file1 file2 ...
tar -cvzf xxx.tar.gz file1 file2 ...
tar -cvjf xxx.tar.bz2 file1 file2 ...
```

To preserve the directories, for example, if we want to only back up `OneDrive` in home directory, we can create a bash script:

```shell
# first go to parent directory of OneDrive
$ cd ~/
# compress the all in the directory. When decompressed, we get a folder OneDrive.
tar -cvzf /mnt/work/backup/onedrive/onedrive.tar.gz OneDrive/*

```

View files in a tarball

- `-t`, `--list` list names in a tarball

```shell
tar -tf xxx.tar
```

Extract from a tarball

- `-x` extract files

```shell
tar -xvf xxx.tar
tar -xvzf xxx.tar.gz   # extract file from gzip compressed tar ball
tar -xvjf xxx.tar.bz2  # extract file from bzip2 compressed tar ball
tar -xf xxx.tar.gz -C path/to/folder  # extract to specific folder
```

#### Linux: gzip, bzip2 to compress tar balls
Not for Windows and Mac

`gzip` is faster but less compression

```shell
gzip xxx.tar      # will create xxx.tar.gz and delete xxx.tar
gunzip xxx.tar.gz # get xxx.tar back and delete xxx.tar.gz
```

`bzip2` usually gets more compression but slower

```shell
bzip2 xxx.tar         # change to xxx.tar.bz2
bunzip2 xxx.tar.bz2   # get back xxx.tar
```

#### zip files for share to Windows and Mac users

```shell
zip xxx.zip file1 file2 ...
unzip xxx.zip
```
To view the files and folders of a .zip file before extraction?

- `unzip -l xxx.zip` to list all files and directories
- `unzip -p xxx.zip file1` to see file1 in stdout



### chmod to channge file permission

- Understand rwx in `$ ls -l`
  - d: directory, if `-`, then a file
  - r: read
  - w: write
  - x: execute

  ```
  # owner group others
  drwxr-xr-x  2 gl gl  4096 Oct  8 10:57 Videos
  -rw-rw-r--  1 gl gl 19842 Dec  4 17:30 weekly-EMA-200-20-9.tpl
  ```

- change permission with `chmod` exemple

  Let's start with a file permission as

  ```
  -rw-rw-r-- 1 gl gl    0 Dec  8 07:59 file1
  ```

  `$ chmod 760 file1` will change it to (7 for owner, 6 for group, 0 for others)

  ```
  -rwxrw---- 1 gl gl    0 Dec  8 07:59 file1
  ```

- `chmod` code

  - 0: no permision
  - 1: execute only
  - 2: write only
  - 3: write + execute (1 + 2)
  - 4: read only
  - 5: read + execute (4 + 1)
  - 6: read + write (4 + 2)
  - 7: read + write + execute (4 + 2 + 1)


## Other popular utilities
These utilities are either simple to use, or I just need part of their functionalities.

### cut strings
cut substring with a delimiter, input is from a file or stdout, not from a string. if have to use cut on a string, use `echo` to pipe the string to `cut` like `echo "$aaa_string" | cut -f 2 d ,`.

  ```bash
  echo "abc.def.ghi" | cut -f2 -d "."  # def
  cut xxx.txt -f2 -d "."               # cut line by line
  cut "abc.def.ghi" -f2 -d "."         # error, string not an argument
  ```

### sort to sort lines

- `-r` reverse
- `-n` by numerical value
- `-u` show only unique values
- `-h` by human readable data
- `-M` by month Jan, Feb, ...
- `-k n` sort by nth column of table data

```shell
ls -l | sort -k 5 -n   # sort by the 5th column
ls -lh | sort -k 5 -h  # sort by the 5th column by using human-readable value
```

### date
Format date with +, %y, %Y, %b, %m, %d, %a, %H, %I, %M, %S, use plus sign and quote. Check help page if not sure.

```shell
# need + before format
$ date %Y  # date: invalid date ‘%Y’
$ date +%Y # 2022
$ date +"%Y %b"  # 2022 Dec, format in quote
$ date +"%H:%M:%S"  # 10:45:32
```

### man, help, info

Check internal (builtin) or external command using `type`

```shell
$ type -a cd  # cd is a shell builtin   (internal)
$ type -a shellcheck # ls is aliased to `ls --color=auto'
                     # ls is /usr/bin/ls  (external)
                     # ls is /bin/ls
```

- help: for internal command

- man: for external command only, complete manual

  - search command by keywords in its role

    ```shell
    man -k compress    # search command by keywords compress
    ```

- info: for external command only, more information with links to other sources

### diff, sdiff, colordiff
To quickly check if the two files are the same
`$ diff path/to/file1 path/to/file2`

Use command `sdiff -s -w 200 pea1.R pea1_rosa.R | colordiff`, where

- sdiff shows the difference
  - `-s` difference only
  - `-w 200` 200 characters each line
- `color diff` show in color

### hostname to check hostname and ip address

- `$ hostname` to show hostname
- `$hostname -I` to show all IP addresses of this computer in local networks. They are not public IP addresses.

### curl/wget to download a file at terminal

For example, here is the file location of iris dataset: `https://gist.githubusercontent.com/netj/8836201/raw/6f9306ad21398ea43cba4f7d537619d0e07d5ae3/iris.csv`. To download it, we can use `curl` or `wget`:

- `curl -o $HOME/Downloads/ttttt.csv https://gist.githubusercontent.com/netj/8836201/raw/6f9306ad21398ea43cba4f7d537619d0e07d5ae3/iris.csv`
  - `-o` for output file
- `wget https://gist.githubusercontent.com/netj/8836201/raw/6f9306ad21398ea43cba4f7d537619d0e07d5ae3/iris.csv` to download `iris.csv` into current directory


### timeshift to back up a Linux system

Using `timeshift` app. To install, simply run `sudo apt install timeshift`. To use it

- `$ sudo timeshit --create` to create a snapshot
- `$ sudo timeshift --list` to list all snapshot
- `$ sudo timeshift --restore --snapshot "2023-06-13_07-37-08"` to restore to a snapshot named by date created.
- `$ sudo timeshift --delete --snapshot "2023-06-13_07-37-08"` to delete a snapshot.




# aaaaaa
Please explain the role of % in 
       mv "$file" "${file%.txt}.bak"

🤖:[ChatGPT4o]
The use of `%` in the Bash variable substitution `${file%.txt}` is a form of parameter expansion that allows you to modify the way part of a variable's value is interpreted.


```bash
mv "$file" "${file%.txt}.bak"
```

1. **Parameter Expansion Syntax:**
   - `${variable%pattern}` allows for the removal of the shortest match of `pattern` from the end of the value stored in `variable`.

2. **Role of `%`:**
   - In this context, `%` is used for suffix removal. If the `pattern` matches the end (suffix) of the `variable's` value, it is stripped off. This operation is non-destructive and does not change the original value of the variable itself.









## comments best practice: 5 pieces of information to start a script

```
# Authour:
# Date Created:
# Last Modified:
# Description:
# Usage:
```


## exit status

0 for no error, 1 - 255 for an error

- 0: sucess
- 1: operation not permitted
- 2: no such file or directory
- 3: no such process
- more are [here](https://www.cyberciti.biz/faq/linux-bash-exit-status-set-exit-statusin-bash/#:~:text=The%20exit%20status%20is%20an,returns%20a%20status%20of%20127.)


## variables and shell expansion

**User-defined variables**: By tradition, use lower case for user defined variables.

```shell
student="Sarah"  # NO spaces around "=" sign, otherwise bash treat student as a command
echo "Hello ${student}"  # ${} called shell expansion, curly bracket can be skipped if you are sure there is no space and special characters in $student. As a general rule, use {}
```

**Shell variables**: or called environment variables, usually in upper case, with special names. Common shell variables. $PATH, $HOME, $USER, $HOSTNAME, $PS1, $PWD, $OLDPWD, $?

- `$PATH`: or `${PATH}`, path of executables
- `$HOME`: absolute path to user's home directory
- `$USER`: current user username
- `$HOSTNAME`: computer name
- `$HOSTTYPE`: computer processor architecture type such as "x86-64"
- `$PS1`: string that defines what before the `$` sign in terminal, for exemple, `\[\e]0;\u@\h: \w\a\]${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[01;31m\] $(parse_git_branch)\[\033[00m\]\$`, very intimidating. It is defined in `.bashrc`. It is where to modify prompt style.
- `$PWD`: current working directory
- `$OLDPWD`: previous working directory
- `$?`: exit status of last command


## string upper case, lower case, string length, slice substring, concatinate strings, cut substring from stdin

- lower and upper cases

  ```shell
  name="John Doe"
  echo $name   # or ${name}, print name
  # to lower case
  echo ${name,} # first letter to lower case
  echo ${name,,} # all letters to lower case
  # to upper cse
  echo ${name^}  # first letter to upper case
  echo ${name^^}  # all to upper case
  ```

- length of the variable

  ```shell
  echo ${#name}  # "#" count the number of characters
  ```

- slice a string: position of characters in a string is **index** by 0, 1, 2, 3, ..., **from 0**

  ```shell
  echo ${name:3:5}  # substring of length 5 from the 4th character
  echo ${name:3}  # all from the 4th character, 3 + 1 = 4 so 4th
  echo ${name: -3:5} # start from 3rd counting from end. need a space before "-"
  echo ${name: -3}
  ```

- concatenate string: just treat each varaible as a string

  ```shell
  a="aaa"
  b="bbb"
  echo "$a/$b"   # print out aaa/bbb
  ```

- cut substring with a delimiter, input is from a file or stdout, not from a string. if have to use cut on a string, use `echo` to pipe the string to `cut` like `echo "$aaa_string" | cut -f 2 d ,`.

  ```bash
  echo "abc.def.ghi" | cut -f2 -d "."  # def
  cut xxx.txt -f2 -d "."               # cut line by line
  cut "abc.def.ghi" -f2 -d "."         # error, string not an argument
  ```


## Bash: math, bc for decimal numbers, numerical values

**bc**: basic calculator

```bash
echo "scale=4; 5/3" | bc   # print 1.6666
```

