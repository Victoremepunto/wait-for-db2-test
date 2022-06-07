# POC Test for measuring DB2 startup time locally

## How to run:

You'll need either `docker` or `podman`, just run `wait_for_db2.sh` script, 
it will create a DB2 container and will output the number of seconds it took to report as "ready".

According to [DB2 Docker Image quick start](https://hub.docker.com/r/ibmcom/db2) guide, the logs
should display a **Setup has completed** message when the server is ready.
