#!/bin/bash

sudo apt-get -y update && sudo apt-get install -y \
    libgstreamer1.0-0  \
	gstreamer1.0-plugins-base \
	gstreamer1.0-plugins-good \
	gstreamer1.0-plugins-bad \
	gstreamer1.0-plugins-ugly \
	gstreamer1.0-libav \
	gstreamer1.0-doc \
	gstreamer1.0-tools \
	gstreamer1.0-x \
	gstreamer1.0-alsa \
	gstreamer1.0-gl \
	gstreamer1.0-gtk3 \
	gstreamer1.0-qt5 \
	gstreamer1.0-pulseaudio \
	v4l-utils \
	ffmpeg \
	usbutils \
	pkg-config cmake m4 git \
	libgstreamer1.0-dev \
    libgstreamer-plugins-base1.0-dev \
    libgstreamer-plugins-bad1.0-dev \
	vim gdb git \
    awscli wget
# and finalize...
sudo apt-get clean && sudo apt-get autoremove #&& rm -rf /var/lib/apt/lists/*


git clone -b v1.7.3 --recursive \
 		https://github.com/awslabs/amazon-kinesis-video-streams-webrtc-sdk-c.git 
	cd amazon-kinesis-video-streams-webrtc-sdk-c
	  git submodule update --init 

	mkdir -p open-source && pushd $_ 
	git clone  https://github.com/awslabs/amazon-kinesis-video-streams-pic.git
	  git submodule update --init 
	   mkdir -p amazon-kinesis-video-streams-pic/build &&  pushd $_ && cmake -DBUILD_STATIC=TRUE -DCMAKE_C_FLAGS='-w -pthread' .. && make 
	popd 
	#  
	git clone --recursive https://github.com/awslabs/amazon-kinesis-video-streams-producer-c.git 
	  git submodule update --init 
		mkdir -p amazon-kinesis-video-streams-producer-c/build && pushd $_ && cmake -DBUILD_STATIC=TRUE -DCMAKE_C_FLAGS='-w -pthread' .. && make
	popd; popd
	git apply --whitespace=nowarn ../patches/kvsWebRTCClientMasterGstreamerSample.c.patch 
	mkdir -p build && pushd $_ && cmake -DBUILD_STATIC_LIBS=TRUE -DCMAKE_C_FLAGS='-w -pthread' .. && make 
	# cp samples/kvsWebrtcClientMasterGstSample /usr/local/bin/kvsWebrtClientMasterGst && \
	popd
cp build/samples/kvsWebrtcClientMasterGstSample ./

mkdir -p certs
wget https://www.amazontrust.com/repository/AmazonRootCA1.pem \
		-O certs/AmazonRootCA1.pem