#!/usr/bin/env bash
[[ ! ${ROLL_DIR} ]] && >&2 echo -e "\033[31mThis script is not intended to be run directly!\033[0m" && exit 1

## allow return codes from sub-process to bubble up normally
trap '' ERR


echo "Starting containers..."

"${ROLL_DIR}/bin/roll" env up
sleep 1

echo ""
echo "containers started"


