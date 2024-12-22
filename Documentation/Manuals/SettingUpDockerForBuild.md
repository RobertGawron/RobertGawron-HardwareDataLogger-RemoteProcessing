In the directory **Host** from the main directory of the project, run the following command to build the image:

```
docker-compose build hwlogger-arm-builder
```

### Running the Docker Image

Start the Docker image:

```
docker-compose up hwlogger-arm-builder -d
```

Log into the Docker image:

```
docker-compose exec hwlogger-arm-builder bash
```

### Oneliner

Run the following command to build, start, and log into the Docker image in one step:

```
docker-compose build hwlogger-arm-builder && docker-compose up hwlogger-arm-builder -d && docker-compose exec hwlogger-arm-builder bash
```

### Troubleshooting

To view logs for the Docker container:

```
docker logs hwlogger-arm-builder
```

