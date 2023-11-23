#!/bin/bash

SERVER="localhost"  # Replace with the actual server address if necessary
echo "Cliente de EFTP"

# (1) Send
echo "EFTP 1.0" | nc $SERVER 3333

# (2) Listen
DATA=$(nc -l -p 3333 -w 0)
echo $DATA

# (5) Test & Send
if [ "$DATA" != "OK_HEADER" ]; then
    echo "ERROR 1: BAD HEADER"
    exit 1
fi

echo "BOOOM" | nc $SERVER 3333

# (6) Listen
DATA=$(nc -l -p 3333 -w 0)
echo $DATA
