## Get into docker container shell

docker exec
- `$ docker exec -it container_name bash` for Ubuntu based container
- `$ docker exec -it container_name sh` for alpine-based container

switch user to rstudio
- `su - rstudio`: to go to user's home directory.


## selfSrv run with PostgreSQL

### docker-compose.yaml

The `docker-compose.yaml` file:
- Map port 5433:5432 as the host's 5432 is used by local Postgresql server.
- The postgres database, user, and password are created automatically.

```yaml
services:
  positron_rstudio:
    image: trusaicdata/rbase_rstudio_positron:latest
    platform: linux/amd64
    container_name: positron_rstudio
    restart: always
    ports:
      - "8787:8787"
      - "2222:22"
    environment:
      - DISABLE_AUTH=true
    volumes:
      - ${HOME}/projects:/home/rstudio
      - ${HOME}/.ssh/id_rsa.pub:/home/rstudio/.ssh/authorized_keys
      - ${HOME}/.ssh/id_rsa:/home/rstudio/.ssh/id_rsa
      - ${HOME}/.ssh/known_hosts:/home/rstudio/.ssh/known_hosts
      - ${HOME}/.bashrc:/home/rstudio/.bashrc
      - ${HOME}/.gitconfig:/home/rstudio/.gitconfig
    depends_on:
      - postgres

  postgres:
    image: postgres:16
    container_name: postgres_db
    restart: always
    ports:
      - "5433:5432"
    environment:
      POSTGRES_USER: selfsrv
      POSTGRES_PASSWORD: selfsrv-pw
      POSTGRES_DB: encoding_tables
    volumes:
      - postgres_data:/var/lib/postgresql/data

volumes:
  postgres_data:
```

### Access the database from R code
The R code is running from container positron_rstudio. The Renviron file is

```
PGDATABASE=encoding_tables
PGPASSWORD=selfsrv-pw
PGUSER=selfsrv
PGHOST=postgres
PGPORT=5432
```

Note that PGHOST is the container name postgres named in the yaml file above. To connect from R

```r
readRenviron("Renviron")
con <- DBI::dbConnect(
  RPostgreSQL::PostgreSQL(),
  dbname = Sys.getenv("PGDATABASE"),
  host = Sys.getenv("PGHOST"),
  port = Sys.getenv("PGPORT"),
  user = Sys.getenv("PGUSER"),
  password = Sys.getenv("PGPASSWOD")
)
```


### Access from pgAdmin
The pgadmin-desktop should be installed on WSL/Linux. To register a server, 
- the hostname is `localhost` 
- the port is `5433`, which is mapped to postgres container's `5422`.
