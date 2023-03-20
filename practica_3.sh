#!/bin/bash
permisos=$(id | cut -c 5)
if [ "$permisos" -ne 0 ]
then
        echo "Este script necesita privilegios de administracion"
        exit 1
fi
if [ $# -ne 2 ]
then
        echo "Numero incorrecto de parametros"
        exit 1
else
        if [ "$1" == "-a" ]
        then
                while  read linea; 
                do
                        nombre=$(echo "$linea" | cut -d ',' -f 1)
                        password=$(echo "$linea" | cut -d ',' -f 2)
                        nombreCompleto=$(echo "$linea" | cut -d ',' -f 3)
                        if [  "$nombre" -a "$password" -a "$nombreCompleto" ]
                        then    
                                useradd $nombre -c "$nombreCompleto" -m -k /etc/skel -K UID_MIN=1815 -U 2> /dev/null
                                if [ $? -eq 0 ]
                                then
                                        chpasswd "$nombre:$password"
                                        usermod "$nombre" -f 30
                                        echo ""$nombreCompleto" ha sido creado"
        
                                else
                                        id=$(id -u "$nombre")
                                        echo "El usuario "$id" ya existe"
                                fi
                        else
                                echo "Campo invalido"
                                exit 1
                        fi
                done < "$2"

        elif [ "$1" == "-s" ]
        then
                if [ ! -d /extra/backup ]
                then
                        mkdir -p /extra/backup 2> /dev/null
                fi
                while read linea
                do
                        nombre=$(echo "$linea" | cut -d ',' -f 1)
                        if [ "$nombre"  ]
                        then
                                home=$(getent passwd "$nombre" | cut -d ':' -f 6)
                                tar -cfzp /extra/backup/"$nombre".tar "$home" 2> /dev/null
                                if [ $? -eq 0 ]
                                then    
                                        userdel -r "$nombre" 2> /dev/null

                                fi      
                        fi
                done < "$2"
        else
                echo "Opcion invalida" >&2
                exit 1
        fi
fi