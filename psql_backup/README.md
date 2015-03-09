# Usage
sudo docker run --rm <br/>
--link conainer_name_that_runs_the_psql_server:conainer_name_that_runs_the_psql_server <br/>
-v /backup/destination:/backup/destination <br/>
-e backup_dir=/backup/destination <br/>
-e backup_container=conainer_name_that_runs_the_mysql_server <br/>
-e backup_host=server_name  vipconsult/mysql_backup <br/>