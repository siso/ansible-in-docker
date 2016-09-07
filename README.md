# Ansible in Docker

Build Docker container to run Ansible in.

## Quick-start

Run *Ansible-in-Docker* container:

```sh
./runme.sh
```

Run `ansible` and `ansible-playbook` as usual.

## Build

Build Docker image:

```sh
docker build -t siso/ansible:0.1 .
```

## FAQ

### Why bindfs

SSH requires that keys belongs to the same user running it, `bindfs` leverages fuse to bind `~/.ssh` of the user running docker to `/root/.ssh` inside the container.

### Pass params to docker

Pass Docker extra params with `./runme.sh -v /path/to/stuff:/stuff`

## License

This project is released under GNU GENERAL PUBLIC LICENSE Version 3.
