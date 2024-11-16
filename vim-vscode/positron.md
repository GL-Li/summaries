## Outlines

### settings --> outline

- Disable the following outlines
  - variables: too many
  - constant
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