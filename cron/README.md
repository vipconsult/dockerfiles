# OVERVIEW


We don't mount the docker executable , but only the docker.sock file.
 The image installs the latest docker-engine to be used as a client through the docker.sock socket.
the image creation always installs the latest docker-engine version to be used as client so normally when the host's docker-engine server is older version it might show an error about API mismatch. 
The good news is that docker has this nice env variable DOCKER_API_VERSION which allows newer clients to talk to older servers.




we use supervisor as the cron requires rsyslog so we need to run rsyslog prior the cron daemon so that is uses the rsyslog to send the logs to /var/log/syslog




# MANUAL RUN
	docker run -d \
		--name=cronContainer \
		-e DOCKER_API_VERSION=1.23 \
		-e SMTP_SERVER=smtpContainer \
		-e MAILTO=email@domain.com \
		-e CRONTASK_1="* * * * *  root docker exec phpContainer php /home/cron.php" \
		vipconsult/cron
	docker run -d \
		--name=smtpContainer \
		--hostname=domain.com \
		-e DOMAINNAME=domain.com \
		-e SMTP_INTERVAL=1m \
		-e SMTP_PROCESSING=queue_only_load_latch \
		-e SMTP_remote_max_parallel=2 \
		-e SMTP_queue_run_max=3 \
		-e SMTP_timeout_frozen_after=3h \
		vipconsult/smtp

# COMPOSE FILE


	cron:
        	image: vipconsult/cron
        	volumes:  
        	    - /var/run/docker.sock:/var/run/docker.sock:ro
        	environment:
		    - DOCKER_API_VERSION=1.23
		    - SMTP_SERVER=smtpContainer
		    - MAILTO=email@domain.com
		    - CRONTASK_1=0 1 * * *  root docker exec someRunningContainer php /home/http/cron.php
		    - CRONTASK_2=0 2 * * * 	root docker run someImage bash -c "command1 & command2"
		container_name:cronContainer

	smtp:
        	image: vipconsult/smtp
		container_name:smtpContainer
		
# CRON EMAILS
	if you don't need emails for the output from the cron jobs than you don't need the smtpContainer and the MAILTO env
	# the DOMAINNAME env needs to be set for the smtp container as otherwise all server reject mails form non FQDN
# LOGS
	docker logs cronContainer
