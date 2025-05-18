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
