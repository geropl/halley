FROM gitpod/workspace-full-vnc:latest

USER root
RUN apt-get update && apt-get install -yq \
        build-essential \
        libsdl2-dev \
        libsdl2-2.0-0 \
        libogg-dev \
        libvorbis-dev \
        # OpenGL
        freeglut3 \
        freeglut3-dev \
        libglew1.5 \
        libglew1.5-dev \
        libglu1-mesa \
        libglu1-mesa-dev \
        libgl1-mesa-glx \
        libgl1-mesa-dev \
        # Tools
        cmake \
        wget \
        # Window manager
        jwm \
    && apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/*

USER gitpod

# Download boost 1.66.0
RUN cd /home/gitpod \
    && mkdir boost && cd boost \
    && wget https://dl.bintray.com/boostorg/release/1.66.0/source/boost_1_66_0.tar.gz \
    && tar -xf boost_1_66_0.tar.gz && rm -f boost_1_66_0.tar.gz \
    && cd boost_1_66_0 \
    && ./bootstrap.sh --with-libraries=filesystem,system --prefix=/home/gitpod/boost \
    && ./b2
ENV BOOST_ROOT=/home/gitpod/boost/boost_1_66_0/
ENV LD_LIBRARY_PATH /home/gitpod/boost/boost_1_66_0/stage/lib/:$LD_LIBRARY_PATH

# Build yaml-cpp 0.5.3 from source
RUN cd /home/gitpod \
    && mkdir yaml-cpp && cd yaml-cpp \
    && git clone https://github.com/jbeder/yaml-cpp -b yaml-cpp-0.5.3 \
    && cd yaml-cpp \
    && mkdir build && cd build \
    && cmake .. \
    && make -j 4
# ENV YAML_CPP_LIB=/home/gitpod/yaml-cpp/yaml-cpp/build/

# # Build freetype-2.6.3 from source
# RUN cd /home/gitpod \
#     && mkdir freetype && cd freetype \
#     && wget https://download.savannah.gnu.org/releases/freetype/freetype-2.6.3.tar.gz \
#     && tar -xf freetype-2.6.3.tar.gz && rm -f freetype-2.6.3.tar.gz \
#     && cd freetype-2.6.3 \
#     && mkdir build && cd build \
#     && cmake .. \
#     && make -j 4
# ENV FREETYPE_LIB=/home/gitpod/freetype/freetype-2.6.3/build/

# cmake -DBOOST_ROOT=/home/gitpod/boost/boost_1_66_0 -DCMAKE_LIBRARY_PATH=/home/gitpod/boost/boost_1_66_0/stage/lib -DBUILD_HALLEY_TOOLS=1 -DBUILD_HALLEY_TESTS=1 -DYAMLCPP_INCLUDE_DIR=/home/gitpod/yaml-cpp/yaml-cpp/include/yaml-cpp -DYAMLCPP_LIBRARY=/home/gitpod/yaml-cpp/yaml-cpp/build/libyaml-cpp.a

USER root
