# Docker images in use

## R docker images

### base image
Use `rocker/r-ver` as base image instead of `r-base`. All rocker's R images is built on top of `r-ver`.

**Why it is good**

- Fast `install.packages()` as its default CRAN mirror is the Posit Public Package Manager, which serves compiled linux binaries of R packages.
- Old R version installs all R packages from a fixed snapshot of CRAN mirror at a given date, ensures reproducibility.

**resources**

- https://hub.docker.com/r/rocker/r-ver/tags
- https://rocker-project.org/images/versioned/r-ver.html

### Never update existing R packages in a docker image 
Use `pak::pkg_install("xxx")` to install additional package, which by default do not update existing packages when installing dependencies. In additional, it only installes dependencies from Depends and Imports.

### Example project
Project at `/projects/personal-projects/docker-images/docker-rbase`, which build 4 docker images

- r-ver --> rbase_minimal
- rbase_minimal --> rbase_release
- rbase_minimal --> rbase_bitbucket
- rbase_bitbucket --> rbase_rstudio_positron

The final image can be used with both RStudio and Positron.



# docker run

## How to run commands in docker container from host terminal

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


## How to safely use API keys in a docker container

**Best option**: use docker compose secrect

Step 1: create a yml file

```yaml
version: '3.8'

services:
  my_app:
    image: your_image_name
    secrets:
      - my_api_key

secrets:
  my_api_key:
    file: ./my_api_key.txt
```

Step 2: Start container in swarm mode

```sh
docker swarm init
docker compose up -d
```
