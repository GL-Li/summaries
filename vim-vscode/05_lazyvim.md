## Additional options

There are two files that can add user-options:

- `lua/config/options.lua`: Options added in this file are loaded before lazyvim so they will overwritten.
- `init.lua`: user-options will overwrite those in lazyvim and plugins
  ```lua
  require("config.lazy")

  -- Softwrap text
  vim.opt.linebreak = true -- Break lines at word boundaries
  vim.opt.formatoptions = "ro" -- Formatting options
  vim.opt.comments = "b:-" -- Comment format
  vim.opt.breakindent = true -- Break indent
  vim.opt.autoindent = true -- Auto indentation
  vim.opt.breakindentopt = "shift:2" -- Options fo
  ```
```
  ```
