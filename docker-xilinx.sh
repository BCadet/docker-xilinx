#!/bin/bash
SCRIPTPATH="$( cd "$(dirname "$0")" >/dev/null 2>&1 ; pwd -P )"

ACTION=$1
ACTION=${ACTION:="build"}
shift

avaliable_installation = ["Vitis" "Vivado" "BootGen" "Lab Edition" "Hardware Server" "PetaLinux" "DocNav"]

FOLDER=${PWD##*/}
FOLDER=${FOLDER:-/}        # to correct for the case where PWD=/

function build_image() {
    INSTALLER=$(ls $PWD | grep Xilinx_Unified_[0-9._]*_Lin64.bin)

    if [ -z $INSTALLER ]; then
        echo "no Xilinx_Unified_... installer found in $PWD"
        return
    fi

    read -p 'enter valid xilinx account mail:' -e 
    mail=${REPLY}
    read -s -p 'enter xilinx password:' -e 
    passwd=${REPLY}

    IMAGE_VERSION=${INSTALLER,,} #convert lowercase (should always be)
    IMAGE_VERSION=${IMAGE_VERSION:15:21} # take the version xxxx.x

    docker buildx build \
        -t vivado:$IMAGE_VERSION \
        --build-arg XILINX_MAIL=${mail} \
        --build-arg XILINX_PASSWD=${passwd} \
        .
}

function run_image() {
    VERSION=$1

    if [ -z $VERSION ]; then
        echo "please provide the xilinx image version you want to run (for example 2022.1)"
        return
    fi

    docker run -it --rm \
        -v `pwd`:/workspaces/$FOLDER \
        --workdir=/workspaces/$FOLDER \
        --env REMOTE_USER="builder" \
        --env NEW_UID=$(id -u) \
        --env NEW_GID=$(id -g) \
        vivado:$VERSION
}

case $ACTION in
    "build")
        build_image
        ;;
    "run")
        run_image
        ;;
    *)
        echo "Action $ACTION not available"
        ;;
esac