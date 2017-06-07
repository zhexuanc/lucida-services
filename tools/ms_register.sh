#!/bin/bash

echo "============================================="
echo "     Lucida Micro Service Building Tools"
echo "          made in May 31, 2017"
echo "============================================="
echo ""

check_valid () {
	if [ "$1" = "NAME" ]; then
		python service_mongo.py check name $2
		return $?
	elif [ "$1" = "ACN" ]; then
		python service_mongo.py check acronym $2
		return $?
	elif [ "$1" = "HOST_PORT" ]; then
		python service_mongo.py check_host_port $2 $3
		return $?
	fi
}

OP=""
if [ "$1" = "add" ]; then
	OP="add"
elif [ "$1" = "delete" ]; then
	OP="delete"
else
	echo "### Specify what you want to do (add or delete)"
	printf "### Enter you want to do: "
	read OP
fi

if [ "$OP" = "add" ]; then
	NAME_VALID=1
	while [ $NAME_VALID -ne 0 ]; do
		echo "### Specify your service name (e.g. musicservice)."
		printf "### Enter your service name: "
		read NAME
		if [ "$NAME" = "" ]; then
			echo "[Error] Service name cannot be empty! Please try another one!"
		else
			check_valid NAME $NAME
			NAME_VALID=$?
			if [ $NAME_VALID -ne 0 ]; then
				echo "[Error] Service name used! Please try another one!"
			fi
		fi
	done

	echo ""
	ACN_VALID=1
	while [ $ACN_VALID -ne 0 ]; do
		echo "### Specify the acronym of your service (e.g. MS)."
		printf "### Enter the acronym of your service: "
		read ACN
		if [ "$ACN" = "" ]; then
			echo "[Error] Service acronym cannot be empty! Please try another one!"
		else
			check_valid ACN $ACN
			ACN_VALID=$?
			if [ $ACN_VALID -ne 0 ]; then
				echo "[Error] Service acronym used! Please try another one!"
			fi
		fi
	done

	echo ""
	echo "### Specify the programming language you want to you in your programming. If C++/Java/Python, then template will be provided."
	printf "### Enter the programming language: "
	read LAN

	echo ""
	HOST_VALID=1
	while [ $HOST_VALID -ne 0 ]; do
		echo "### Specify the host/port information for your service. "
		printf "### Enter the host: "
		read HOST
		if [ "$HOST" = "" ]; then
			echo "[Error] Service host cannot be empty! Please try another one!"
		else
			HOST_VALID=0
		fi
	done

	PORT_VALID=1
	while [ $PORT_VALID -ne 0 ]; do
		printf "### Enter the port: "
		read PORT
		if [ "$PORT" = "" ]; then
			echo "[Error] Service port cannot be empty! Please try another one!"
		else
			check_valid HOST_PORT $HOST $PORT
			PORT_VALID=$?
			if [ $PORT_VALID -ne 0 ]; then
				echo "[Error] Service host/port pair already used! Please try another one!"
			fi
		fi
	done

	echo ""
	INPUT_VALID=1
	while [ $INPUT_VALID -ne -0 ]; do
		echo "Specify the input type of your service (text, image or text_image)"
		printf "### Enter the input type: "
		read INPUT
		if [ "$INPUT" = "" ]; then
			echo "[Error] Service input type cannot be empty! Please try another one!"
		else
			INPUT_VALID=0
		fi
	done

	python service_mongo.py add $NAME $ACN $HOST $PORT $INPUT

	if [ "$LAN" = "C++" -o "$LAN" = "cpp" ]; then
		# do copy template folder of cpp to lucida
		cd ../lucida ; \
		if [ -d $NAME ]; then
			echo "[Error] service already exists!"
		else
			cp -rf template/cpp .
			mv cpp $NAME
			echo "[Info] Template folder is ready cpp!"
		fi
	elif [ "$LAN" = "Java" -o "$LAN" = "java" ]; then
		# do copy template folder of java to lucida
		cd ../lucida ; \
		if [ -d $NAME ]; then
			echo "[Error] service already exists!"
		else
			cp -rf template/java .
			mv java $NAME
			echo "[Info] Template folder is ready java!"
		fi
	elif [ "$LAN" = "Python" -o "$LAN" = "python" ]; then
		# do copy template folder of python to lucida
		cd ../lucida ; \
		if [ -d $NAME ]; then
			echo "[Error] service already exists!"
		else
			cp -rf template/python .
			mv python $NAME
			echo "[Info] Template folder is ready python!"
		fi
	else
		# create an empty folder
		cd ../lucida ; \
		if [ -d $NAME ]; then
			echo "[Error] service already exists!"
		else
			mkdir $NAME
			echo "[Info] Template folder is ready!"
		fi
	fi
elif [ "$OP" = "delete" ]; then
	NAME_VALID=0
	while [ $NAME_VALID -ne 1 ]; do
		echo "### Specify the service name you want to delete (e.g. musicservice)."
		printf "### Enter your service name: "
		read NAME
		if [ "$NAME" = "" ]; then
			echo "[Error] Service name cannot be empty! Please try another one!"
		else
			check_valid NAME $NAME
			NAME_VALID=$?
			if [ $NAME_VALID -ne 1 ]; then
				echo "[Error] Service name not exists! Please try another one!"
			fi
		fi
	done

	python service_mongo.py delete $NAME

	cd ../lucida
	if [ -d $NAME ]; then
		rm -rf $NAME
		echo "[Info] service already deleted!"
	else
		echo "[Error] service not exists!"
	fi
fi
