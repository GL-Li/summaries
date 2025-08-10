## Lazyvim in use

### Additional plugins

- `Cobalt2.nvim` colorscheme: customized for my own need. Install from https://github.com/GL-Li/cobalt2.nvim
- `iron.nvim`: for REPL, setting in `~/configurations/lazyvim/plugin/iron.lua` 
- `vim-makrdown`: for markdown table of content, in `~/configurations/lazyvim/plugin/vim-markdown.lua`

### Additional options

- `~/configurations/lazyvim/init.lua` for softwrap. Options added in this file are loaded before lazyvim so they will overwritten.
- `~/configurations/lazyvim/config/options.lua` for windows separator color. 

There are two files that can add user-options: user-options will overwrite those in lazyvim and plugins

```lua
-- init.lua
require("config.lazy")

-- Softwrap text
vim.opt.linebreak = true -- Break lines at word boundaries
vim.opt.formatoptions = "ro" -- Formatting options
vim.opt.comments = "b:-" -- Comment format
vim.opt.breakindent = true -- Break indent
vim.opt.autoindent = true -- Auto indentation
vim.opt.breakindentopt = "shift:2" -- Options fo
```
```lua
-- options.lua
-- Set the window separator highlight group
vim.api.nvim_set_hl(0, "WinSeparator", {
  fg = "gray", -- Set the foreground color (adjust as needed)
  --bg = "gray", -- Set the background color (adjust as needed)
})
```
