Random notes

## Session
Rename a session
- Cannot give a session name at start as of now
- to rename a session:
  - `Ctrl o` and then `w` to launch session manager
  - select a session and `Ctrl r` to rename the session
  - `$ zellij a new_session_name` to load the session to the state when it was quit.

Detach a session:
- `Ctrl o` and then `d`

Reattach the session
- `$ zellij` to restore the session if it is the only session running on background
- `$ zellij list-sessions` or `zellij ls` to look for session name if more sessions are running
- `$ zellij attach session_name` or `zellij a session_name` to restore the session

Kill / stop a running session
- `$ zellij k session_name` to stop selected session
- `$ zellij ka` to kill all running sessions.

Delete a session
- `# zellij d session_name` to delete a session and `$ zellij ls` does not show it again.

## The ~/.config/zellij/config.kdl file
It contains all the common keybindings.

## Pane
Use `$ set-title xyz` to name a pane from terminal.

`Alt -jkhl` to move from pane to pane.

`Ctrl p` to get into Pane mode
- `d` to create a new pane below
- `r` to create a new pane to the right
- `x` to close current pane

`Ctrl n` to resize current pane with `jkhl`


## Layout

Apply a layout at start
- `$ zellij --layout /path/to/layout_file.kdl`
