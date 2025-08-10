# vimwiki

- cheatsheet: http://thedarnedestthing.com/vimwiki%20cheatsheet

## How to use Markdown syntex
- Add the following to .vimrc. Rename all `xxx.wiki` to `xxx.md` and change syntax to markdown syntax in all `xxx.md` files.

    ```
    let g:vimwiki_list = [{'path': '~/vimwiki/',
                          \ 'syntax': 'markdown', 'ext': '.md'}]
    let g:vimwiki_global_ext = 0
    ```

- All files saved in `~/vimwiki/` and can be edited directly.

- mapping
    - `\wl`: open link in vertical split
    - `\ww`: start vimwiki
    - `\wd`: delete an wiki file
    - `\wr`: rename an wiki file


## vim-table-mode
https://github.com/dhruvasagar/vim-table-mode

### toggle vim table mode
In normal mode, `<leader>tm` to enable/disable table mode

### create a new table
- enable table mode
- create table header like `|a|ab|ccc|dd|` and table mode automatically format it.

| aaa      | bbb   | ccc | d            |   |
|----------|-------|-----|--------------|---|
| 122fdafa | line1 |     |              |   |
|          | line2 |     |              |   |
| row 1    | line1 | ccc | aaaaaaaaaaaa | A |
|          |       |     | bbbbbbbbbbbb |   |


## gp.nvim for chatgpt
https://github.com/Robitx/gp.nvim

Preparation: 
- chatgpt API key:
  - Project API key is recommended over user API key
  - from openAI developer platform: https://platform.openai.com/docs/overview
- Add credit to the account and set monthly limit to limit the spending

Installation and minimal configuration of the plugin: ready to use with the default configuration after providing the api key.
  ```lua
  -- chatgpt.lua
  return {
    "robitx/gp.nvim",
    config = function()
      local conf = {
        openai_api_key = "your-api-key",
      }
      require("gp").setup(conf)
    end,
  }
  ```




