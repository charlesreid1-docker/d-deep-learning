# Docker Pod: Deep Learning

Files for building the Docker Deep Learning pod.

For more information on what this is all about, see 
[charlesreid1.com/wiki/Docker/Pods/Deep_Learning](https://charlesreid1.com/wiki/Docker/Pods/Deep_Learning).

## The Steps

Dockerfile needs to be cleaned up a bit 
and tested out on production system.

Volume strategy will need to be determined. Need access to:
* Training data
* Pre-prepared notebooks/scripts
* Input files
* Place to write exported, finalized models 

Things that need to be fixed first:
* Software modifications to `lfw_fuel` to preserve existing downloads
* How to actually export (and import) neural network models in reproducible way (HDF5?)

