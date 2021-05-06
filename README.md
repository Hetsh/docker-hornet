# Hornet
Small and easy to set up IOTA Node using Hornet.

## Running the node
```bash
docker run --detach --name hornet --publish 8081:8081/tcp --publish 14265:14265/tcp --publish 14626:14626/udp --publish 15600:15600/tcp hetsh/hornet
```

## Stopping the container
```bash
docker stop hornet
```

## Creating persistent storage
```bash
STORAGE="/path/to/storage"
mkdir -p "$STORAGE"
chown -R 1372:1372 "$STORAGE"
```
`1372` is the numerical id of the user running the server (see Dockerfile).
The user must have RW access to the storage directory.
Start the server with the additional mount flag:
```bash
docker run --mount type=bind,source=/path/to/storage,target=/hornet ...
```

## Automate startup and shutdown via systemd
The systemd unit can be found in my GitHub [repository](https://github.com/Hetsh/docker-hornet).
```bash
systemctl enable hornet --now
```
By default, the systemd service assumes `/apps/hornet` for data and `/etc/localtime` for timezone.
Since this is a personal systemd unit file, you might need to adjust some parameters to suit your setup.

## Fork Me!
This is an open project (visit [GitHub](https://github.com/Hetsh/docker-hornet)).
Please feel free to ask questions, file an issue or contribute to it.