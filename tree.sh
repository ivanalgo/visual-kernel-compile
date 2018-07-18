#!/bin/bash

BUILD_TREE=.build
function build_construct_tree()
{
    local cmd=$1
    local cmdline="$2"
    local out=$3
    local in="$4"

    mkdir -p ${BUILD_TREE}/$out
    touch ${BUILD_TREE}/$out/out
    echo $cmd > ${BUILD_TREE}/$out/command
    echo $cmdline > ${BUILD_TREE}/$out/cmdline
    for i in ${in}
    do
        mkdir -p ${BUILD_TREE}/$out/$i
        touch ${BUILD_TREE}/$out/$i/in
    done
}
