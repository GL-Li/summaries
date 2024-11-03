## Tutorial
https://code.visualstudio.com/docs


## Tricks

### 10 most useful VScode key-bindings

1. code folding based on indentation
- `ctrl shift [` to fold
- `ctrl shift ]` to unfold

2. multi-cursor
- Anywhere: In the example below, in insert mode, hold down `Alt` key and click behind `a`, `b`, and `c` and insertion will show up in all three places

  item a is
  project b is
  what does c do
  
- on same words: In the example below, place cursor on word `abc` and press `ctl shift L`. Insertion replaces all after cursor position

  my abc aaa
  this is abc bbb
  a new abc is coming

2. move a line or selected lines up and down
- `alt <uparrow>`
- `alt <downarrow>`

### Settings

#### How to modify settings?

`Ctrl Shift p` and search and open `User Settings`.

#### How to save when a file is out of focus?
Settings --> search for `auto save` --> under `File:Autosave`, select `onfocusChange`.


#### How to search extensions?

- Search by name
- view installed extensions: `@installed`
- search by category: `@category:xxx`
    
    
#### keyboard shortcut
In Keyboard Shortcuts, search for `positron` for related shortcuts.



## vscodevim plugin setting

enable easymotion

## vscode user setting
`ctrl shift p` to open the search window and search for `User Setting (JSON)` and open the file. Update the file for customer setting.

```json
// good as of 2024-11-03
{
  "workbench.colorTheme": "Cobalt2",
  "files.autoSave": "onFocusChange",
  "editor.lineNumbers": "relative",
  "editor.formatOnPaste": true,
  "editor.formatOnType": true,
  "vim.highlightedyank.enable": true,
  "vim.easymotion": true,
  "vim.easymotionMarkerForegroundColorOneChar": "#eb9534",
  "vim.leader": "<space>",
  "vim.foldfix": true
}
```
