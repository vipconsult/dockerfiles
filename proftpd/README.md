# Running the conatiner
docker run --net=host -d --name proftpd  -v /host_folder_to_share:/home/username vipconsult/proftpd

# Passive mode note
--net=host - required for passive mode connections.

# Persistent users
to make the users persistand share te paswd file with the host or a data 
-v /home/docker/proftpd/ftpd.passwd:/etc/proftpd/ftpd.passwd 


# Adding new user
docker exec -it  proftpd ftpasswd --file /etc/proftpd/ftpd.passwd --passwd --shell=/bin/false  --name=username --uid=33 --home=/home/username 

#User permissions note
--uid - needs to be set to a user id that has permissions to read and write to the home directory

# Deleting user
docker exec -it container_name ftpasswd --passwd --file /etc/proftpd/ftpd.passwd --delete-user --name username

# Exmaple with persistant users
docker run --restart=always --net=host -d --name proftpd -v /home/http:/home/ -v /home/docker/proftpd/ftpd.passwd:/etc/proftpd/ftpd.passwd vipconsult/proftpd



