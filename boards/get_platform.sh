#!/bin/bash

BOARD=$1
VITIS_PLATFORM=$2
DOWNLOAD=$3
PFM_NAME=$(echo $2 | rev | cut -d'/' -f1 | rev | cut -d'.' -f1)
CURDIR=$(pwd)
#URL="https://www.xilinx.com/bin/public/openDownload?filename=${PFM_NAME}_2019.2.zip"

# disable download; not available for 2020.1 yet

# platform can be either downloaded or built from scratch
#if [[ $DOWNLOAD -eq 1 ]]; then
#	cd ${BOARD}
#	wget $URL -O ${PFM_NAME}.zip
#	unzip ${PFM_NAME}.zip
#	rm ${PFM_NAME}.zip
#else
if [ ! -d PYNQ-derivative-overlays ]; then
	git clone https://github.com/yunqu/PYNQ-derivative-overlays.git
	cd PYNQ-derivative-overlays
	# checkout to commit: update scripts for 2020.1
	git checkout ef0195dcac9169a8da04086bda0b2b4380a9097f
fi
cd ${CURDIR}/PYNQ-derivative-overlays/dpu
make clean && make BOARD=${BOARD}
cd ${CURDIR}/PYNQ-derivative-overlays/vitis_platform
make XSA_PATH=../dpu/dpu.xsa BOARD=${BOARD}
cp -rf ${CURDIR}/PYNQ-derivative-overlays/vitis_platform/${BOARD}/platforms/${PFM_NAME} \
		${CURDIR}/${BOARD}
#fi

cd ${CURDIR}
