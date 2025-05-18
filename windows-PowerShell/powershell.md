## Setup

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

**Set permission for current user if not yet**

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
