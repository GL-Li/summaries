## Overall strategy of combining VScode and Vim

- use vscode-neovim plugin for a complete neovim instance, and use vim soly as a text editor:
  - mark
  - registry
  - macro
- everyting else is on native VScode


## Tutorial
https://code.visualstudio.com/docs


## VSCode-neovim extension

### keybinding conflicts
In case of VSCode and neovim have the same keybinding, VSCode keybinding has the higher priority by default. To use Neovim's keybinding, we need to delete VScode's one:
- Open VSCode Keyboard shortcuts
- search for the keybinding
- (cannot delete default vscode keybinding) delete VSCode's keybinding: right click on it and remove the keybiding.
  - the removed keybindings are actually moved to `keybindings.json` file and become user-defined keybindings, which have even higher priority.
  - commenting them out in `keybindings.json` restores the default keybinding, which means default vscode keybinding cannot be removed.
  - you can add another keybinding to the same vscode action, but you cannot remove the default one.
- So the solution is: do not compete with VScode for keybindings. Just use the editor capacity of Vim/Neovim.
  - marks
  - registry
  - macros

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
