#!/bin/bash

path=$(dirname $(realpath $0))
function add_qouting()
{
    echo "$@" | sed -r "s/(\"[^[:space:]]*\")/\'\1\'/g"
}

eval $path/hook_$1 $@ || exit 1

eval $(add_qouting $@)

