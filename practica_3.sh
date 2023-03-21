# #!/bin/bash
# if [ $EUID -ne 0 ]; 
# then 
# 	echo "Este script necesita privilegios de administracion"; 
# 	exit 1; 
# fi
# if [ $# -eq 2 ]
# then
#     ADD USER
#     if [ $1 = "-a" ]
#     then
#         READING USER PER USER
#         while IFS= read -r user
#         do
#             IFS=,
#             read -ra user_fields <<< "$user"
#             if [ ${#user_fields[@]} -ne 3 ]; then exit 1; fi
#             for i in "${user_fields[@]}"
#             do 
#                 if [ -z i ]; then echo "Campo invalido"; exit 1; fi
#             done
#             ADDING NEW USER
#             useradd -m -k /etc/skel -U -K UID_MIN=1815 -c "${user_fields[2]}" -g "${user_fields[0]}" "${user_fields[0]}" &>/dev/null
            
#             if [ $? -eq 0 ]
#             then
#                 usermod -aG 'sudo' ${user_fields[0]}
#                 passwd -x 30 ${user_fields[0]} &>/dev/null
#                 echo "${user_fields[0]}:${user_fields[1]}" | chpasswd
#                 echo "${user_fields[2]} ha sido creado"
#             else 
# 				echo "El usuario ${user_fields[0]} ya existe".
#             fi
#         done < $2
#     DELETE USER
#     elif [ $1 = "-s" ]
#     then
#         BACKUP DIRECTORY CREATION
#         if [ ! -d /extra ]; then mkdir -p /extra/backup
#         elif [ ! -d /extra/backup ]; then mkdir /extra/backup
#         fi
#         READING USER PER USER
#         while IFS= read -r user
#             do
#                 IFS=,
#                 read -ra user_fields <<< "$user"
#                 if [ ${#user_fields[@]} -ne 1 -a ${#user_fields[@]} -ne 3 ]; then exit 1; fi
#                 for i in "${user_fields[@]}"
#                 do 
#                     if [ -z i ]; then echo "Campo invalido"; exit 1; fi
#                 done
#                 ADDING NEW USER
#                 user_home="$(getent passwd ${user_fields[0]} | cut -d: -f6)"
#                 tar cvf /extra/backup/${user_fields[0]}.tar $user_home &>/dev/null
#                 if [ $? -eq 0 ]; then userdel -f ${user_fields[0]} &>/dev/null; fi
#             done < $2
#     INVALID OPTION
#     else echo "Opcion invalida" 1>&2
#     fi
# else echo "Numero incorrecto de parametros"
# fi























if [ $EUID -ne 0 ]
then
        echo "Este script necesita privilegios de administracion"
        exit 1
fi
if [ $# -ne 2 ]
then
        echo "Numero incorrecto de parametros"
        exit 1
else
        if [ $1 == "-a" ]
        then
                while  read linea; 
                do
                        nombre=$(echo "$linea" | cut -d ',' -f 1)
                        password=$(echo "$linea" | cut -d ',' -f 2)
                        nombreCompleto=$(echo "$linea" | cut -d ',' -f 3)
                        if [  "$nombre" -a "$password" -a "$nombreCompleto" ]
                        then    
                                useradd $nombre -c "$nombreCompleto" -m -k /etc/skel -K UID_MIN=1815 -U &> /dev/null
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

        elif [ $1 == "-s" ]
        then
                if [ ! -d /extra/backup ]
                then
                        mkdir -p /extra/backup &> /dev/null
                fi
                while read linea
                do
                        nombre=$(echo "$linea" | cut -d ',' -f 1)
                        if [ "$nombre"  ]
                        then
                                home=$(getent passwd "$nombre" | cut -d ':' -f 6)
                                tar -cfzp /extra/backup/"$nombre".tar "$home" &> /dev/null
                                if [ $? -eq 0 ]
                                then    
                                        userdel -r "$nombre" &> /dev/null

                                fi      
                        fi
                done < "$2"
        else
                echo "Opcion invalida" 1>&2
                exit 1
        fi
fi

















# #funcion para los mensajes de error
# usage(){
# 	msg=("Este script necesita privilegios de administracion" "Numero incorrecto de parametros" "Campo invalido" "Opcion invalida")
# 	echo "${msg[$1]}"
# 	exit 1
# }

# #funcion para añadir usuario
# adduser(){
# 	OLDIFS=$IFS
# 	IFS=,
# 	while read user pass name
# 	do
# 		if [ "$user" =   "" -o "$pass" = "" -o "$name" = "" ]
# 		then
# 		       	usage 2
# 		fi
# 		useradd -c "$name" "$user" -m -k /etc/skel -K UID_MIN=1815 -U 2>/dev/null
# 		#comprobamos si existe el usuario
# 		if [ "$?" -ne 0 ]
# 		then 
# 			echo "El usuario $user ya existe"
# 		else
# 			echo "$user:$pass" | chpasswd
# 			usermod "$user" -f 30
# 			echo "$name ha sido creado"
# 		fi
# 	done < $1
# }

# #borrar usuario
# delUser(){
# 	if [ ! -d /extra/backup ]
# 	then
# 		mkdir -p /extra/backup
# 	fi
# 	OLDIFS=$IFS
# 	IFS=,
# 	while read user pass name
# 	do
# 		userHome=$(getent passwd "$user" | cut -d: -f6)
# 		tar czfp /extra/backup/"$user".tar "$userHome" 2>/dev/null
# 		if [ "$?" -eq 0 ]
# 		then
# 			userdel -r "$user" 2>/dev/null
# 		fi
# 	done < $1
# }

# #main

# if [ "$UID" -ne 0 ]
# then
# 	usage 0
# fi

# if [ "$#" -ne 2 ]
# then 
# 	usage 1
# else
# 	if [ "$1" = "-a" ]
# 	then
# 		addUser $2
# 	elif [ "$1" = "-s" ]
# 	then 
# 		delUser $2
# 	else
# 		usage 3 >&2
# 	fi	
# 	fi








