**Reference**: From lazyvim, run `:help lua-guide` to view the instructions.

### Using Lua files on startup

Use Lua code in either `init.lua` or `init.vim` but not both. 

### Lua modules

Use `require(xxx)` to load module `xxx.lua`, which is under `~/.config/nvim/lua/`

### Vim commands

There are multiple ways to run a Vim commands in Lua:

- Single command:
  ```lua
  vim.cmd("colorscheme habamax")
  ```
- multiple commands:
  ```lua
  vim.cmd([[
     highlight Error guibg=red
     highlight link Warning Error
  ]])
  ```
- A more common format
  ```lua
  vim.cmd.colorscheme("habamax")
  vim.cmd.highlight({ "Error", "guibg=red" })
  vim.cmd.highlight({ "link", "Warning", "Error" })
  ```

### Vim options

`vim.opt` behaves like `:set`
  ```vim
  set smarttab
  set nosmarttab
  ```
are equivalent to
  ```lua
  vim.opt.smarttab = true
  vim.opt.smarttab = false
  ```

### key mapping

Use `vim.keymap.set()` function:
  ```lua
  -- Normal mode mapping for Vim command
  vim.keymap.set('n', '<Leader>ex1', '<cmd>echo "Example 1"<cr>')
  -- Normal and Command-line mode mapping for Vim command
  vim.keymap.set({'n', 'c'}, '<Leader>ex2', '<cmd>echo "Example 2"<cr>')
  -- Normal mode mapping for Lua function
  vim.keymap.set('n', '<Leader>ex3', vim.treesitter.start)
  -- Normal mode mapping for Lua function with arguments
  vim.keymap.set('n', '<Leader>ex4', function() print('Example 4') end)
  ```
To remove a key mapping
  ```lua
  vim.keymap.del('n', '<Leader>ex1')
  ```
