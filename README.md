aerospike-node-lib
==================

Helps us maintain an image with a built Aerospike Node.js module so that we 
don't need to build the C client, which is required to then build the Node.js 
client.

The client is located in `/src/node_modules/aerospike`, so make sure you COPY 
it to the location you want it. For example, if you were doing a multi-stage 
build, you might do something like:
`COPY --from=aerospike-builder /src/node_modules/aerospike node_modules/aerospike`
