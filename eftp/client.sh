#!/bin/bash

# IP del servidor (localhost en este caso)
SERVER="localhost"

echo "Cliente de EFTP"

# Obtención de la dirección IP del cliente
IP_CLIENTE=$(ip address | grep inet | grep enp0s3 | cut -d ' ' -f10 | cut -d '/' -f1)

echo "(1) Send"
# Enviar la cabecera y la IP del cliente al servidor
echo "EFTP 1.0 $IP_CLIENTE" | nc $SERVER 3333

echo "(2) Listen"
# Esperar respuesta del servidor
DATA=$(nc -l -p 3333 -w 0)

echo $DATA

echo "(5) Test & Send"

# Verificar la respuesta del servidor
if [ "$DATA" != "OK_HEADER" ]
then
    echo "ERROR 1: BAD HEADER"
    exit 1
fi

# Enviar confirmación al servidor
echo "BOOOM"
sleep 1
echo "BOOOM" | nc $SERVER 3333

echo "(6) Listen"
# Esperar la respuesta final del servidor
DATA=$(nc -l -p 3333 -w 0)

echo $DATA

