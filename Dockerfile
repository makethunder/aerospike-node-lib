#-------------------------------
#-- Build Aerospike C Client ---
#-------------------------------
FROM node:10-alpine
WORKDIR /src

ENV AS_C_VERSION 4.6.3

RUN apk update
RUN apk add --no-cache \
    bash \
    build-base \
    linux-headers \
    libuv-dev \
    lua5.1-dev \
    openssl-dev \
    python \
    zlib-dev

RUN wget https://artifacts.aerospike.com/aerospike-client-c/${AS_C_VERSION}/aerospike-client-c-src-${AS_C_VERSION}.zip \
    && unzip aerospike-client-c-src-${AS_C_VERSION}.zip \
    && mv aerospike-client-c-src-${AS_C_VERSION} aerospike-client-c \
    && cd aerospike-client-c \
    && make EVENT_LIB=libuv

ENV PREFIX=/src/aerospike-client-c/target/Linux-x86_64
WORKDIR /src

RUN npm install aerospike
