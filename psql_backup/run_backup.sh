#! /bin/bash

# username to connect to database as.
USERNAME=root


# your Psql server's location
PSQL_SERVER=${backup_container:="localhost"}

# This dir will be created if it doesn't exist.  This must be writable by the user the script is
# running as.
BACKDIR=${backup_dir:="/home/psql_backup/"}
FINAL_BACKDIR=$BACKDIR"/`date +\%Y-\%m-\%d`/"
# set to 'y' if you'd like to be emailed the backup (requires mutt)

HOST=${backup_host:=`hostname`}

DATE=`date +'%d-%m-%Y'`


# List of strings to match against in database name, separated by space or comma, for which we only
# wish to keep a backup of the schema, not the data. Any database names which contain any of these
# values will be considered candidates. (e.g. "system_log" will match "dev_system_log_2010-01")
SCHEMA_ONLY_LIST=""

# Will produce a custom-format backup if set to "yes"
ENABLE_CUSTOM_BACKUPS=yes

# Will produce a gzipped plain-format backup if set to "yes"
ENABLE_PLAIN_BACKUPS=yes


#### SETTINGS FOR ROTATED BACKUPS ####

# Which day to take the weekly backup from (1-7 = Monday-Sunday)
DAY_OF_WEEK_TO_KEEP=1

# Number of days to keep daily backups
DAYS_TO_KEEP=60

# How many weeks to keep weekly backups
WEEKS_TO_KEEP=5





###########################
#### START THE BACKUPS ####
###########################

function perform_backups()
{
        echo -e "<<<<< Backing up PSQL server $PSQL_SERVER on host $HOST >>>>>>>\n\n "
        echo "Making backup directory in $FINAL_BACKDIR"

        if ! mkdir -p $FINAL_BACKDIR; then
                echo "Cannot create backup directory in $FINAL_BACKDIR. Go and fix it!" 1>&2
                exit 1;
        fi;
        ###########################
        ### SCHEMA-ONLY BACKUPS ###
        ###########################

        for SCHEMA_ONLY_DB in ${SCHEMA_ONLY_LIST//,/ }
        do
                SCHEMA_ONLY_CLAUSE="$SCHEMA_ONLY_CLAUSE or datname ~ '$SCHEMA_ONLY_DB'"
        done

        SCHEMA_ONLY_QUERY="select datname from pg_database where false $SCHEMA_ONLY_CLAUSE order by datname;"

        echo -e "\n\nPerforming schema-only backups"
        echo -e "--------------------------------------------\n"

        SCHEMA_ONLY_DB_LIST=$(psql -h $PSQL_SERVER -U $USERNAME -At -w -c "$SCHEMA_ONLY_QUERY" postgres)
        if [[ $? -ne 0 ]]; then
                echo -e "\n\n\n ERROR: pSQL backup on  $HOST failed! \n  Cannot Connect to the psql server  \n" 1>&2
                exit;
        else
                echo -e "Connected to the server OK \n"
        fi


        echo -e "The following databases were matched for schema-only backup:\n${SCHEMA_ONLY_DB_LIST}\n"

        for DATABASE in $SCHEMA_ONLY_DB_LIST
        do
                echo "Schema-only backup of $DATABASE"

                if ! pg_dump -Fp -w -s -h $PSQL_SERVER -U "$USERNAME" "$DATABASE" | gzip > $FINAL_BACKDIR"$DATABASE"_SCHEMA.sql.gz.in_progress; then
                        echo "[!!ERROR!!] Failed to backup database schema of $DATABASE" |tee -a ${DAILYLOGFILE} | tee -a  ${DAILYLOGFILE}
                else
                        mv $FINAL_BACKDIR"$DATABASE"_SCHEMA.sql.gz.in_progress $FINAL_BACKDIR"$DATABASE"_SCHEMA.sql.gz
                fi
        done


        ###########################
        ###### FULL BACKUPS #######
        ###########################

        for SCHEMA_ONLY_DB in ${SCHEMA_ONLY_LIST//,/ }
        do
                EXCLUDE_SCHEMA_ONLY_CLAUSE="$EXCLUDE_SCHEMA_ONLY_CLAUSE and datname !~ '$SCHEMA_ONLY_DB'"
        done

        FULL_BACKUP_QUERY="select datname from pg_database where not datistemplate and datallowconn $EXCLUDE_SCHEMA_ONLY_CLAUSE order by datname;"

        echo -e "\n\nPerforming full backups"
        echo -e "--------------------------------------------\n"

        DBS=$(psql -h $PSQL_SERVER  -U "$USERNAME" -At -w -c "$FULL_BACKUP_QUERY" postgres)

        if [[ $? -ne 0 ]]; then
                echo -e "\n\n\n  ERROR: pSQL backup on  $HOST failed!  ::: Cannot Connect to the psql server  \n" 1>&2
                exit;
        else
                echo -e "Connected to the server OK \n"
        fi



        for DATABASE in $DBS
        do
                if [ $ENABLE_PLAIN_BACKUPS = "yes" ]
                then
                        echo "Plain backup of $DATABASE"

                        if ! pg_dump -Fp -w -h $PSQL_SERVER  -U "$USERNAME" "$DATABASE" | gzip > $FINAL_BACKDIR"$DATABASE".sql.gz.in_progress; then
                                echo -e "\n\n [!!ERROR!!] Failed to produce plain backup database $DATABASE" 1>&2
                        else
                                mv $FINAL_BACKDIR"$DATABASE".sql.gz.in_progress $FINAL_BACKDIR"$DATABASE".sql.gz
                        fi
                fi

                if [ $ENABLE_CUSTOM_BACKUPS = "yes" ]
                then
                        echo "Custom backup of $DATABASE"

                        if ! pg_dump -Fc -w -h $PSQL_SERVER -U "$USERNAME" "$DATABASE" -f $FINAL_BACKDIR"$DATABASE".custom.in_progress; then
                                echo -e "\n\n\n [!!ERROR!!] Failed to produce custom backup database $DATABASE" 1>&2
                        else
                                mv $FINAL_BACKDIR"$DATABASE".custom.in_progress $FINAL_BACKDIR"$DATABASE".custom
                        fi
                fi

        done

        echo -e "\nAll database backups complete!"
}

# DELETE MONTHLY BACKUPS

DAY_OF_MONTH=`date +%d`

if [ $DAY_OF_MONTH = "1" ];
then
        # Delete all expired monthly directories
        find $BACKDIR -maxdepth 1 -name "*-monthly" -exec rm -rf '{}' ';'

        perform_backups "-monthly"

        exit 0;
fi

# DELETE WEEKLY BACKUPS

DAY_OF_WEEK=`date +%u` #1-7 (Monday-Sunday)
EXPIRED_DAYS=`expr $((($WEEKS_TO_KEEP * 7) + 1))`

if [ $DAY_OF_WEEK = $DAY_OF_WEEK_TO_KEEP ];then
        # Delete all expired weekly directories
        find $BACKDIR -maxdepth 1 -mtime +$EXPIRED_DAYS -name "*-weekly" -exec rm -rf '{}' ';'

        perform_backups "-weekly"

        exit 0;
fi


# Delete daily backups 7 days old or more
find $BACKDIR -maxdepth 1 -mtime +$DAYS_TO_KEEP -name "*-daily" -exec rm -rf '{}' ';'

perform_backups "-daily"


echo "Your Psql backup is complete!"
