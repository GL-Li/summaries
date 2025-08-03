## Source
https://www.youtube.com/watch?v=SXwC9fSwct8

## Without docker-compose
Will have to start and stop containers one by one.

```sh
# create a docker network. 
docker network create mongo-network

# list docker networks, bridge, host, and none are the default networks come with docker
docker network ls

# add mongodb to the network, use docker ps to check the container
docker run -d \
    -p 27017:27017 \
    -e MONGO_INITDB_ROOT_USERNAME=admin \
    -e MONGO_INITDB_ROOT_PASSWORD=supersecret \
    --network mongo-network \
    --name mongodb \
    mongo

# add mongo-express to the network
docker run -d \
    -p 8081:8081 \
    -e ME_CONFIG_MONGODB_ADMINUSERNAME=admin \
    -e ME_CONFIG_MONGODB_ADMINPASSWORD=supersecret \
    -e ME_CONFIG_MONGODB_SERVE \
    --network mongo-network \
    --name mongo-express \
    mongo-express
```

## With docker-compose
- Start (up) or stop (down) containers together using `docker-compose.yaml` file.
- Create a shared network for all services (containers) without running `docker network create`.
- `$ docker compose up` to start the services. It creates:
    - a docker network called xxx_default if the yaml file is in directory xxx
    - a container called xxx-mongodb-1, and then
    - a container called xxx-mongo-express-1, which depends on above container
- `$ docker compose down` to stop and remove above network and containers
    - all status in the container are lost
- `$ docker compose stop` to stop the containers
    - they are still exist
    - to restart, run `$docker compose start`

```yaml
services:
    mongodb:
        image: mongo
        ports:
            - 27017:27017
        environment:
            MONGO_INITDB_ROOT_USERNAME: admin
            MONGO_INITDB_ROOT_PASSWORD: supersecret
    mongo-express:
        image: mongo-express
        ports:
            - 8081:8081
        environment:
            ME_CONFIG_MONGODB_ADMINUSERNAME: admin
            ME_CONFIG_MONGODB_ADMINPASSWORD: supersecret
            ME_CONFIG_MONGODB_SERVER: mongodb
        depends_on:
            - "mongodb"
```
