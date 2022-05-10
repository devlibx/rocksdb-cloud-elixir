FROM ubuntu:22.10

RUN apt-get update
RUN apt-get install -y git
RUN apt-get -y install cmake
RUN apt-get -y install librdkafka-dev
RUN cmake --version

RUN mkdir /src

WORKDIR /src
RUN git clone --recurse-submodules https://github.com/aws/aws-sdk-cpp
RUN cd /src/aws-sdk-cpp
RUN git checkout 1.9.252
RUN mkdir /src/aws-sdk-cpp/build

WORKDIR /src
RUN git clone https://github.com/mfontanini/cppkafka.git
RUN cd /src/cppkafka
RUN git checkout 0.4.0

WORKDIR /src
RUN git clone https://github.com/devlibx/rocksdb-cloud-elixir.git
RUN cd /src/rocksdb-cloud-elixir
RUN git checkout 6.11
RUN mkdir /src/rocksdb-cloud-elixir/sdk_build

WORKDIR /src
RUN git clone https://github.com/jbeder/yaml-cpp.git
RUN cd /src/yaml-cpp
RUN mkdir /src/yaml-cpp/build


WORKDIR /src/aws-sdk-cpp/build
RUN cmake .. -DBUILD_ONLY="s3;kinesis" -DBUILD_SHARED_LIBS=off -DENABLE_TESTING=off -DAUTORUN_UNIT_TESTS=off
RUN make install -j 12

WORKDIR /src/rocksdb-cloud-elixir/sdk_build
RUN UAS_AWS=1 USE_KAFKA=1  cmake ..  -DWITH_GFLAGS=off
RUN make install -j 12

WORKDIR /src/yaml-cpp/build
RUN cmake .. 
RUN make install -j 12
