#!/bin/sh
# usage: ./start_dirtdocker-cuda10.0-cudnn7.6.0.64-tf1.15.0-ubuntu16.04.sh <GPU number>
docker run -u $(id -u):$(id -g) --rm --runtime=nvidia -it -v /data:/data -e CUDA_VISIBLE_DEVICES=$1 -e USER=$USER -e HOME=/data/$USER -w $PWD dirtdocker/latest:cuda10.0-cudnn7.6.0.64-tf1.15.0-ubuntu16.04 bash

