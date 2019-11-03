FROM ubuntu:16.04 AS opencv
LABEL maintainer="david"

#RUN sed -i 's/archive.ubuntu.com/mirrors.163.com/g' /etc/apt/sources.list

RUN apt-get update && apt-get install -y --no-install-recommends \
            git build-essential cmake pkg-config unzip libgtk2.0-dev \
            curl ca-certificates libcurl4-openssl-dev libssl-dev \
            libavcodec-dev libavformat-dev libswscale-dev libtbb2 libtbb-dev \
            libjpeg-dev libpng-dev libtiff-dev libdc1394-22-dev && \
            rm -rf /var/lib/apt/lists/*

ARG OPENCV_VERSION="4.0.1"
ENV OPENCV_VERSION $OPENCV_VERSION

RUN set -x \
	&& curl -Lo opencv.zip http://down.dxscx.com/opencv-${OPENCV_VERSION}.zip \
	&& curl -Lo opencv_contrib.zip http://down.dxscx.com/opencv_contrib-${OPENCV_VERSION}.zip?t=1

RUN unzip -q opencv.zip && \
   unzip -q opencv_contrib.zip && \
   rm opencv.zip opencv_contrib.zip && \
   cd opencv-${OPENCV_VERSION} && \
   mkdir build && cd build && \
   cmake -D CMAKE_BUILD_TYPE=RELEASE \
         -D CMAKE_INSTALL_PREFIX=/usr/local \
         -D OPENCV_EXTRA_MODULES_PATH=../../opencv_contrib-${OPENCV_VERSION}/modules \
         -D WITH_JASPER=OFF \
         -D BUILD_DOCS=OFF \
         -D BUILD_EXAMPLES=OFF \
         -D BUILD_TESTS=OFF \
         -D BUILD_PERF_TESTS=OFF \
         -D BUILD_opencv_java=NO \
         -D BUILD_opencv_python=NO \
         -D BUILD_opencv_python2=NO \
         -D BUILD_opencv_python3=NO \
         -D OPENCV_GENERATE_PKGCONFIG=ON .. && \
   make -j $(nproc --all) && \
   make preinstall && make install && ldconfig && \
   cd / && rm -rf opencv*
