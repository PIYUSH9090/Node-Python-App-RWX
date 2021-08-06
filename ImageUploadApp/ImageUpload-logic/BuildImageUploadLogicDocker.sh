#!/bin/sh
abort()
{
    echo >&2 '
***************
*** ABORTED BuildImageUploadLogicDocker ***
***************
'
    echo "An error occurred BuildImageUploadLogicDocker . Exiting..." >&2
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
#InstallImageUploadLogicLocally.sh
#Kill the process
unset DOCKER_HOST
unset DOCKER_TLS_VERIFY
unset DOCKER_TLS_PATH
echo "Trying to login. If you are NOT logged in, there will be a prompt"
docker login

# It will print the log folder wise
echo "Building image-upload-logic"
docker build -f Dockerfile -t piyush9090/image-upload-logic .
# Now image building is done 
# So now we will push that image to dockerhub
echo "Pushing image-upload-logic"
docker push piyush9090/image-upload-logic
# Here we run the container with that port 5050:3000
echo "Running image-upload-logic"
# Do not run when building it takes a port away
# docker run -d -p 3000:3000 piyush9090/image-upload-logic &
sleep 5
echo "List of containers running now"
docker container ls -a

ImageUploadLogicId="$(docker container ls -f ancestor="piyush9090/image-upload-logic" -f status=running -aq)"
echo " The one we just started is : $ImageUploadLogicId"

if [ -n "$ImageUploadLogicId" ]; then
  echo "image-upload container is running $(docker container ls -f ancestor=piyush9090/image-upload-logic -f status=running -aq) :) "
else
  echo "ERROR: image-upload is NOT running. :(  . Please Check logs/ImageUpload-logic.log"
  exit 1
fi

trap : 0

echo >&2 '
************
*** DONE BuildImageUploadLogicDocker ***
************'