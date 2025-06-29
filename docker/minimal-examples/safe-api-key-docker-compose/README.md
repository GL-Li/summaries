# How to use docker images and containers safely
Summary: 

- Never hard-code or build sensitive files into docker images
- For development 
    - It is ok to use sensitive data as environment variables or files.
- For production:
    - Do not send sensitive data as environment variabls or files into docker containers when starting the container
    - The most secure way is using docker compose secrets


## when using docker run for a single container

### Send API key as an environment variable

```sh
docker run \
  --rm \
  -it \
  -e OPENAI_API_KEY="your-api-key" \
  docker-secure-api-keys-app:latest
```

### Mount the environment file
Volume mount the key when start a container

```sh
docker run \
  -it \
  --rm \
  -v "$(pwd)"/api-keys/.env:/app/api-keys/.env \
  docker-secure-api-keys-app:latest
```

## Most secure way: use docker secrets

See `docker-compose.yaml` for more details.


## When using docker compose

When using docker compose to start a container, the environment variables in a file are encoded into the docker container that is not readable to the users.

### Create secrects with docker-compose.ymal file
This file speifies files as secrects. In the example below, file `./api-keys/.env` is mapped to a temporary directory `run/secrets/api_keys_env` in the container when the docker container is started by docker compose.


```yaml
services:
  app:
    # ... other code 
    secrets:
      - api_keys_env

secrets:
  api_keys_env:
    file: ./api-keys/.env
```

The secrets are still readable if one can get into the container shell with `docker exec -it xxx_container bash`. So make the container safe, restrict the access to `docker exec .... bash` to the container by:

- Secure host computer
- Make sure no ssh installed in the container, or 
- Do not install bash to the container at all.

### Use the secrets 

See the use case in file `llm.py`. In brief, a `/run/secrects/xxx` is treated as the same way as the original file.