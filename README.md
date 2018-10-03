# roulette-linux
Continuous suicide Linux, updated with a web page.

## About
Inspired by suicide-linux ([here](https://qntm.org/suicide) and [here](https://github.com/tiagoad/suicide-linux)), this is a
container of the same principle that will continually try to destroy itself while telling you how much it has tried. This was thought up and developed over on SpotChat (irc.spotchat.org) with IRC operator r00t.

## How do I run it?
You'll need to build the docker image from the Dockerfile first. The setup requires you give roulette-linux a mounted directory (which will be mounted at /tmp/rl) to keep track of times the system has wiped. You'll need to edit the commands below to reflect the proper path to that file on the host system. Then, you can get roulette-linux up and running with a basic docker setup by issuing the following:

```
docker run --rm -d \
--name roulette-linux \
-p 80:80 \
-v /path/to/directory:/tmp/rl \
-t roulette-linux
```

For a more complex setup, like nginx-proxy, you'll need to expose port 80 instead of binding it to host's port 80 and specify some environment arguments like so:

```
docker run --rm -d \
--name roulette-linux \
--expose=80 \
-v /path/to/directory:/tmp/rl \
-e "VIRTUAL_HOST=example.net" \
-e "HTTPS_METHOD=nohttps" \
-t roulette-linux
```

## How it works
Once the container starts, a cronjob will run `roulette.sh` which contains an array of commands (currently, it has 13 correct commands and one incorrect command) to issue every minute. In the future this interval will be user configurable more easily. After every successful command it will increment a tally and build a webpage to serve about how long it has been up and how many successful commands it has run.

## Regeneration
Currently, regeneration of the container on death is done via a host cronjob. It's very sloppy, but the code is here. My code assumes you're using nginx-proxy (on net `proxy-net`), letsencrypt-companion, and exposing port 80 to a random host port with your docker setup, so feel free to edit it to fit your setup.

``` bash
#!/bin/bash                                                                                                                                                  

# This checks if the roulette-linux container is currently running. If not,
# it will create it given the below arguments.

# Let's set some stuff up, like arguments for docker.
containerName='roulette-linux'
containerArgs='--expose=80 -v /path/to/directory:/tmp/rl --net proxy-net -e VIRTUAL_HOST=example.net -e HTTPS_METHOD=nohttps'

# Check `docker ps` for roulette-linux.
check="$(docker ps | grep 'roulette-linux')"

# Check if the container is there. Create it if not.
if [ -z "$check" ]; then
        echo ">> Container dead. Recreating"
        docker run -d --rm --name $containerName $containerArgs roulette-linux
else
        :
fi
```
