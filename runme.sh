#!/bin/sh

docker run --rm -it \
	-v $(pwd):/mnt/cwd \
	-v ~/.ssh:/mnt/user/.ssh \
	--cap-add SYS_ADMIN \
	--device /dev/fuse \
	$@ \
	siso/ansible:0.2

exit $?
