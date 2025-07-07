## Source
https://www.youtube.com/watch?v=SXwC9fSwct8

## Without docker-compose

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
    -e ME_CONFIG_MONGODB_SERVER=mongodb \
    --network mongo-network \
    --name mongo-express \
    mongo-express

```
