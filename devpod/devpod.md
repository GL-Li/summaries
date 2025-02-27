Resources: https://devpod.sh/docs/quickstart/devpod-cli

## Get started
- install DevPod CLI
- add a provider
    - `$ devpod provider add docker`
    - `$ devpod provider list` to check added providers

## Developing in a Workspace

### Create a local Workspace

**Create a sample .devcontainer.json file**
```json
{"image": "r-base"}
```

**Start the workspace**
```sh
devpod list  # to list all workspace
devpod up <workspace-name>  # start from anywhere
# from current workspace
devpod up .
# if any modification to the json file
devpod up . --recreate
# or 
devpod up . --reset
```

**Start workspace in an IDE**
```sh
devpod up . --ide positron
```

**Stop a workspace**
```sh
devpod stop .
devpod stop workspace-name
```

### connect to a running workspace

**ssh to a workspace**
```sh
ssh <workspace-name>.devpod  # add extension .devpod to name
```

**connect to an IDE**
```sh
# list supported IDEs
devpod ide list
# set default IDE
devpod ide use positron
# or use --ide to specify an ide at startup
devpod up . --ide openvscode
```


### devcontainer.json file

Typical location of `.devcontainer.json`:
- `./.devcontainer.json`
- `./.devcontainer/.devcontainer.json`

**Use a Dockfile** if we want more than an image
```json
{
  "build": {
    "dockerfile": "Dockerfile"
  },
  ...

