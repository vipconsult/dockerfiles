#! /bin/bash

# your MySQL server's ip or domain name
SERVER=${backup_container:=`hostname`}

# directory to backup to. It is now set to  same directory where the script file is.
BACKDIR=${backup_dir:="/home/vipconsult/mysql_backup"}

# date format that is appended to filename
DATE=`date +'%d-%m-%Y'`
DATE_old=$(date --date="yesterday" +"%d-%m-%Y")

#----------------------MySQL Settings--------------------#

# set to 'y' if you want to backup all your databases. this will override
# the database selection above.
DUMPALL=y


#-------------------Deletion Settings-------------------#

# delete old files?
DELETE=y

# how many days of backups do you want to keep?
DAYS=60

#----------------------End of Settings------------------#

        echo -e "<<<<< Backing up MYSQL server $SERVER on host $HOST >>>>>>>\n\n "

         echo "Making backup directory in $BACKDIR"

        if ! mkdir -p $BACKDIR; then
                echo "Cannot create backup directory in $BACKDIR. Go and fix it!" 1>&2
                exit 1;
        fi;

if  [ $DUMPALL = "y" ]; then
        # test connection to the server
        mysql -h $SERVER -Bse "show databases;"
        if [[ $? -ne 0 ]]; then
            echo -e "\n\n\n ERROR: $SERVER MYSQL backup failed! :::  Cannot Connect to the mysql server  \n" 1>&2;
            exit;
        else
            echo -e "Connected to the server OK \n"
        fi

        echo -n "Creating list of all your databases..."
        DBS="$(mysql -h $SERVER -Bse 'show databases;')"
fi

echo $DBS;
for database in $DBS
do
if [[ ($database != "information_schema") && ($database != "performance_schema") ]]; then
    echo "Backing up database $database..."
    mkdir -p $BACKDIR/$database

    mysqldump -h $SERVER --events $database > $BACKDIR/$database/$database-$DATE.sql
    gzip -f -9 $BACKDIR/$database/$database-$DATE.sql

    new_file=`stat -c %s $BACKDIR/$database/$database-$DATE.sql.gz`
    new_file=$(($new_file / 1024))
    if [ -f $BACKDIR/$database/$database-$DATE_old.sql.gz ]; then
    old_file=`stat -c %s $BACKDIR/$database/$database-$DATE_old.sql.gz`
    old_file=$(($old_file / 1024))
    else
    old_file=0
fi

filesize_difference=$(($new_file - $old_file))


echo "Filesize Difference ${filesize_difference#-} kb "
filesize_difference=${filesize_difference#-}

if [[ "$filesize_difference" -lt "100"  ]]; then
                echo -e "$database filesize check OK - today:$new_file kb yesterday:$old_file kb";
        else
                echo -e "server :: $SERVER >> db:: $database -- FILE CHECK WARNING - \n yesterday->today \n ${old_file} -> ${new_file} kb \n" 1>&2
        fi




        if  [ $DELETE = "y" ]; then
                find $BACKDIR/*/ -type f -mtime +$DAYS -delete;
                find $BACKDIR -type d -empty -exec rmdir {} \;


        fi
        echo -e "done \n"
fi
done
echo "New backup done"

echo "Backups older than $DAYS days have been deleted."


echo "Your backup is complete!"

