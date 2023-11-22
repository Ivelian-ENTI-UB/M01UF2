#!/bin/bash

CLIENT="ip address | grep inet | grep enp0s3 | cut -d ' ' -f6 | cut -d '/' -f1 "
echo "Servidor de EFTP"

echo "(1) Listen"
DATA=$(nc -l -p 3333 -w 0)
echo $DATA

HEADER=$(echo $DATA | cut -d' ' -f1-2)
IP_CLIENTE=$(echo $DATA | cut -d' ' -f3)

echo "(3) Test & Send"

if [ "$HEADER" != "EFTP 1.0" ]; then
    echo "ERROR 1: BAD HEADER"
    sleep 1
    # Usar la IP del cliente extraída para enviar el mensaje de error
    echo "KO_HEADER" | nc $IP_CLIENTE 3333
    exit 1
fi

echo "OK_HEADER"
sleep 1
echo "OK_HEADER" | nc $CLIENT 3333

echo "(4) Listen"

DATA=`nc -l -p 3333 -w 0`

echo $DATA

echo "(7) Test & Send"
if [ "$DATA" != "BOOOM" ]
then echo "ERROR 2: BAD HANDSHAKE"
sleep 1
echo "KO_HANDSHAKE" | nc $CLIENT 3333
exit 2
fi

echo "OK_HANDSHAKE"
sleep 1
echo "OK_HANDSHAKE" | nc $CLIENT 3333

echo "(8) Listen"

DATA=`nc -l -p 3333 -w 0`
