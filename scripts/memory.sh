#!/usr/bin/env bash

set -o errexit
set -o pipefail
set -o nounset

export SRC_DIR="../src/"
export BUILD_DIR="../build/"
export LOG_DIR="$BUILD_DIR/logs/"
export REPORT_DIR="$BUILD_DIR/reports/"

if [ -d $BUILD_DIR ]; then
    rm -rf $BUILD_DIR
fi

vivado -notrace -mode batch -source memory.tcl
