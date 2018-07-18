#!/bin/bash

pid=$$
cmdline=""

running=1

function find_input_pipe_process()
{
	local pipe=$1

	for input in /proc/*/fd/0;
	do
		real=$(realpath $input)
		ipipe=$(echo $real |  awk -F ":" '{print $2}' | sed -e 's/\[//' -e 's/\]//')
		if [ "$ipipe" == "$pipe" ]; then
			# return the pid
			echo $input | sed -r 's/\/proc\/(\[\[:digit\]\]+)\/fd\/0/\1/'
			return
		fi
	done
}

while [ $running -eq 1 ]; do
	cmdline="$cmdline|$(cat /proc/$pid/cmdline |sed -r 's/\x00/ /g')"
	stdout=$(realpath /proc/$pid/fd/1)
	if [ -f $stdout ]; then
		echo "cmd: \"$cmdline\", out $stdout"
		break
	elif echo $stdout | egrep -q "pipe:\[[[:digit:]]*\]"; then
		echo "cmd: \"$cmdline\", out is pipe"
		pipe=$(echo $stdout | awk -F ":" '{print $2}' | sed -e 's/\[//' -e 's/\]//')
		pid=$(find_input_pipe_process $pipe)
		continue
	fi

	break
done
