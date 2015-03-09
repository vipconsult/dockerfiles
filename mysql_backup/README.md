# Usage
sudo docker run --rm <br/>
--link conainer_name_that_runs_the_mysql_server:conainer_name_that_runs_the_mysql_server <br/>
-v /path_to_file_for_passwordless_login/.my.cnf:/root/.my.cnf <br/>
-v /backup/destination -e backup_dir=/backup/destination <br/>
-e backup_server=conainer_name_that_runs_the_mysql_server <br/>
-e backup_host=server_name  vipconsult/mysql_backup <br/>