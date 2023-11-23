#!/bin/bash

SERVER="localhost"
echo "Cliente de EFTP"

IP=$(ip address | grep inet | grep enp0s3 | cut -d ' ' -f6 | cut -d '/' -f1)
HEADER="EFTP 1.0 $IP"

echo $HEADER | nc $SERVER 3333

echo "(2) Listen"
DATA=$(nc -l -p 3333 -w 0)
echo $DATA

echo "(5) Test & Send"
if [ "$DATA" != "OK_HEADER" ]; then
    echo "ERROR 1: BAD HEADER"
    exit 1
fi

echo "BOOOM!" | nc $SERVER 3333

echo "(6) Listen"
DATA=$(nc -l -p 3333 -w 0)
echo $DATA
