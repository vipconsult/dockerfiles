# Running the container

sudo docker run \
	-v /home/freeswitch/sounds:/usr/local/freeswitch/sounds \
	-v /home/freeswitch/conf:/usr/local/freeswitch/conf \
	--net=host \
	vipconsult/freeswitch /bin/bash

#Notes
Freeswitch uses many ports so the option --net=host is preferable than messing with each port it may require.

preferable you should have a dedicated ip for freeswitch to avoid port collision with other containers.

The run example above loads the config and the sound files from the host by using a shared dirs.
The sound files are quite big so if you put this in the image then it will make the container very big.