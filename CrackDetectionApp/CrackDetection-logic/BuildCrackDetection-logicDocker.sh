#!/bin/sh
abort()
{
    echo >&2 '
***************
*** ABORTED BuildCrackDetectionLogicDocker ***
***************
'
    echo "An error occurred BuildCrackDetectionLogicDocker . Exiting..." >&2
    exit 1
}

trap 'abort' 0

set -e
# TODO make this as bash variable.
# TODO Make this on every file ?
LEVEL=NONDEBUG
if [ "$LEVEL" == "DEBUG" ]; then
	echo "Level is DEBUG.Press Enter to continue."
	read levelIsDebug	
else
	echo "Level is NOT DEBUG. There will be no wait."	
fi
#InstallCrackDetectionLogicLocally.sh
#Kill the process
unset DOCKER_HOST
unset DOCKER_TLS_VERIFY
unset DOCKER_TLS_PATH
echo "Trying to login. If you are NOT logged in, there will be a prompt"
docker login

# It will print the log folder wise
echo "Building crack-detection-logic"
docker build -f Dockerfile -t piyush9090/crack-detection-logic .
# Now image building is done 
# So now we will push that image to dockerhub
echo "Pushing crack-detection-logic"
docker push piyush9090/crack-detection-logic
# Here we run the container with that port 8080:8080
echo "Running crack-detection-logic"
docker run -d -p 5050:5050 piyush9090/crack-detection-logic &
sleep 5
echo "List of containers running now"
docker container ls -a

CrackDetectionLogicId="$(docker container ls -f ancestor="piyush9090/crack-detection-logic" -f status=running -aq)"
echo " The one we just started is : $CrackDetectionLogicId"

if [ -n "$CrackDetectionLogicId" ]; then
  echo "crack-detection container is running $(docker container ls -f ancestor=piyush9090/crack-detection-logic -f status=running -aq) :) "
else
  echo "ERROR: crack-detection is NOT running. :(  . Please Check logs/CrackDetection-logic.log"
  exit 1
fi

trap : 0

echo >&2 '
************
*** DONE BuildCrackDetectionLogicDocker ***
************'