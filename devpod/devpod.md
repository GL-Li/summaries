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
# from the local directory run 
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
