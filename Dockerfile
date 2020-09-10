FROM ubuntu:bionic

MAINTAINER Colm Ryan <cryan@bbn.com>

# build with docker build --build-arg VIVADO_TAR_HOST=host:port --build-arg VIVADO_TAR_FILE=Xilinx_Vivado_SDK_2016.3_1011_1 -t vivado .

#install dependences for:
# * downloading Vivado (wget)
# * xsim (gcc build-essential to also get make)
# * MIG tool (libglib2.0-0 libsm6 libxi6 libxrender1 libxrandr2 libfreetype6 libfontconfig)
# * CI (git)

SHELL ["/bin/bash", "-c"]

RUN apt-get update && apt-get install -y \
  wget \
  build-essential \
  libglib2.0-0 \
  libsm6 \
  libxi6 \
  libxrender1 \
  libxrandr2 \
  libfreetype6 \
  libfontconfig \
  ca-certificates \
  curl \
  jq \
  git \
  iputils-ping \
  libcurl4 \
  libicu60 \
  libunwind8 \
  netcat  

# copy in config file
COPY install_config.txt /

# download and run the install
ARG VIVADO_TAR_HOST
ARG VIVADO_TAR_FILE
ARG VIVADO_VERSION



RUN echo "Downloading ${VIVADO_TAR_FILE} from ${VIVADO_TAR_HOST}" 
RUN wget ${VIVADO_TAR_HOST}/${VIVADO_TAR_FILE}.tar.gz -q
RUN echo "Extracting Vivado tar file" 
RUN tar xzf ${VIVADO_TAR_FILE}.tar.gz 
RUN /${VIVADO_TAR_FILE}/xsetup --agree 3rdPartyEULA,WebTalkTerms,XilinxEULA --batch Install --config install_config.txt 
RUN rm -rf ${VIVADO_TAR_FILE}*

#add vivado tools to path (root)
RUN echo "source /opt/Xilinx/Vivado/${VIVADO_VERSION}/settings64.sh" >> /root/.profile
RUN echo "source /opt/Xilinx/Vivado/${VIVADO_VERSION}/settings64.sh" >> /root/.bashrc

#make a Vivado user
RUN adduser --disabled-password --gecos '' vivado

WORKDIR /azp

COPY ./azp_start.sh .
RUN chmod +x azp_start.sh

CMD ["./azp_start.sh"]


##git checkout
#RUN git clone git@bitbucket.org:Electreon/mu-fpga-rev-b.git

##copy the build script
#COPY create_bit_stream.tcl /home/vivado/

##Set version 
## Change the version in the source file: /home/vivado/mu-fpga-rev-b/Electreon_on_Zync.srcs/sources_1/new/FPGA_Version.vhd



##Build
#WORKDIR /home/vivado/mu-fpga-rev-b
#RUN source /opt/Xilinx/Vivado/${VIVADO_VERSION}/settings64.sh && vivado -mode batch -source ../create_bit_stream.tcl

#package
# This is the binary: /home/vivado/mu-fpga-rev-b/Electreon_on_Zync.runs/impl_1/Electreon_TOP_wrapper.bit
# It sould be zipped, renamed with the version and copied to BLOB storage




