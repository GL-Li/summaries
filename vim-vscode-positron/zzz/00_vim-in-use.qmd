## Install NeoVim

We will install Neovim but use it as Vim. The focus is to use it as a text editor. We will use VSCode to cover functionalities Neovim offers.

All the configuration in `.vimrc` for Vim apply to NeoVim after making the following adjustment.

- Rename `.vimrc` to `init.vim` and copy to `~/.config/nvim/`.
- Instsall vim-plug to `~/.config/nvim/autoload/`:
    ```sh
    curl -fLo ~/.config/nvim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
    ```
    
The easiest way to get the latest NeoVim is to download its appimage, make it executable, rename to `nvim` and copy to `$HOME/bin` (must in PATH). The latest NeoVim 0.10.1 has retrobox colorscheme and clipboard support, the two important features I need.

In Windows WSL Ubuntu, which does not have FUSS to support appimage, extract the appimage and then make a soft link to the executable from `~/bin`: `$ ln -s ~/neovim/squarshfs-root/bin/nvim`. Hard link does not work as this `nvim` depends on files in `squarshfs-root/`.

This `init.vim` can be used by VSCode extension `VSCode Neovim` created by asvetliako. Unfortunately, `.vimrc` is not supported by VScode extension `Vim` by vscodevim. This is why we have this note.


## Most useful vim skills

### use dot `.` to repeat changes
https://learnvim.irian.to/basics/the_dot_command#:~:text=Here%20the%20dot%20command%20repeated,in%20exchange%20for%20just%20one.

What are repeatable:
- normal mode `d`, `c`, ...
  - example: how to delete `aaa, bbb, ccc,` one by one
  - solution: `df,..` to first delete `aaa,`, and then `bbb,` and then `ccc,`.
- visual line or visual block followed by `d`, `c`, ...
  - example: delete all `z` below use visual block and dot repeat
    zaaa zzaaa
    zbbb zzbbb
    zccc zzccc
  - solution: visual block select first three `z`s with `Ctrlvjjd` and then move the next z and repeat with `.` twice.
- include `next` motion in repeat
  - example: replace `aaa` with `ABC` below
    aaa is not
    as good as bbb, but aaa is
    better than ccc. So we buy aaa.
  - solution: `/aaa<CR>` to search for `aaa`, and then `cgnABC<Esc>` to change the first selected to ABC. This change include `gn` for next `aaa` match so we can simply repeat it with `.` withou using `n` to jump to the next match.

What are not repeatable
- motions that are not part of a change
  - example: how to delete `,` in `aaa, bbb, ccc,`
  - wrong solution: `f,x..`: `f,` is a motion, which is not part of deletion `x`.
  - correct solution: `f,x;.;.`, which uses `;` to repeat motion and `.` to repeat deletion.

### automation with vim macros
Record a macro
- in normal mode, press `q` followed by a single letter from a-z as registry name to start recording
- press `0` to move the start of a line (or `$` to the end) and then start operations on the line. 
- press <ESC> to return to normal mode and then `j` to next line
- press `q` to finish recording

Use a macro `a`
- review contents of a macro: `:reg` to view the content
- apply macro `a` on a single line: move cursor to the line in normal mode and run `@a`
- repeat on a new line: `@@`
- apply on 5 lines: `5@a`
- apply on selected lines: `:<>normal @a`
- apply to all lines: `:%:normal @a`.

Modify a macro: a macro is no more than a string stored in a register.
- `:put a`: paste string of macro `a` to a line
- edit it just like editing any string
- highlight the edited string and yank it back to register / macro `a` with `"ay`.

### register for temporary storage
All register starts with one double quote `"`.

Types of registers:
- `""`: the most recent yanked or deleted text
- `"0` - `"9`: past yanked or deleted text
- `"a` - `"z`: named register

View registers:
- `:reg` to list all registers

Use registers:
- `p`: to paste text in current register
- `"3p` or '"cp`: to paste text in numbered or named register
- `"cyw`: yank word into regester `c`.

    
## Understand vim

### vim key mapping

**mapping keywords**: `noremap`: non-recursive map for all mode:

- `nnoremap`: in normal mode
- `inoremap`: in insert mode
- `vnoremap`: in visual mode
- `cnoremap`: in command mode (when `:` is on)
- try to use it if possible to avoid infinite loop, for example:
    - `:map a b` and `:map b a` will cause an infinite loop. Pressing `a` activates `b`, then `a`, then `b`, ...
    - `:noremap a b` and `:noremap b a` will not. Pressing `a` activates `b` and then stop.

**special keys**

- <Esc>: Esc key
- <C>: Ctrl key
    - <C-j>: Ctrl j
    - <C-a><C-b>: Ctrl a Ctrl b
- <CR>: Enter key
- <up>: up arrow key, similar for down, left right arrow keys
    - <C><up>: Ctrl up-arrow

**map plugin's command**

- `nnoremap <leader>, <Plug>(EasyAlign)ip*,<CR>`


## Vim tricks

### autocompletion

Using a keywords list txt file
- Create a file r_dict.txt file and save at /path/to/r_dict.txt.
- Edit the file, in which each line is a keyword
- In .vimrc, add line
  - set dictionary+=/home/gl/.vim/dict/r_dict.txt
  - set dictionary+=/home/gl/.vim/dict/python_dict.txt
- Edit file in vim: in insert mode after typing a couple of characters, use Ctrl-x Ctrl-k to bring up suggestions, and use Ctrl-n or Ctrl-p to select.
- remap to make life easier.
