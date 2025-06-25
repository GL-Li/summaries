## Setup

### Set permission for current user if not yet

Not required for Powershell 7.4.10

Start Powershell as admin and run

```
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
```
Then check for the setting with 
```
Get-ExecutionPolicy -List
```
CurrentUser is RemoteSigned, which allows local scripts to run.


### Edit PowerShell $PROFILE

**Create $PROFILE if not exists**:

Check if $PROFILE exist
```
> Test-Path $PROFILE
```
If not exists (False), then create one
```
New-Item -Path $PROFILE -Type File -Force
```
Interestingly, the file is created inside OneDrive\Documents\WindowsPowerShell.

**Edit it**:

```
notepad $PROFILE
```

### Generate ssh key in PowerShell

Generate a ssh key in powershell
```
> ssh-keygen.exe -t ed25519 -C "windows powershell"
```
which is in user home `.ssh` by default.

The public key can be copied to Bitbucket the same way as that generated in Linux.


### Use git in PowerShell

To avoid line ending confliction with Linux, which has lf line ending, add a `.gitattributes` file to the project to force the Linux line ending

```
# Set the default behavior: auto-detect and normalize text files to LF in the repo.
# Convert to native line endings on checkout (CRLF on Windows, LF on Linux).
* text=auto

# Optionally, for clarity, explicitly declare common text file types
# to always be LF in the repository.
*.txt text eol=lf
*.md text eol=lf
*.Rmd text eol=lf
*.qmd text eol=lf
*.json text eol=lf
*.js text eol=lf
*.css text eol=lf
*.html text eol=lf
*.py text eol=lf
*.R text eol=lf
*.r text eol=lf
# ... add other source code extensions

# Declare files that are binary and should not be modified
*.xlsx binary
*.png binary
*.jpg binary
*.jpeg binary
*.gif binary
*.pdf binary
*.zip binary
*.exe binary
```



### Use vim from PowerShell terminal

**To use the vim installed on WSL linux**
simply run from PS, `> wsl vim xxx.txt`

**Install vim for PS**

- Open PS as administrator and install PS package manager chocolatey if not already.
- Install vim with `> choco install vim`



## Learning resources
- https://learn.microsoft.com/en-us/training/modules/introduction-to-powershell/2-what-is-powershell

## Terms

- cmdlets: commands in PowerShell

Naming convention: Verb-Noun, such as 
- Get-Verb: get verbs in PowerShell
- Get-Command: get all commands
- Get-Help: alias is help


## Commands

### Get-Command

```ps
> Get-Command -Noun ali*
# search command by noun that start with ali

> Get-Command -Verb sel*
# search command by verb that start with sel

> Get-Command -Verb se* -Noun ci*
# search command by verb and noun

> Get-Command -Noun File*
# file related commands

> Get-Command -Noun *Policy*
# policy related commands
```


## Learning resources 2, better one
- https://learn.microsoft.com/en-us/training/paths/get-started-windows-powershell/
