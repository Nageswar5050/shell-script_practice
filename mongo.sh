#!/bin/bash

ID=$(id -u)
DATEANDTIME=$(date +%F-%H:%M:%S)
LOGFILE="/tmp/$0-$DATEANDTIME.log"
R="\e[31m"
G="\e[32m"
Y="\e[33m"
NC="\e[0m"

echo "Script starting executing at $DATEANDTIME" &>>$LOGFILE 

if [ $ID -ne 0 ]
then
    echo -e "$Y You should run this using root$NC"
    exit 1
fi

VALIDATE(){
    if [ $? -ne 0 ]
    then
        echo -e "$1.....$R FAILED$NC"
        exit 1
    else
        echo -e "$1.....$G SUCCESS$NC"
    fi
}

cp -u /home/centos/shell-script_practice/dependent_files/mongo.repo /etc/yum.repos.d/mongo.repo &>>$LOGFILE

VALIDATE "Copyting mongo repo"

dnf install mongodb-org -y &>>$LOGFILE

VALIDATE "Installing mongo"

systemctl enable mongod &>>$LOGFILE

VALIDATE "Enabling mongod"

systemctl enable start &>>$LOGFILE

VALIDATE "Starting mongod"

sed -i 's/127.0.0.1/0.0.0.0/' /etc/mongod.conf &>>$LOGFILE

VALIDATE "Changing local to global in mongo.conf"

systemctl restart mongod &>>$LOGFILE

VALIDATE "Restarting mongo"