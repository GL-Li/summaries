# On Top

## User setting
- Copy settings in file `positron_user_setting.json` to Positron User Settings (JSON).
- Create Shortcuts in Positron based on comments at the top of above file.
- Key extensions:
    - VSCode Vim Emulator
    - Cobalt2 Official color theme
    - Cline for AI coding
    - pyrefly: python language server for 
        - import a class or function by click
        - in settings, set `Inlay hints` to `offUnlessPressed` to show type hint only by press `Ctrl + Alt`.

## indows work with projects in WSL

### Open Remote - WSL for Positron
To work with WSL
- install Positron for Windows and 
- install extension Open `Remote - WSL for positron`, for now. The function may be built in to Positron in later version.
- `Ctrl Shift P` to start the command plattee and search for `Remote WSL - connect to WSL`, run it to connect.

## remote ssh to computers and docker containers
https://positron.posit.co/remote-ssh.html

General method:
- ctrl P --> Remote SSH --> Connect to host --> use@xxx.xxx.x.xx  -> password

Use SSH Targets is easier. See below.

### show ssh targets 

Update `.ssh/config` (Windows `C:/User/gli/.ssh/config`) with the following. The SSH Targets will be listed on the left panel, where we can easiliy make ssh connections.

```txt
Host xps8940
  HostName 192.168.1.20
  User gl

Host docker-R-program
    HostName localhost
    User rstudio
    Port 2222
```

### copy .ssh from WSL to Windows
In case of ssh-connect to a Docker container, copy WSL .ssh over to Windows C:\Users\gli\.ssh as the docker container is initialized in WSL and WSL .ssh is mounted into the container. When ssh connect into the container from Positron, Windows .ssh is used for varificantion. So the two .ssh must be the same.

See project ssh-docker for how local .ssh setting is mounted to docker containers.

# ----------------------------

# Display Outlines

## settings --> outline
Enable the following outlines
- Constant: for qmd file
- string: for md file

Disable the following outlines
- variables: too many
- number
- array
- boolean
- null
- number

# Formatting and display for R

## R outlines like in RStudio

Enable `setting --> outline:show` string to RStudio style outlines in `xxx.R` file:

```r
# topic 1 ====================
## topic 2 --------
fff <- function() {
    "hellow world"
}
```


## Format R with air

### Reference
- https://posit-dev.github.io/air/configuration.html#example-configuration
- https://posit-dev.github.io/air/editor-vscode.html

### Steps for project level formatting

- Create a `.air.toml` file under project root to specify R code formatting.
```toml
[format]
line-width = 120
indent-width = 4
indent-style = "space"
line-ending = "lf"
persistent-line-breaks = true
exclude = []
default-exclude = true
skip = []
```

- Add the following to Positron's user `settings.json` file. A .R file will reformat at saving.
```json
{
    "[r]": {
        "editor.formatOnSave": true,
        "editor.defaultFormatter": "Posit.air-vscode"
    }
}
```

### Example
```R
library(data.table)

# auto indentation with 4 spaces when typing
dt <- data.table(
    x = 1:3,
    y = letters[1:3]
)
dat <- mtcars |>
    as.data.table()


## The following line is long than 120 set in .air.toml file. It automatically
# split into mutiple lines when saving the file.
# this_is_a_very_long_function_name <- function(parameter_1, parameter_2, parameter_3, parameter_4, parameter_5, parameter_6) {
#     print("what happens to long lines?")
# }
this_is_a_very_long_function_name <- function(
    parameter_1,
    parameter_2,
    parameter_3,
    parameter_4,
    parameter_5,
    parameter_6
) {
    print("what happens to long lines?")
}

# this line is 107 chars long. It keep the line
normal_function <- function(parameter_1, parameter_2, parameter_3, parameter_4, parameter_5, parameter_6) {
    print("what happens to long lines?")
}
```

# -------------------- 
# ZZZ

### VSCode-neovim extension
Give the full path to neovim installed on WSL. In user settings.json file, add

```json
    "vscode-neovim.wslDistribution": "debian",
    "vscode-neovim.useWSL": true,
    "vscode-neovim.neovimExecutablePaths.linux": "/home/gl/bin/nvim"
```

### Assign Ctrl keys to Neovim
- Setting --> search for neovim --> find Ctrl key for insert mode and normal mode
- Add a letter to the list, for example "s". When press Ctrl-s, position executes the keybinding from neovim, instead of Positron.
  - A good use case is <C-s> mapping to saving and back to normal mode in Neovim.
  
### Multi cursor
In visual line mode or visual block mode:
- `mi`: insert to the beginning of each line of selection
- `ma`: insert to the end of selection
- `mI` and `mA`: similar but include empty lines in selection.
