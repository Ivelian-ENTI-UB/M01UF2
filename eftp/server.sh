#!/bin/bash

<<<<<<< HEAD
CLIENT=$(ip address | grep inet | grep enp0s3 | cut -d ' ' -f6 | cut -d '/' -f1)
=======
CLIENT=ip address | grep inet | grep enp0s3 | cut -d ' ' -f6 | cut -d '/' -f1 
>>>>>>> 05790c1efa5b0fdaf06841659c71c087fc900562
echo "Servidor de EFTP"

# (0) Listen
DATA=$(nc -l -p 3333 -w 0)
echo $DATA

# (3) Test & Send
if [ "$DATA" != "EFTP 1.0" ]; then
    echo "ERROR 1: BAD HEADER"
    sleep 1
    echo "KO_HEADER" | nc $CLIENT 3333
    exit 1
fi
echo "OK_HEADER"
sleep 1
echo "OK_HEADER" | nc $CLIENT 3333

# (4) Listen
DATA=$(nc -l -p 3333 -w 0)
echo $DATA

# (7) Test & Send
if [ "$DATA" != "BOOOM" ]; then
    echo "ERROR 2: BAD HANDSHAKE"
    sleep 1
    echo "KO_HANDSHAKE" | nc $CLIENT 3333
    exit 2
fi
echo "OK_HANDSHAKE"
sleep 1
echo "OK_HANDSHAKE" | nc $CLIENT 3333

# (8) Listen
DATA=$(nc -l -p 3333 -w 0)
echo $DATA

