#!/bin/bash

BUILD_TREE=.build

function path2id()
{
	echo "$1" | sed 's/\//_/g'
}

function build_construct_tree()
{
	local cmd="$1"
	local cmdline="$2"
	local out=$3
	local in="$4"

	echo "cmd=$1 cmdline=$2 out=$3 in=$4" >> log.tree
   
	out_path=$(path2id $out)
	mkdir -p ${BUILD_TREE}/${out_path}
	echo $cmd > ${BUILD_TREE}/${out_path}/command
	echo $cmdline > ${BUILD_TREE}/${out_path}/cmdline

	for i in ${in}
	do
		ipath=$(path2id $i)

		if [ -e ${BUILD_TREE}/${out_path}/${ipath} ]; then
			rm -rf ${BUILD_TREE}/${out_path}/${ipath}
		fi

		if [ -e ${BUILD_TREE}/${ipath} ]; then
			mv ${BUILD_TREE}/${ipath} ${BUILD_TREE}/${out_path}/
		else
			mkdir -p ${BUILD_TREE}/${out_path}/${ipath}
		fi
	done
}
