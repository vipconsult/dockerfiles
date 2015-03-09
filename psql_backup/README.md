# Usage
sudo docker run --rm
--link conainer_name_that_runs_the_psql_server:conainer_name_that_runs_the_psql_server
-v /backup/destination:/backup/destination
-e backup_dir=/backup/destination
-e backup_container=conainer_name_that_runs_the_mysql_server
vipconsult/mysql_backup