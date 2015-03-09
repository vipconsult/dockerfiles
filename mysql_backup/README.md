# Usage
sudo docker run --rm
--link conainer_name_that_runs_the_mysql_server:conainer_name_that_runs_the_mysql_server
-v /path_to_file_for_passwordless_login/.my.cnf:/root/.my.cnf
-v /backup/destination:/backup/destination
-e backup_dir=/backup/destination
-e backup_container=conainer_name_that_runs_the_mysql_server
vipconsult/mysql_backup