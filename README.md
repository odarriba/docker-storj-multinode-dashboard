# Storj Multinode Dashboard Docker image
*This is an unofficial docker image that make uses of official releases from Storj*

[![](https://img.shields.io/docker/v/odarriba/storj-multinode-dashboard?style=flat-square)](https://hub.docker.com/r/odarriba/storj-multinode-dashboard)

This repository contains an unofficial Docker image for running Multinode
Dashboard in a Docker environment, within an orchestration software like K8s or
using Docker Compose.

You can find builds of this container named as
[odarriba/storj-multinode-dashboard](https://hub.docker.com/r/odarriba/storj-multinode-dashboard)
on Docker Hub.

The container tag of those builds is the Storj version number used in the build.

## Getting started

First of all, generate the identity:

```
$ docker run --rm --entrypoint="create_identity" \
    -v /PATH/TO/IDENTITY:/root/.local/share/storj/identity \
    odarriba/storj-multinode-dashboard
```

Then, you need to generate the initial configuration:

```
$ docker run --rm \
    -v /PATH/TO/IDENTITY:/root/.local/share/storj/identity \
    -v /PATH/TO/CONFIG:/root/.local/share/storj/multinode \
    odarriba/storj-multinode-dashboard setup --console.address 0.0.0.0:15002
```

***Note:** we are changing the listening address because it will be working inside a
Docker container. It is explained in the security considerations below.*

and start the service:

```
$ docker run --rm \
    -v /PATH/TO/IDENTITY:/root/.local/share/storj/identity \
    -v /PATH/TO/CONFIG:/root/.local/share/storj/multinode \
    -p 15002:15002 \
    odarriba/storj-multinode-dashboard
```

After those steps you have your identity and configuration generated, and you
can access the dashboard on your local port 15002.

## Generate node API keys

To add your nodes, you can generate an API key on each one using the command:

```
$ docker exec -it storagenode \
    /app/storagenode issue-apikey --log.output stdout \
    --config-dir config --identity-dir identity
```

## Security considerations

One of the steps described on this README consists in creating the configuration
file passing a different parameter: `--console.address 0.0.0.0:15002`.
That configuration changes how the Multinode Dashboard listens for requests, and
allows anyone to call your dashboard.

This is required because the executable is running inside a Docker container and
due to the Docker networking stack the requests you make to `localhost:15002`
are no longer localhost requests.

**So it is strongly recommended that you avoid exposing this port to public Internet**
to avoid having third parties looking at your dashboards and exploiting future
attacks that may (or not) arise in Storj software.
