## rclone: mounting cloud drivers to file system
- https://rclone.org/
- `$ sudo apt install rclone`

### configuration for Google Drive 
- `$ rclone config` to start configuretion
- follow the instruction to complete. Some key points below:
    - name the remote to `gdrive` for other for late reference with `gdrive:` (with `:`) or `gdrive:sub_dir` for a sub directory.
    - leave the following empty:
        - client_id
        - client_secret
        - service_account_file
    - select full access
    - decline advanced configuration

### mount google drive and work on google drive
- Mount google drive to a mount point
    - `mkdir ~/gdrive-mount` to create a local dir to mount Google Drive
    - `rclone mount gdrive: ~/GoogleDrive` to mount the remote `gdrive:` to `gdrive-mount`
        - `~/gdrive-mount` is a mounting point for the remote to work with.
        - `Ctrl -c` to unmount if the terminal is still open
        - `fusermount -u ~/gdrive-mount` to manually unmount if the mounting runs on background 
- Work with files in `gdrive-mount`
    - directories and files are visible in the mounting point but are not downloaded before being opened.
    - Works normally with directories and files in `gdrive-mount` as if it is a normal drive.
    - Local changes are automatically synched with remote
    - `gdrive-mount` becomes empty after un-mount

### sync with a local directory
- `mkdri ~/GoogleDrive-local-copy` for saving a copy of Google Drive 
    - a different directory from the mounting point
- Sync local and remote
    - `rclone sync -P rdrive: ~/GoogleDrive-local-copy` - sync from remote to local
        - `-P` to show progress
    - `rclone sync -P ~/GoogleDrive-local-copy rdrive:` - sync from local to remote
- sync only specific directories
    - `rclone sync -P rdrive:/dir_1 ~/GoogleDrive-local-copy/dir_2`
