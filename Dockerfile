FROM ubuntu:20.04

LABEL maintainer "BCadet <https://github.com/BCadet>"

RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y -q \
    gosu \
    expect

ADD https://gist.githubusercontent.com/BCadet/372702916a20b141cb78ea889e3dae59/raw/73822ba555bfbd75ab7c09c90d463585535e5a0e/container-entrypoint /container-entrypoint
RUN chmod +x /container-entrypoint
ENTRYPOINT [ "/container-entrypoint" ]

# create user
RUN useradd --create-home builder

RUN mkdir /xilinx
COPY ./Xilinx_Unified_* /xilinx

WORKDIR /xilinx
RUN chmod +x ./Xilinx_Unified_* && \
    ./Xilinx_Unified_* --tar -xf -C .

ADD https://gist.githubusercontent.com/BCadet/f4f564baf2829406fbead336fa594a54/raw/45d7628f1ab08df89663ef6b08ecebb0d95cc46e/xilinx_autoGenToken.sh /xilinx/xilinx_autoGenToken.sh
RUN chmod +x ./xilinx_autoGenToken.sh
ARG XILINX_MAIL
ARG XILINX_PASSWD
RUN ./xilinx_autoGenToken.sh ./xsetup ${XILINX_MAIL:?Missing email} ${XILINX_PASSWD:?Missing password}

COPY ./vivado_install_config.txt /xilinx/vivado_install_config.txt
RUN ./xsetup -a XilinxEULA,3rdPartyEULA -b Install -c ./vivado_install_config.txt