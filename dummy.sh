#!/bin/bash 

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null && pwd )"
file=$DIR"/server.py"
echo  $file

xterm -hold -e "python $file 15100" &

xterm -hold -e "python $file 15200" &

xterm -hold -e "python $file 15300" &
