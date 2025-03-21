## sed

Tutorial:
- https://alexharv074.github.io/2019/04/16/a-sed-tutorial-and-reference.html

Manual:
- https://www.gnu.org/software/sed/manual/sed.html


### use cases

- add double quote to word `abcxyz` in all text files
    - `sed -n 's/\(abcxyz\)/"\1"/gp' *.txt` to print out the changed lines for review
    - `sed -i 's/\(abcxyz\)/"\1"/g' *.txt` to change in-place
    - `sed 's/\(abcxyz\)/"\1"/g' *.txt` to print out all output lines even if no change
- delete lines containing `abcxyz` in `aaa.txt`
    - `sed '/abcxyz/d' aaa.txt` to show the output after deletion
    - `sed -i '/abcxyz/d' aaa.txt` to delete in-place
- keep lines containing `abcxyz` in `aaa.txt`
    - `sed '/abcxyz/!d' aaa.txt` to show the output for review
    - `sed -i '/abcxyz/!d' aaa.txt` to delete in-place
- keep lines containing `abcxyz` in `aaa.txt` and the first line
    - `sed '1p; /abcxyz/!d' aaa.txt` to show the output for review
    - `sed -i '1p; /abcxyz/!d' aaa.txt` to delete in-place
     



### concepts
- pattern space: buffers each line (without the trailing new line "\n") that is read from the input stream. The pattern space is usually deleted between cycles (lines).
- hold space: keep data between cycles.

### Structure of a sed script
select lines followed by one or more commands and their options:
- `[ADDR]{X[OPTIONS];Y[OPTIONS];Z[OPTIONS]}`

- `[ADDR]`: optional, used to select lines
    - by line number:
        - `sed -i 2d iris.csc` to delete the second line
        - `sed -i '$d' iris.csv` to delete the last line
        - `sed -n 2,5p iris.csv` to print lines 2-5
        - `seq 10 | sed -n '8,$p'` to print all lines from line 8.
        - `seq 10 | sed -n 2~3p` to print every 3 lines from the second line. `-n` for selected lines only. Tilt `~` as in `2~3`.
    - by matching condition inside `/.../`. `-n` is required to suppress automatic printing of pattern space so that only selected lines are printed.
        - `seq 30 | sed -n '/2$/p'`: print lines ending with "2"
        - `sed -n '/5.1/p' iris.csv`: print lines containing "5.1"
        - `seq 9 | sed -n '/6$/,/^1/p'`: print lines from the first match to the second match
            - if the second match does not exist, print from the first match to the end
            - if the first match does not exist, no selection
            - repeated match: for example `seq 30 | sed -n '/8$/,/^1/p'` matches
                - 8, 9, 10: first round match
                - 18, 19: second round match
                - 28, 29, 30: third round match where the second match does not exist so print until end.
    - by offset from a line
            - `seq 10 | sed -n 5,+2p`  print line 5, 6, 7
            - `seq 30 | sed -n '/2$/,+2p'` print three matches
                - 2, 3, 4
                - 12, 13, 14
                - 22, 23, 24
    - exclude lines with `!` after the line range
        - `seq 10 | sed -n '2,8!p'`   print 1, 9, 10, use single quote to escape `!`. Without the quote, `!p` treats `p` as a terminal command.
        - `sed -n '/^5/!p' iris.csv` print lines that do not start with "5"
        - `sed -i '/^5/!d' iris.csv` delete lines that do not start with "5"

- List of commonly used command
    - `=`
    - `a`
    - `c`
    - `d`
    - `e`
    - `i`
    - `l`
    - `n`
    - `p`
    - `q`
    - `Q`
    - `s///`
    - `y///`
    - `z`

### The `s` command (substitute)

Format:

- `s/REGEX/REPLACEMENT/[FLAGS]`
- `s@REGEX@REPLACEMENT@[FLAGS]`  the seperator `/` can be replaced with other characters for example `@`.

**replace strings in a file**

```sh
# replace in-place, with or sometimes without single quote arount s///g
sed -i 's/Setosa/hahah/g' iris.csv

# replace a file and print all lines to stdout
sed 's/hahah/xxxx/g' iris.csv

# replace a file and print only replaced lines to stdout, need both -n and /p
sed -n 's/hahah/xxxx/p' iris.csv
```

**replace string from stdout**

```sh
echo "aaa bbb aaa" | sed s/aaa/xxx/g  # xxx bbb xxx, replace all
echo "aaa bbb aaa" | sed s/aaa/xxx/g   # xxx bbb aaa, replace the first occurrance
```

**flags**

- no flags: replace the first matched pattern in each line
    - `sed 's/aaa/bbb/`
- `g`: replace all matched patterns
    - `sed 's/aaa/bbb/g`
- `n`: replace the nth match
    - `sed 's/aaa/bbb/2`   match the second match in each line
- `ng`: replace all matches from the nth one
- `i`: case-insensitive matching
    - `echo "Abc abc" | sed 's/a/xxx/gi'` print xxxbc xxxbc, both "a" and "A" matched and replaced

**back reference** using capture group

- `$ echo "James Bond" | sed -E 's/(.*) (.*)/My name is \2, \1 \2./'`

**back reference** using matched pattern

- `echo "fox foot" | sed -E 's/o+/&&&/g'` print fooox foooooot, where `&` represent a matched pattern.

**case conversion**

- common converters in REPLACEMENT:
    - `\U`: all to upper case
    - `\u`: first character to upper case
    - `\L`: all to lower case
    - `\l`: first character to lower case

- examples
    - `echo "foo bar foo baz" | sed -E 's/(foo)/\uaaa/g'`
        - print Aaa bar Aaa baz. In the replacement section, `\u` convert 'aaa' to 'Aaa'
    - `echo "foo bar foo baz" | sed -E 's/(foo)/\u\1/g'`
        - print Foo bar Foo baz. In the replacement, `\1` back references to matched pattern.

## awk

### awk field and separator
https://www.youtube.com/watch?v=oPEnvuj9QrI

- Records: each line is a record
- field: a line is seperated into multiple fields by space (default), that is, a word is a field.
    - example:
        - aaa.txt
            ```
            this is line1
            line2
            ```
        - `$ awk '{print $1,$3}'` prints the first and third fields. Empty if a field does not exist:
            ```
            this line2
            line2
            ```
- field seperator: we can set it to anything instead of the default space
    - `echo "Ihahaamhahahappy" | aws -F 'haha' '{print $1,$2,  $3, "!!!"}'` print I am happy !!!. The default seperator between printed fields is space.
- output field separator, `OFS`. We can change `OFS` so the output fields is seperated by other strings
    - `echo "Ihahaamhahahappy" | awk -F "haha" 'BEGIN {OFS="---"} {print $1,$2,$3}'` prints I---am---happy.

### awk built-in variables
https://github.com/adrianlarion/simple-awk

- `FILENAME`: the name of the current file being processed.
- `NR`: number of record, counted from all files
- `FNR`: file number of record, line number of current file being processed.
- `FS`: field seperator, default to space ' '.
- `IGNORECASE`: ignore case if 1, no if 0.
- `NF`: number of field (word) in a line
- `RS`: record seperator, `\n` by default.

### awk select lines

- `awk '/this/' aaa.txt`  print lines containing "this" in aaa.txt.
- `awk '$2 == "is"' aaa.txt` print lines whose second field is "is"
- `awk '$1 ~ /i/' aaa.txt` print lines whose first field matches pattern 'i'. Use `~` for pattern match and `!~` for not match.

### awk `printf` to format output

- `awk -F ',' '{printf "%15s %-15s %-10s\n", $5, $2, $3}' iris.csv`
    - `%15s`: total width 15 character, right aligned
    - `%-15s`: left aligned
    - line ending `\n` is required for new lines

### awk `BEGIN` and `END` block
The general pattern is `awk 'BEGIN {setup OFS and initialize variables} {process line by line} END {summarize results}' file.txt`.

- `awk -F "," 'BEGIN {count = 100} {count ++} END{print count}' iris.csv` total number of lines
    - set initial `count` in `BEGIN` block
    - increment line by line in middle block
    - print out final result in `END` block
    - `BEGIN` and `END` blocks are optional

### awk math

- `echo "4,2,5" | awk -F "," '{sum = $1 + $2 + $3; print sum}'` print 11
- `awk -F ',' '{cumsum = cumsum + $3; print cumsum}' iris.csv` cumulative sum of field 3, no need to initialize cumsum.
- `awk -F ',' '{cumsum = cumsum + $3} END {print "average =", cumsum / NR}' iris.csv` print average of field 3

### awk functions

- `substr($3, 1, 5)` to extract character 1 - 5 of a string field `$3`.
    - `echo "aaabbbccc" | awk '{print substr($0, 1, 5)}'`  print aaabb
    - `awk -F ',' '{printf "%15s %-15s %-10s\n", substr($5, 1, 5), $2, $3}' iris.csv` substring of field 5

## grep

### options

- `grep -E "[a-z]+::\w+" aaa.txt`: regular expression with `-E`
- `grep -h xyy aaa.txt`: skip file name in the output
- `grep -o xyz aaa.txt`: keep only the match in the output
- `grep -vE "^#" aaa.txt`: exclude lines starting with `#`.

### examples

List unique packages used in a project as specified by `xxxx::`

`grep -hE "[a-zA-Z\.]+::" * | grep -vE "^#" | grep -oE "[a-zA-Z\.]+::" | sort | uniq`

    
    
## tr
translate or delete **characters**.

**translate characters**

- `echo "Abc Def" | tr [a-z] [A-Z]`  to upper case ABC DEF
- `echo "Abc Def" | tr be XY` to AXc DYf, that is, treat be and XY as two arrays and map b -> X and e -> Y

**delete characters**

- `echo "Abc Def" | tr -d [a-z]` to delete all lower case characters
- `echo "Abb Effff" | tr -s bf` to squeeze duplicated b and f to a single character

## pass
password manager, https://www.passwordstore.org/

Following steps detailed in https://www.youtube.com/watch?v=FhwsfH2TpFA

- create GPG key pair if not already have one
    - `$ gpg --gen-key`
        - remember the master passphrase and never share with anyone else
        - a directory `$HOME/.gnupg/openpgp-revocs.d` created
        - `$gpg -K` to view the public key
        - `$ gpg --edit-key 01D414DB308B6CDD6D93AAABDE70199F0F16EE9D` to edit the key. Replace the public key from the output of `gpg -K`.
        - `gpg> expire` and select never expire. Master passphrase needed.
        - `gpg> save` and exit
    - export gpg keys into files for future use. Save in secured location.
        - `$ gpg --output public.gpg --armor --export lglforfun@gmail.com`
        - `$ gpg --output private.gpg --armor --export-secret-keys lglforfun@gmail.com`, require master passphrase
- install and initialize password store
    - `$sudo apt install pass`
    - `$ pass init 01D414DB308B6CDD6D93AAABDE70199F0F16EE9D`
        - replace the key with that showed in `$ gpg -K`.
        - the command above created subdirectory `.password-store`
    - `$ pass git init` to git version control of passwords
- generate password, for example, for github account
    - `$ pass generate githut/GL-Li`
        - a randomly generated password is created and stored in a subdirectory `.password-store/github/GL-Li`.
        - to view the password, `$ pass show github/GL-Li`, master passphrase required.
        - a git commit is aumatically added to the history
            - `pass git log` to view commit history
            - `pass git xxx` to run git command on the password repo. No need to switch to the repo. You can `$ cd .password-store`.
            - make a private repo on github or bitbucket for the repo
    - `$ pass insert bitbucket/myusername` to insert an existing password.
- use a password
    - `pass ls` to list all password entries.
    - `pass show -c github/GL-Li` to copy the password to clipboard and ready to paste.

- use the password store on another computer
    - import gpg keys to another computer
        - copy file `public.gpg` and `private.gpg` to the new computer
        - `$ gpg --import private.gpg` to import private key
        - `$ gpg --import public.gpg` to import public key
    - update trust level on the new computer
        - `$ gpg --edit-key lglforfun@gmail.com` to start gpg
            - `gpg> trust` and select `5` the ultimate trust and save
    - clone `mimadian` and rename it to `.password-store` to the new computer. Must have exactly the same directory name.

## cryptsetup
To encrypt USB drives, follow step in https://www.youtube.com/watch?v=ZNaT03-xamE

- encript a USB drive
    - `$ lsblk` to check the attached USB drive partition, for example `sdc1`
        - unmount it if it is mounted.
    - `$ sudo cryptsetup luksFormat /dev/sdc1` to encrypt the whole disc
        - remember the passphrase.
    - `$ sudo cryptsetup open /dev/sdc1 anyname` to decrypt the drive and create a drive  at `/dev/sdc1/anyname`
        - run `$ lsblk` to verify that `anyname` is under `sdc1`
    - `$ sudo mkfs.ext4 /dev/mapper/anyname` to create a ext4 file system on the `anyname` drive. Must use **/dev/mapper/anyname**.
- use the encrypted USB drive
    - when the USB drive is inserted, you will be prompted to enter the passphrase and the drive will be aumatically mounted to `/media/gl/fc3e5c7a-34a6-41fb-8c74-4eeb385b7805`, a randomly named directory.
    - if you do not like it, you can unmount it and the cryptsetup close it.
        - `$ sudo umount /media/gl/fc3e5c7a-34a6-41fb-8c74-4eeb385b7805`
        - `$ sudo cryptsetup close luks-2ba470a4-ac91-4036-a33e-d62d2e73a313` where the `luks-xxx` can be found with command `$ lsblk`.
    -  And then follow step below to crate a new name and remount
        - `$ sudo cryptsetup open /dev/sdc1 usb` to decrypt the drive and create a drive  at `/dev/sdc1/usb`. Yes, you can rename it to `usb` from `anyname`
        - `$ sudo mount /dev/mapper/usb /mnt/usb` to mount the USB drive to `/mnt/usb`. It works like a normal drive
        - `$ sudo umount /mnt/usb` to unmount the drive when all work done
        - `$ sudo cryptsetup close usb` to re-crypt the drive.

## timeshift for Debian and Ubuntu

Create a snapshot with comments `$ sudo timeshift --create --comments "Debian initial installation"`. The comments will show up in the Description section of `$ sudo timeshift --list`.



## Linux: crontab to schedule tasks, <https://crontab.guru/> for schedule, full path to executable script as cron restrict $PATH to /bin and /usr/bin

A cron task include six elements

- m: minute, 0-60 or * for any. Can be multiple values separated by ","
- h: hour, 0-24 or *
- dom: day of month, allowed day in the month or *
- mon: month, 1-12 or `*`, or JAN, FEB, ...
- dow: day of week, 0-6 or `*`, or SUN, MON, ..., SAT
- command: command to run

Create a crontab task that

- save "Hello World!" to hello.txt every Friday at 23:15.
- at 0 min and 30 min, set m to 0,15
- every three days, set dom to `*/3`
- every two hours, set h to `*/2`

```shell
crontab -e                 # open crontab to edit tasks, use full path to bash scripts
```

```
#  m    h    dom    mon    dow    command
  15   23      *      *    FRI    echo "Hello World!" >> ~/hello.txt
0,30  */4      *      *    FRI    ~/bin/backup_onedrive
```


## Bash: at command to schedule task

The `at` is a daemon service runs at background for simple and one-time schedules.

```shell
$ sudo apt install at  # install at

$ service atd status   # check if at is running
$ sudo service atd start  # start atd service, stop to stop

# to schedule tasks to run at background
$ at 9:30am  # press enter
> echo "Hello world"   # one task
> cp xxx bbb           # another task
> <EOT>                # end of scheduled task by ctrl D

$ at -l     # list scheduled job
$ at -r 2   # remove job 2

$ at 10:05am -f my_bash_script    # schedule to run a bash script
$ at 10:05am Monday -f my_bash_script
$ at 10:05am -f 12/23/2022 my_bash_script
$ at now + 5 min -f my_bash_script    # 2 days ...
```

## Bash: cron directories

**System cron directories** are in `/etc`. All executable scripts in each directory runs as shown in names like `cron.daily`, `cron.hourly`, `cron.weekly` and `cron.monthly`. The exact time can be found in file `/etc/crontab`.

- no dot include dot `.` in script names

**Custom cron directories** are easy to create. Follow steps below to create a folder in home directory to hold scripts that run at 2am each day

```shell
# step one: create a directory to store scripts to be run at a given time
$ mkdir cron.daily.2am
# then add a line to crontab
$ crontab -e
```

```
00 02 * * * run-parts path/to/cron.daily.2am --report
```

## reboot required after package upgrade

Check `/var/run/reboot-required.pkgs` for the list of packages that require reboot. For example, linux-base upgrade needs reboot.

We want to create a cron task that upgrades packages every day. We first need to create a bash script called `update_packages`:

```bash
#!/bin/bash
apt -y update
apt -y upgrade
# If `/var/run/reboot-required` file exists, reboot system after upgrade
if [ -f /var/run/reboot-required ]; then
 reboot
fi
```

As upgrade affect the whole system, we will modify `/etc/crobtab` to schedule this task by adding a line

```
0 0 * * * /path/to/update_script    # not use ~ for home as this file is in root.
```

For this to take effect, run

```shell
sudo service cron restart
```

## anacron

cron requires machine to be on at the scheduled time. anacron can pickup missed job when computer is turned on. anacron is scheduled in system file `/etc/anacrontab`. There is no user specific anacrontab. Edit this file

- change SHELL=/bin/bash

- add path to PATH

- cron.daily, cron.weekly, and cron.monthly are managed by anacron. So any missed tasks for scripts in these folders will run when computer is turned on.

- minimal time interval is a day, no hour and minute

- manually add a job

  run weekly (7), 30 mins after power on if missed, job identifier backup and script is backup_script, which must be in the PATH

  ```
  7 30 backup backup_script
  ```

- logs in `/var/spool/anacron`

## QA: how to replace string "abc" to "xyz" in all files in a directory?

- `$ sed -i 's/abc/xyz/g' *`

