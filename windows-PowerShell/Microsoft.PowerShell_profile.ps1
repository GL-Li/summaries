# this is Powershell $PROFILE


# simulate Linux touch command
function touch {
    param(
        [Parameter(Mandatory=$true)]
        [string]$Path
    )
    if (Test-Path $Path) {
        (Get-Item $Path).LastWriteTime = Get-Date
    } else {
        New-Item -Path $Path -ItemType File
    }
}


# display git branch at PS terminal
function Get-GitBranch {
    try {
        $branch = git rev-parse --abbrev-ref HEAD 2>$null
        if ($branch) {
            return " ($branch)"
        }
    } catch {}
    return ""
}

function prompt {
    $path = "$($executionContext.SessionState.Path.CurrentLocation)"
    $branch = Get-GitBranch
    "PS $path$branch> "
}

# Import the Chocolatey Profile that contains the necessary code to enable
# tab-completions to function for `choco`.
# Be aware that if you are missing these lines from your profile, tab completion
# for `choco` will not function.
# See https://ch0.co/tab-completion for details.
$ChocolateyProfile = "$env:ChocolateyInstall\helpers\chocolateyProfile.psm1"
if (Test-Path($ChocolateyProfile)) {
  Import-Module "$ChocolateyProfile"
}
