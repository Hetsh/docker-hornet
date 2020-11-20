**This Project is still work in progress.**

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
MP="/path/to/storage"
mkdir -p "$MP"
chown -R 1372:1372 "$MP"
```
`1372` is the numerical id of the user running the server (see Dockerfile).

## Automate startup and shutdown via systemd
The systemd unit can be found in my GitHub [repository](https://github.com/Hetsh/docker-hornet).
```bash
systemctl enable hornet --now
```
By default, the systemd service assumes `/apps/hornet` for persistent storage and `/etc/localtime` for timezone.
Since this is a personal systemd unit file, you might need to adjust some parameters to suit your setup.

## Fork Me!
This is an open project (visit [GitHub](https://github.com/Hetsh/docker-hornet)).
Please feel free to ask questions, file an issue or contribute to it.