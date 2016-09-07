FROM alpine:3.4

MAINTAINER Simone Soldateschi <simone.soldateschi@gmail.com>

RUN apk update
RUN apk upgrade
RUN apk add ansible fuse openssh-client

RUN apk add gcc g++ make libffi-dev openssl-dev fuse-dev

RUN wget http://bindfs.org/downloads/bindfs-1.13.1.tar.gz -O /tmp/bindfs.tar.gz
RUN tar xvfz /tmp/bindfs.tar.gz -C /tmp

RUN cd /tmp/bindfs-1.13.1 \
  && ./configure \
  && make \
  && make install

# remove packages used to build bindfs
RUN apk del gcc g++ make libffi-dev openssl-dev fuse-dev

# create dir for user's stuff
RUN mkdir /mnt/user && mkdir /root/.ssh
  #&& bindfs -u 0 -g 0 /mnt/user/.ssh /root/.ssh

ADD startup.sh /root/startup.sh
RUN chmod +x /root/startup.sh

# install Python components
RUN apk add py-pip
RUN pip install docker-py

CMD ["/bin/sh", "-c", "'/root/startup.sh';'/bin/sh'"]
