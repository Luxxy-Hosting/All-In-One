FROM debian:bookworm-slim


RUN apt update \
    && apt upgrade -y \
    && apt -y install curl software-properties-common locales git \
    && apt-get -y install liblzma-dev \
    && apt-get -y install lzma \
    && adduser container \
    && apt-get update \ 
    && apt -y install cmake \
    && apt -y install wget

RUN apt-get update && \
    apt-get -y install sudo

RUN locale-gen en_US.UTF-8
ENV LANG en_US.UTF-8
ENV LC_ALL en_US.UTF-8

# NodeJS
RUN curl -sL https://deb.nodesource.com/setup_lts.x | bash - \
    && apt -y install nodejs \
    && apt -y install ffmpeg \
    && apt -y install make \
    && apt -y install build-essential
# Python 2 & 3
RUN apt update \
   && apt -y install zlib1g-dev libncurses5-dev libgdbm-dev libnss3-dev libssl-dev libreadline-dev libffi-dev libsqlite3-dev libbz2-dev \
   && wget https://www.python.org/ftp/python/3.12.1/Python-3.12.1.tgz \
   && tar -xf Python-3.12.*.tgz \
   && cd Python-3.12.1 \
   && ./configure --enable-optimizations \
   && make -j $(nproc) \
   && make altinstall \
   && cd .. \
   && rm -rf Python-3.12.1 \
   && rm Python-3.12.*.tgz 

# # Upgrade Pip
RUN apt -y install python3-pip

# Golang
RUN curl -OL https://golang.org/dl/go1.19.5.linux-amd64.tar.gz \
   && tar -C /usr/local -xvf go1.19.5.linux-amd64.tar.gz   
ENV PATH=$PATH:/usr/local/go/bin
ENV GOROOT=/usr/local/go

# Installing NodeJS dependencies for AIO.
RUN npm install -g yarn pm2 bun pnpm


USER container
ENV  USER container
ENV  HOME /home/container

WORKDIR /home/container

COPY ./entrypoint.sh /entrypoint.sh

CMD ["/bin/bash", "/entrypoint.sh"]