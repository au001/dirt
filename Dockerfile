ARG CUDA_BASE_VERSION
ARG UBUNTU_VERSION

# use CUDA + OpenGL
FROM nvidia/cudagl:${CUDA_BASE_VERSION}-devel-ubuntu${UBUNTU_VERSION}
MAINTAINER Domhnall Boyle (domhnallboyle@gmail.com)

# install apt dependencies
RUN apt-get update && apt-get install -y \
	git \
	vim \
	wget \
	software-properties-common \
	curl

# install newest cmake version
RUN apt-get purge cmake && cd ~ && wget https://github.com/Kitware/CMake/releases/download/v3.14.5/cmake-3.14.5.tar.gz && tar -xvf cmake-3.14.5.tar.gz
RUN cd ~/cmake-3.14.5 && ./bootstrap && make -j6 && make install

# install python3.7 and pip
RUN apt-add-repository -y ppa:deadsnakes/ppa && \
    apt-get update && \
    apt-get install -y python3.7 && \
    ln -s /usr/bin/python3.7 /usr/bin/python && \
    curl https://bootstrap.pypa.io/get-pip.py | python

# arguments from command line
ARG CUDA_BASE_VERSION
ARG CUDNN_VERSION

# set environment variables
ENV CUDA_BASE_VERSION=${CUDA_BASE_VERSION}
ENV CUDNN_VERSION=${CUDNN_VERSION}

# setting up cudnn
RUN apt-get install -y --no-install-recommends \             
	libcudnn7=$(echo $CUDNN_VERSION)-1+cuda$(echo $CUDA_BASE_VERSION) \             
	libcudnn7-dev=$(echo $CUDNN_VERSION)-1+cuda$(echo $CUDA_BASE_VERSION) 
RUN apt-mark hold libcudnn7 && rm -rf /var/lib/apt/lists/*

ARG TENSORFLOW_VERSION
ENV TENSORFLOW_VERSION=${TENSORFLOW_VERSION}

# install python dependencies
RUN python -m pip install tensorflow-gpu==$(echo $TENSORFLOW_VERSION)

# install dirt
# git clone --single-branch --branch <branchname> <remote-repo>
# included debug couts in raterise_ops and gl_common etc in local repo specific branch anu-debug

ENV CUDAFLAGS='-DNDEBUG=1'
RUN cd ~ && git clone --single-branch --branch anu-debug https://github.com/au001/dirt.git && \ 
 	python -m pip install dirt/
	 
# If you are using Ubuntu 18.04 or newer, with the Ubuntu-packaged Nvidia drivers (i.e. installed with apt not Nvidia's runfile),
# and libOpenGL.so and/or libEGL.so is missing, then run sudo apt install libglvnd-dev

# for ubuntu 16.04 and 18.04 but mesa throws error egl extensions missing
#RUN apt-get update && apt-get install -y libegl1-mesa-dev

# apparently not required
#RUN apt-get update && apt-get install -y libglvnd-dev

# only for ubuntu 18.04
#RUN apt-get update && apt-get install -y libegl1
#RUN apt-get update && apt-get install -y libegl1-nvidia

# only for ubuntu 20.04 but guess what couldn't find nvidia/cudagl docker images for any ubuntu version above 19.04
#RUN apt-get update && apt-get install -y libegl-dev

#RUN add-apt-repository ppa:graphics-drivers/ppa && \
#	apt-get update && apt-get install -y nvidia-390 && \
#	apt-get install -y nvidia-cuda-toolkit

# run dirt test command
#RUN python ~/dirt/tests/square_test.py
