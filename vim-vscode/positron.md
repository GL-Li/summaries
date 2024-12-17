## Dependencies and extension
Dependencies:
- Install Quarto for qmd files: download from https://quarto.org/docs/get-started/

Extensions:
- Quarto
- VSCode Neovim
- Cobalt2 Theme Official


## With WSL

### Open Remote - WSL for Positron
To work with WSL
- install Positron for Windows and 
- install extension Open Remote - WSL for positron, for now. The function may be built in to Positron in later version.
- `Ctrl Shift P` to start the command plattee and search for `Remote WSL - connect to WSL`, run it to connect.

### VSCode-neovim extension
Give the full path to neovim installed on WSL. In user settings.json file, add

```json
    "vscode-neovim.wslDistribution": "debian",
    "vscode-neovim.useWSL": true,
    "vscode-neovim.neovimExecutablePaths.linux": "/home/gl/bin/nvim"
```

## Display Outlines

### settings --> outline
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

### R outlines like in RStudio

Enable `setting --> outline:show` string to RStudio style outlines in `xxx.R` file:

```r
# topic 1 ====================
## topic 2 --------
fff <- function() {
    "hellow world"
}
```

### VScode-neovim extension

#### Assign Ctrl keys to Neovim
- Setting --> search for neovim --> find Ctrl key for insert mode and normal mode
- Add a letter to the list, for example "s". When press Ctrl-s, position executes the keybinding from neovim, instead of Positron.
  - A good use case is <C-s> mapping to saving and back to normal mode in Neovim.
  
#### Multi cursor
In visual line mode or visual block mode:
- `mi`: insert to the beginning of each line of selection
- `ma`: insert to the end of selection
- `mI` and `mA`: similar but include empty lines in selection.
