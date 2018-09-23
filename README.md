# Eve-docker
Add docker to community version of eve community version 2.0.3-86.
uninstall docker-enginer, docker.io.
Install Docker-CE.

Create /etc/systemd/system/docker.service.d/override.conf with the contents below:
[Service]
ExecStart=
ExecStart=/usr/bin/dockerd -H unix://var/run/docker.sock -H tcp://127.0.0.1:4243

This should enable doscker commands to be visible on the console rather than returning nothing at all. 

Applications in containers can be downloaded from the Hub and then be used in eve itself. 

Instructions are draft as I ran out of time. I will try a default install and add where required on how to get this running if there are problems. 

These are the changed files to make docker fnction. IP Addresses of the interfaces are set by using nsenter on the container. If you do not assign an IP address then when you start a container the container will never enter run mode. The icon on the container will stay as a clock face. The only way to recover from this is to wipe the node, configure the IP address and then start. 

The container IP address must be part of the startup configuration. Check the eve-ng pro cookbook on the correct format.

The docker options box on the template should typically be used to set environmental variables rather than the ip address. I found a number of containerise network functions that required environmental variables to be presented. so use '-e ENVIRONMENTAL_VARIABLE' and it gets passed into the create command. 

Copy files to /opt/unetlab/ and the appropriate directory.
