#!/bin/sh
export CUDA_BASE_VERSION=10.0
export CUDNN_VERSION=7.6.0.64
export UBUNTU_VERSION=18.04
export TENSORFLOW_VERSION=1.15.0
docker build -t dirtdocker/latest:cuda10.0-cudnn7.6.0.64-tf1.15.0-ubuntu18.04 \
    --build-arg CUDA_BASE_VERSION=$(echo $CUDA_BASE_VERSION) \
    --build-arg TENSORFLOW_VERSION=$(echo $TENSORFLOW_VERSION) \
    --build-arg CUDNN_VERSION=$(echo $CUDNN_VERSION) \
    --build-arg UBUNTU_VERSION=$(echo $UBUNTU_VERSION) . | \
    tee dirt-build-log-ca10.0-cn7.6.0.64-tf1.15.0-ub18.04-cout-no-sq-test.txt
