FROM ubuntu:20.04

COPY --from="memmos.laas.fr:5000/gepetto/buildfarm/tools:20.04" /sccache /usr/bin
ENV SCCACHE_REDIS="redis://asahi" CTEST_OUTPUT_ON_FAILURE=1 CTEST_PARALLEL_LEVEL=12

WORKDIR /src

RUN --mount=type=cache,sharing=locked,target=/var/cache/apt --mount=type=cache,sharing=locked,target=/var/lib/apt \
    apt-get update -qqy && DEBIAN_FRONTEND=noninteractive apt-get install -qqy \
    build-essential \
    cmake \
    doxygen \
    git \
    graphviz \
    libassimp-dev \
    libboost-all-dev \
    libeigen3-dev \
    liboctomap-dev \
    liburdfdom-dev \
    libyaml-cpp-dev \
    python-is-python3 \
    python3-pip

RUN --mount=type=cache,sharing=locked,target=/pip \
    python -m pip install --cache-dir /pip -U pip \
 && python -m pip install --cache-dir /pip -U scipy

ADD CMakeLists.txt .
RUN cmake \
        -DCMAKE_C_COMPILER_LAUNCHER="sccache" \
        -DCMAKE_CXX_COMPILER_LAUNCHER="sccache" \
        -DCMAKE_BUILD_TYPE="Release" \
        .
