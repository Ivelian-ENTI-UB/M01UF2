#!/bin/bash

sudo iptables -A OUTPUT -p tcp --dport 3333 -m conntrack --ctstate NEW,ESTABLISHED -j ACCEPT
sudo iptables -A INPUT -p tcp --sport 3333 -m conntrack --ctstate ESTABLISHED -j ACCEPT

PORT=3333
SERVER="localhost"

if [ $# -eq 0 ]
then
	SERVER="localhost"
elif [ $# -ge 1 ]	
then
	SERVER=$1
fi	

IP=`ip address | grep inet | grep -i enp0s3 | cut -d " " -f 6 | cut -d "/" -f 1`

TIMEOUT=1

echo "Cliente de EFTP"

if [ $# -eq 2 ]
then
	echo "(-1) Reset"
	echo "Reset" | nc $SERVER 3333

	sleep 2
fi

echo "(1) Send"

echo "EFTP 1.0 $IP" | nc $SERVER $PORT

echo "(2) Listen"

DATA=`nc -l -p $PORT -w $TIMEOUT`

echo $DATA

echo "(5) Test & Send"

if [ "$DATA" != "OK_HEADER" ] 
then
	echo "ERROR 1: BAD HEADER"
	exit 1
fi

echo "BOOOM"
sleep 1
echo "BOOOM" | nc $SERVER $PORT

echo "(6) Listen"

DATA=`nc -l -p $PORT -w $TIMEOUT`

echo $DATA

echo "(9) Test"

if [ "$DATA" != "OK_HANDSHAKE" ]
then
	echo "ERROR 2: BAD HANDSHAKE"
	exit 2
fi

echo "(9a) SEND NUM_FILES"

NUM_FILES=`ls imgs/ | wc -l`

sleep 1

echo "NUM_FILES $NUM_FILES" | nc $SERVER $PORT

echo "(9b) LISTEN OK/KO_NUM_FILES"

DATA=`nc -l -p $PORT -w $TIMEOUT`

if [ "$DATA" != "OK_FILE_NUM" ]
then
	echo "ERROR 3a: WRONG FILE_NUM"
	exit 3
fi

for FILE_NAME in `ls imgs/`
do


echo "(10b) Send FILE_NAME"

sleep 1

FILE_MD5=`echo $FILE_NAME | md5sum | cut -d " " -f 1`
echo "FILE_NAME $FILE_NAME $FILE_MD5" | nc $SERVER $PORT

echo "(11) Listen"
DATA=`nc -l -p $PORT -w $TIMEOUT`

echo "(14) Test&Send"

if [ "$DATA" != "OK_FILE_NAME" ]
then
	echo "ERROR 3: BAD FILE NAME PREFIX"
	exit 3
fi

sleep 1
cat imgs/fary1.txt | nc $SERVER $PORT

echo "(15) Listen"
DATA=`nc -l -p $PORT -w $TIMEOUT`

if [ "$DATA" != "OK_DATA" ]
then
	echo "ERROR 4: BAD DATA"
	exit 4
fi

echo "(18) Send"

sleep 1

FILE_MD5=`cat imgs/$FILE_NAME | md5sum | cut -d " " -f 1`

echo "FILE_MD5 $FILE_MD5" | nc $SERVER $PORT

echo "(19) Listen"
DATA=`nc -l -p $PORT -w $TIMEOUT`

echo "(21) Test"

if [ "$DATA" != "OK_FILE_MD5" ]
then
	echo "ERROR: FILE MD5"
	exit 5
fi

done

echo "FIN"
exit 0
