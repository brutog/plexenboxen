# plexenboxen
A quick `docker-compose.yaml` and set of scripts to create a media stack 
# Steps
 - Make sure to have a internal static IP for your box - the easiest way being assigning it via mac address on your router or DHCP server
 - Open port 443 to this internal IP in your router's firewall/port forwarding configuration
 - Make sure to install Ubuntu 24.04 for hardware transcoding drivers for the i915 GPU quicksync ability
 - Make sure to mount your storage at /data. This could be anything (nfs/samba/iscsi/USB drive), but it's recommended that it is something that support inotify (nfs and samba do not support inotify). Plex and other software benefit from being able to automatically see file changes on the mount.
	 - A quick google search shows there might be hacks like https://github.com/LightDestory/PlexNFSWatchdog
 - Clone this repo to your home directory on your box
 - `cd plexenboxen`
 - Run `strap.sh`. This will do a few things: 
	 - Install a few common utilities (like git, samba, etc)
	 - Install docker-compose via a repo
	 - Install the docker compose plug so the `docker` command will gain a verb called `compose`
	 - Create all the directories on /data, so have your storage mounted before this step
 - `cp .env.example .env`
	 - Fill out `.env` carefully
 - Run `duck.sh` to update your duckdns A record. Verify `duck.log` says `OK`.
 - Run `gen_key.sh`. This will do a few things:
	- This step requires your `.env` file to exist and be filled out accurately.
	- Create a randomly generated, shared *arr API key amongst the 4 *arrs
	- Also add this as an API key to sabnzbd
	- Drop the *arr API key to a file `.arr_api_key`
	- Create basic auth credentials with the username you ran the script as and a randomly generated PW
	- Drop the cleartext PW into the file `.basic_auth` 
	- Create a hashed version of this basic auth password to protect both your Traefik install and your homepage install
 - Run `docker compose -d up`. This will bring up all containers
 - Log into each of the 4 *arrs at their public addresses (servicename.domain) and configure auth for type "forms" and set a user name and password
 - Log into overseerr and setup authentication
 - Log into plex at the local address as it's the easiest way to claim your server (http://local_ip:32400)
 - Log into flood and create a username and password and configure the socket target for the default.
