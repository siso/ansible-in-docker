FROM alpine:3.5

MAINTAINER Simone Soldateschi <simone.soldateschi@gmail.com>

# Upgrade Alpine packages
RUN apk update
RUN apk upgrade

# Install packages and resolve dependencies for next steps
RUN apk add fuse fuse-dev g++ gcc jq libffi-dev make musl-dev openssh-client openssl-dev python2-dev wget

RUN wget http://bindfs.org/downloads/bindfs-1.13.1.tar.gz -O /tmp/bindfs.tar.gz
RUN tar xvfz /tmp/bindfs.tar.gz -C /tmp

RUN cd /tmp/bindfs-1.13.1 \
  && ./configure \
  && make \
  && make install

# create dir for user's stuff
RUN mkdir /mnt/user && mkdir /root/.ssh
  #&& bindfs -u 0 -g 0 /mnt/user/.ssh /root/.ssh

ADD files/startup.sh /root/startup.sh
RUN chmod +x /root/startup.sh

# install Python components
RUN apk add py2-pip
RUN pip install ansible
RUN pip install docker-py

# Upgrade Python packages
RUN pip install --upgrade pip
RUN pip freeze --local | grep -v ^-e | cut -d = -f 1  | xargs -n1 pip install -U

# add support for Azure
RUN pip install "azure==2.0.0rc5"
RUN pip install "msrestazure==0.4.4"
RUN wget --no-check-certificate -O /root/azure_rm.py https://github.com/ansible/ansible/raw/stable-2.2/contrib/inventory/azure_rm.py
RUN chmod +x /root/azure_rm.py

# Uninstall unused packages
RUN apk del fuse-dev g++ gcc musl-dev libffi-dev libressl-dev libffi-dev make openssl-dev python2-dev

CMD ["/bin/sh", "-c", "'/root/startup.sh';'/bin/sh'"]
