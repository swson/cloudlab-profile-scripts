#!/bin/bash

# referred online resources:
#    https://github.com/riscv-collab/riscv-gnu-toolchain
#    https://riscv.epcc.ed.ac.uk/documentation/how-to/install-toolchain/

echo "updating system and installing prerequisites..."
sudo apt update
sudo apt install autoconf automake autotools-dev curl python3 libmpc-dev libmpfr-dev libgmp-dev gawk build-essential bison flex texinfo gperf libtool patchutils bc zlib1g-dev libexpat-dev -y​

echo "cloning toolchain repository..."
mkdir RISCV
cd RISCV
git clone --recursive https://github.com/riscv/riscv-gnu-toolchain​
cd riscv-gnu-toolchain

echo "configuring and building for rv32gc..."
mkdir build
cd build
../configure --prefix=/opt/riscv --with-arch=rv32gc –with-abi=ilp32d​
sudo make -j$(nproc) linux

echo "adding the RISC-V toolchain to PATH"
export PATH=/opt/riscv/bin:$PATH
