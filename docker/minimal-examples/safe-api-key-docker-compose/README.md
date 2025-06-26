# Use API keys safely in docker container
Never build keys into docker images.

## when using docker run for a single container

The first step is change the key to owner read only

```sh
chmod 400 api-keys/.env
```

Then volume mount the key when start a container

```sh
docker run -it --rm -v "$(pwd)"/api-keys/.env:/app/api-keys/.env:ro safe_api_key_docker
```