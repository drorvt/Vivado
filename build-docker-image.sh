#!/bin/bash




echo "Type the path of the the installation file (Default: $HOME/Downloads/Xilinx_Vivado_SDK_2018.3_1207_2324.tar.gz):"

read XILINX_VIVADO_PATH
XILINX_VIVADO_PATH=${XILINX_VIVADO_PATH:-$HOME/Downloads/Xilinx_Vivado_SDK_2018.3_1207_2324.tar.gz}



DEFAULT_IP=$(ip route get 8.8.8.8 | awk -F"src " 'NR==1{split($2,a," ");print a[1]}')
HTTP_DIR=$(dirname $XILINX_VIVADO_PATH)
XILINX_VIVADO_FILE_NAME=$(basename $XILINX_VIVADO_PATH .tar.gz)
XILINX_VIVADO_VERSION=$(echo "$XILINX_VIVADO_FILE_NAME" | sed 's/^.*_\([0-9]\+\.[0-9]\+\)_.*/\1/')

echo "Vivado $XILINX_VIVADO_VERSION will be installed in $XILINX_VIVADO_PATH"


pushd $HTTP_DIR > /dev/null

echo "Starting HTTP Server in $(pwd)"

python3 -m http.server &
HTTP_SERVER_PID=$!

popd > /dev/null


echo "HTTP Server pid is $HTTP_SERVER_PID listening on $DEFAULT_IP:8000"


docker build --build-arg VIVADO_TAR_HOST=$DEFAULT_IP:8000 --build-arg VIVADO_TAR_FILE=$XILINX_VIVADO_FILE_NAME -t vivado:$XILINX_VIVADO_VERSION --build-arg VIVADO_VERSION=$XILINX_VIVADO_VERSION .

echo "Terminating pid $HTTP_SERVER_PID"
kill $HTTP_SERVER_PID


