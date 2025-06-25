## How to command in docker container from host terminal

A straightforwrad method is using `here document` to run multiple lines of commands in docker container from host's terminal. Save the following as aaa.sh and have a try with `$ bash aaa.sh` .

```sh
#!/bin/bash

# This script starts an Ubuntu container, creates a new user,
# switches to that user, and executes a command.

echo "Starting Ubuntu container and running commands..."

# The --rm flag cleans up the container after it exits.
# The -i flag allows us to pipe commands to the container.
# The -v flag mounts the current host directory into the container.
# We use a 'here document' (<<'EOF') to send a script to the container's bash shell.
docker run --rm -i -v "$(pwd)":/hostdir ubuntu:latest /bin/bash <<'EOF'
# We are now executing commands inside the container as the root user.

# Create a new user named 'newuser'
echo "Creating user 'newuser'..."
useradd -m -s /bin/bash newuser

# Give the new user ownership of the mounted directory so they can write to it.
chown newuser:newuser /hostdir

# Switch to 'newuser' and run a command, saving the output to the host.
echo "Switching to 'newuser' and running 'ls -ltr > /hostdir/text.txt'..."
su - newuser
ls -ltr /home/newuser > /hostdir/text.txt

echo "Commands finished."
EOF

echo "Container has exited."
```
