https://learnvim.irian.to/basics/starting_vim

## Learn Vim the smart way
https://learnvim.irian.to/basics/starting_vim

### Start Vim

Open three files in vertical split
- `$ vim -O3 file1 file2 file3`

Suspend a vim session: this is the best way to switch between vim session and terminal
- `:stop` or `Ctrl-z` to suspend vim and send vim session to background.
- `$ fg` to return to the background vim session. 
- why need float terminal anyway?

Pass terminal stout to be edited in Vim
- `$ git log | vim -`: use `-` for vim

### Buffers, Windows, and Tabs

Buffers
- how to open all files under current directory, including those in subdirectories
  - start vim
  - `:args **/*` to open all into buffers
    - `args **/*.md` to open all `md` files only
  - `:ls` to list all buffers
    - `:b35` to bring buffer 35 to current window.

Tabs
- `:tabnew file1`: start a new tab
- `gt` and `gT`: switch to next / previous tab
  - also works with VScode-Neovim extension
- `3gt`: got to the 3rd tab.

### Search files

vim built-in file explorer (not working in vscode-neovim)
- `:e .` or `:e dir_1` to open the built-in file explorer `netrw`.
- use `j` and `k` to move to a directory or file and press enter to open
- move to `..` and press enter to go to parent directory.


### Vim grammar

Motions
- `w`: next word
- `$`: end of the line
- `)`: next sentence
- `(`: previous sentence
- `]]`: next section, like markdown headers
- `[[`: previous section
- `}`: next paragraph
- `{`: previous paragraph
- `H`, `M`, `L`: top, middle, and bottom of current view.

Scrolling: move view port but keep cursor in current line
- `zz`: scroll window so current line is in the middle
- `zt`: current line at the top 
- `zb`: current line at the bottom

Search
- `*` and `#`: search whole word forward and backward
- `g*` and `g#`: search even if part of a word
  - example: "one in onetwo"

Marks
- local marks `a-z`: local to the buffer
- global marks `A-Z`: across file, only one. Used to jump to another file
- jump to a mark
  - ``b``: backtick b, jump to exact position
  - `'b`: single quote b, jump to the line of the mark

Jumps
- list of jump motions
  - '       Go to the marked line
  - G       Go to the line
  - /       Search forward
  - ?       Search backward
  - n       Repeat the last search, same direction
  - N       Repeat the last search, opposite direction
  - %       Find match
  - (       Go to the last sentence
  - )       Go to the next sentence
  - {       Go to the last paragraph
  - }       Go to the next paragraph
  - L       Go to the the last line of displayed window
  - M       Go to the middle line of displayed window
  - H       Go to the top line of displayed window
  - [[      Go to the previous section
  - ]]      Go to the next section
  - :s      Substitute
  - :tag    Jump to tag definition
- for the jump motions
    - `Ctrl o`: to move up along jumps
    - `Ctrl i`: to move down along jumps

### Register

Current register
- `""`: store the latest yank or deletion.
- simple `p` or `P` to put the text.

Numbered regester
- `"0`: for yanked text. Deletion or change do not use this register. To put the last yanked text, `"0p`.
  - `Ctrl-r 0` to insert the last yanked text in insert mode.
- `1 - 9`: for deletion and change that are at least one line long. Latest at `1` and oldest at `9`. Not use often but can be used as backup of deletion.

Small deletion register
- `"-`: store deletion that is less than one line.
- `"-p` to put small deletion.

Read-only regiester, but you can still put the text in them.
- `".`    Stores the last inserted text
- `":`    Stores the last executed command-line
- `"%`    Stores the name of current file

Alternate file register
- `"#`: the last opened file.

### Visual mode

Increment numbers
- example: to change below to app-1 to app-5, highlight the last four 1s in visual block mode and then `g Ctrl-A`.
  <div id="app-1"></div>
  <div id="app-1"></div>
  <div id="app-1"></div>
  <div id="app-1"></div>
  <div id="app-1"></div>
  becomes
  <div id="app-1"></div>
  <div id="app-2"></div>
  <div id="app-3"></div>
  <div id="app-4"></div>
  <div id="app-5"></div>
