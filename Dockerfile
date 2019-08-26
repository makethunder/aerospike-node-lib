#-------------------------------
#-- Build Aerospike C Client ---
#-------------------------------
# Note this is taken from https://github.com/aerospike/aerospike-client-nodejs/blob/master/docker/Dockerfile.alpine
FROM node:10-alpine as c-builder
WORKDIR /src

ENV AS_C_VERSION 4.6.7

RUN apk update
RUN apk add --no-cache \
    build-base \
    linux-headers \
    bash \
    libuv-dev \
    openssl-dev \
    lua5.1-dev \
    zlib-dev

RUN wget https://artifacts.aerospike.com/aerospike-client-c/${AS_C_VERSION}/aerospike-client-c-src-${AS_C_VERSION}.zip \
    && unzip aerospike-client-c-src-${AS_C_VERSION}.zip \
    && mv aerospike-client-c-src-${AS_C_VERSION} aerospike-client-c \
    && cd aerospike-client-c \
    && make EVENT_LIB=libuv

#-------------------------------
#-- Build Aerospike JS Client --
#-------------------------------
FROM node:10-alpine as node-builder
WORKDIR /src

COPY --from=c-builder /src/aerospike-client-c/target/Linux-x86_64/include/ aerospike-client-c/include/
COPY --from=c-builder /src/aerospike-client-c/target/Linux-x86_64/lib/ aerospike-client-c/lib/

ENV PREFIX=/src/aerospike-client-c/

RUN apk update
RUN apk add --no-cache \
    build-base \
    bash \
    python \
    linux-headers \
    zlib-dev \
    openssl-dev
RUN npm install aerospike
