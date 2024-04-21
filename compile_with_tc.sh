#!/bin/bash
# Copyright cc 2023 sirnewbies

# setup color
red='\033[0;31m'
green='\e[0;32m'
white='\033[0m'
yellow='\033[0;33m'

# setup dir
WORK_DIR=$(pwd)
KERN_IMG="${WORK_DIR}/out/arch/arm64/boot/Image-gz.dtb"
KERN_IMG2="${WORK_DIR}/out/arch/arm64/boot/Image.gz"

#!/bin/bash

# Define the directory
directory="arch/arm64/config/"

# List files in the directory
files=$(ls -1 "$directory")

# Prompt user to select a file
echo "Please select a file:"
select file in $files; do
    if [ -n "$file" ]; then
        echo "You selected: $file"
        # Copy the selected file to devconf
        cp "$directory$file" devconf
        echo "File copied to devconf."
        break
    else
        echo "Invalid selection. Please try again."
    fi
done


function clean() {
    echo -e "\n"
    echo -e "$red << cleaning up >> \n$white"
    echo -e "\n"
    rm -rf out
}

function build_kernel() {
    export PATH="/home/romiyusnandar/toolchains/proton-clang/bin:$PATH"
    make -j$(nproc --all) O=out ARCH=arm64 ${devconf}_defconfig
    make -j$(nproc --all) ARCH=arm64 O=out \
                          CC=clang \
                          CROSS_COMPILE=aarch64-linux-gnu- \
                          CROSS_COMPILE_ARM32=arm-linux-gnueabi-
    if [ -e "$KERN_IMG" ] || [ -e "$KERN_IMG2" ]; then
        echo -e "\n"
        echo -e "$green << compile kernel success! >> \n$white"
        echo -e "\n"
    else
        echo -e "\n"
        echo -e "$red << compile kernel failed! >> \n$white"
        echo -e "\n"
    fi
}

# execute
clean
build_kernel
