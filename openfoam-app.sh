#!/bin/bash

# Save the current directory
HERE=$PWD
source ../.env
export NO_BUILD=yes

export BUILD_DIR=/build-dir/$OS_VER
export INSTALL_DIR=/install-dir/$OS_VER

mkdir -p $BUILD_DIR
mkdir -p $INSTALL_DIR

# Foundation
source mpich.sh

# Apps
source openfoam.sh

export OPENFOAM_DIR=$INSTALL_DIR/OpenFOAM-v${OPENFOAM_VER}
cd $OPENFOAM_DIR
source etc/bashrc

# Restore the current directory
cd $HERE

echo "Job is: $PBS_JOBID"
echo "Mom is: $(hostname)"
echo "Running from $(pwd)"

NP=$((${nx}*${ny}))
perl -p -i -e "s/^[ \t]*PX[ \t]*=[ \t]*\d+[ \t]*$/PX=$nx/" input.txt
perl -p -i -e "s/^[ \t]*PY[ \t]*=[ \t]*\d+[ \t]*$/PY=$ny/" input.txt
mpirun -np "${NP}" -machinefile "$PBS_NODEFILE" $NHWAVE_DIR/src/nhwave
