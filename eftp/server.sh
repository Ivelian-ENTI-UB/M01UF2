#!/bin/bash

echo "Servidor de EFTP"

# Obtención de la dirección IP del servidor (para uso en la red local)
SERVER_IP=$(ip address | grep inet | grep enp0s3 | awk '{print $2}' | cut -d '/' -f1)

echo "(1) Listen"
# Esperar datos del cliente
DATA=$(nc -l -p 3333 -w 0)
echo $DATA

# Extraer cabecera e IP del cliente
HEADER=$(echo $DATA | cut -d ' ' -f 1-2)
IP_CLIENTE=$(echo $DATA | cut -d ' ' -f 3)

echo "(3) Test & Send"

# Verificar la cabecera
if [ "$HEADER" != "EFTP 1.0" ]; then
    echo "ERROR 1: BAD HEADER"
    echo "KO_HEADER" | nc $IP_CLIENTE 3333
    exit 1
fi

# Enviar confirmación al cliente
echo "OK_HEADER" | nc $IP_CLIENTE 3333

echo "(4) Listen"
# Esperar confirmación del cliente
DATA=$(nc -l -p 3333 -w 0)
echo $DATA

echo "(7) Test & Send"
# Verificar la confirmación del cliente
if [ "$DATA" != "BOOOM" ]; then
    echo "ERROR 2: BAD HANDSHAKE"
    echo "KO_HANDSHAKE" | nc $IP_CLIENTE 3333
    exit 2
fi

# Enviar la respuesta final al cliente
echo "OK_HANDSHAKE" | nc $IP_CLIENTE 3333

echo "(8) Listen"
# Esperar cualquier dato adicional del cliente
DATA=$(nc -l -p 3333 -w 0)
