FROM alpine:3.5

MAINTAINER Simone Soldateschi <simone.soldateschi@gmail.com>

# Upgrade Alpine packages
RUN apk update
RUN apk upgrade

# Install packages and resolve dependencies for next steps
RUN apk add fuse fuse-dev g++ gcc libffi-dev make musl-dev openssh-client openssl-dev python2-dev

RUN wget http://bindfs.org/downloads/bindfs-1.13.1.tar.gz -O /tmp/bindfs.tar.gz
RUN tar xvfz /tmp/bindfs.tar.gz -C /tmp

RUN cd /tmp/bindfs-1.13.1 \
  && ./configure \
  && make \
  && make install

# create dir for user's stuff
RUN mkdir /mnt/user && mkdir /root/.ssh
  #&& bindfs -u 0 -g 0 /mnt/user/.ssh /root/.ssh

ADD startup.sh /root/startup.sh
RUN chmod +x /root/startup.sh

# install Python components
RUN apk add py2-pip
RUN pip install ansible
RUN pip install docker-py

# Upgrade Python packages
RUN pip install --upgrade pip
RUN pip freeze --local | grep -v ^-e | cut -d = -f 1  | xargs -n1 pip install -U

# Uninstall unused packages
RUN apk del fuse-dev g++ gcc musl-dev libffi-dev libressl-dev libffi-dev make openssl-dev python2-dev

CMD ["/bin/sh", "-c", "'/root/startup.sh';'/bin/sh'"]
