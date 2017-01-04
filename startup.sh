#!/bin/sh

echo '**************************************'
echo '               Welcome'
echo
echo 'Ansible in Docker container v0.2'
echo '**************************************'

# mount host ~/.ssh into container /root
bindfs -u 0 -g 0 /mnt/user/.ssh /root/.ssh
eval ssh-agent /bin/sh
ssh-add /root/.ssh/id_rsa
