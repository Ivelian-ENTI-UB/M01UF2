#!/bin/bash

echo "Servidor de EFTP"

echo "(1) Listen"
DATA=$(nc -l -p 3333 -w 0)
echo $DATA

echo "(3) Test & Send"
PROCESSED_HEADER=$(echo $DATA | cut -d ' ' -f1-2)

if [ "$PROCESSED_HEADER" != "EFTP 1.0" ]; then
    echo "ERROR 1: BAD HEADER"
    CLIENT_IP=$(echo $DATA | cut -d ' ' -f3)
    echo "KO_HEADER" | nc $CLIENT_IP 3333
    exit 1
else
    CLIENT_IP=$(echo $DATA | cut -d ' ' -f3)
    echo "OK_HEADER" | nc $CLIENT_IP 3333
fi

echo "(4) Listen"
DATA=$(nc -l -p 3333 -w 0)
echo $DATA

echo "(7) Test & Send"
if [ "$DATA" = "BOOOM!" ]; then
    echo "ERROR 2: BAD HANDSHAKE"
    echo "KO_HANDSHAKE" | nc $CLIENT_IP 3333
    exit 2
else
    echo "OK_HANDSHAKE" | nc $CLIENT_IP 3333
fi

echo "(8) Listen"
DATA=$(nc -l -p 3333 -w 0)
echo $DATA
