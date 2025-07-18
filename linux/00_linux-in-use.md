## Linux distros in use

### Debian

Installation

- install from a USB drive
- create key bindings to quick start terminal with `Ctr Alt T`
  - Setting --> Keyboard --> View and Customize Shortchts --> Custom Shortcust --> Add Shortcut
  - Name: terminal, Command: gnome-terminal, and then set shortcut to Ctr Alt T
- add user to sudoers group
  - `$ su` # change to root user
  - `$ sudo adduser xxx sudo` # add user xxx to sudoers
  - `$ exit` # exit root user
  - The change will take effect next time user xxx logs in or restart the computer.
- (may not required in latest installation) delete the first line starting with `deb cdrom:[Debian ...` in file `/etc/apt/sources.list`. This line instructs `sudo apt install` to look for cdrom for packages, which block the installation when we do not have the cdrom.
- install autocompletion `$ sudo apt install bash-completion`
- Install openssh-server on Debian host:
    - `$ sudo apt install openssh-server`
    - `$ sudo systemctl status ssh` to check status. Should be automatically enabled after installation.
- install docker engine
  - following official instruction from docker to install docker
  - add user xxx to docker group
    -   `$ sudo gpasswd -a xxx docker`
    -   `$ newgrp docker`
    -   may need restart to take effect
- install build-essentials
  - `$ sudo apt install build-essential`
- install xclip for vim to copy to clipboard
  - `$ sudo apt install xlip`
- install Rust and Cargo using rustup
  - something like `curl --proto '=https' --tlsv1.2 -sSf https:gc/sh.rustup.rs | sh`
- install rig for R installation
  - install pak for fast R package installtion
- install timeshift for system backup
  - install with `$ sudo apt install timeshift`
    - `$ sudo timeshift --create` to create a snapshot
    - `$ sudo timeshift --list` to list all snapshot
    - `$ sudo timeshift --restore --snapshot "2023-06-17_07-34-09"` to restore to a snapshot
    - `$ sudo timeshift --delete --snapshot "2023-06-17_07-34-09"` to delete a snapshot
- install password mananger
  - `$ sudo apt install pass`  instruction https:gc/www.passwordstore.org/
  - passwords saved in `.password-store`.
- import gpg keys to the new computer and set it up for password manager. See section _gpg: file encryption_.
- create ssh for github and bitbucket
  - `$ ssh-keygen -t rsa` to generate keys. Use all blank settings.
  - copy `id_rsa_pub` content to github and bitbucket SSH setting
    - github: settings --> SSH and GPG keys --> New SSH key
    - bitbucker: settings --> Personal Bitbucket settings --> SSH keys --> add key
- clone configuration repo from github
  - copy vimrc_essentials to `~/.vimrc`
  - `bash copy2nvim.sh` to setup Neovim configuration
  - copy `.gitconfig` to `~/.gitconfig`
  - copy `bin/` to `~/bin/`
- install NeoVim and config it follow instructions in `vim-in-use`
    - `sudo apt install ripgrep` for telescope and fzf
- connect to OneDrive and download files
  - `$ docker_onedrive` # it is in `~/bin/`. follow the instructions to authroize the connection
- setup terminal to use Solarized Dark theme.



## Files and directories

### `chmod`: file permission

The most common file permissions are 

- 7: read, write, and execute
- 6: read and write
- 4: read only
- 0: no permission

Some typical permission to owner-group-other

- `chmod 600 file.txt`: good for sensitive files, only owners can read and write. No permission for anyone else.
- `chmod 644 file.txt`: if you want others to read it.
- `chmod 700 xxx.sh`: only the owner can run it.
- `chmod 744 xxx.sh`: only the owner can run it. Others can see the code.
- `chmod +x xxx.sh`: add executable permssion to everyone without changing other permissions.
- `chmod u+x xxx.sh`: add executable permission to owner only without changing other permissions.
- `chmod g+x xxx.sh`: add executable permission to group only
- `chmod o+x xxx.sh`: add executable permission to others only


### `gpg`: file encryption
`gpg` is used to encrypt files, including compressed files. Folders can be compressed into files for encryption.

- create GPG key pair if not already have one
    - `$ gpg --gen-key`
        - remember the master passphrase and never share with anyone else
        - a directory `$HOME/.gnupg/openpgp-revocs.d` created
        - `$ gpg -K` to view the public key
        - `$ gpg --edit-key 01D414DB308B6CDD6D93AAABDE70199F0F16EE9D` to edit the key. Replace the public key from the output of `gpg -K`.
        - `gpg> expire` and select never expire. Master passphrase needed.
        - `gpg> save` and exit
    - export gpg keys into files for future use. Save in secured location.
        - `$ gpg --output public.gpg --armor --export lglforfun@gmail.com`
        - `$ gpg --output private.gpg --armor --export-secret-keys lglforfun@gmail.com`, require master passphrase
- import gpg keys to another computer
    - copy file `public.gpg` and `private.gpg` to the new computer
    - `$ gpg --import private.gpg` to import private key, may need `sudo` and password
    - `$ gpg --import public.gpg` to import public key
    - update trust level on the new computer
        - `$ gpg --edit-key lglforfun@gmail.com` to start gpg
            - `gpg> trust` and select `5` the ultimate trust and save
- encrypt and decrypt files for self use
    - make sure you have gpg keys in the computer
    - `$ gpg --encrypt --recipient my_gpg_email@gmail.com aaa.txt` to encrypt a file, the output file is `aaa.txt.gpg`
    - `$ gpg --output xyz.txt --decrypt aaa.txt.gpg` to decrypt the encrypted file to `xyz.txt`. Output file required, otherwise print the content on screen.
- encrypt files for other gpg users
    - acquire gpg email and public key from the recipient
        - the others generate the public key as above and send over
    - import the public key to GPG keyring
        - `$ gpg --import other_public_key.gpg`
    - encrypt file for this user
        - `$ gpg --encrypt --recipient other_user_email@gmail.com xyz.txt`
    - send `xyz.txt.gpg` to the other user, who can then decrypt the file in his computer where the secret key stored.
- view all keys in keyrings
    - `gpg --list-keys`

 

## terminal use cases

### split iris.csv for train, validation, and test

Step 1: create files with headers only

- `$ head -1 iris.csv > train.csv`
- `$ cp train.csv validation.csv`
- `$ cp train.csv test.csv`

Step 2: shuf the body to randomize the lines

- `$ tail -n 150 iris | shuf > tmp`

Step 3: populate header files

- `$ head -n 90 tmp >> train.csv`
- `$ head -n 120 tmp | tail -n 30 >> validation.csv`
- `$ tail -n 30 tmp > test.csv`



