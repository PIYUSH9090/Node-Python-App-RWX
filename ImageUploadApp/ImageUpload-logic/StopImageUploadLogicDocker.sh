#StopImageUploadLogicDocker.sh
echo "List of containers running now"
docker container ls -a
echo "image-upload-logic container info"
docker container ls -f ancestor=piyush9090/image-upload-logic
echo "Stopping image-upload-logic container"
docker container stop $(docker container ls -f ancestor=piyush9090/image-upload-logic -aq)
# Once all containers are stopped you can remove them using the 
# docker container stop command followed by the containers ID list.
echo "Removing image-upload-logic container"
docker container rm $(docker container ls -f ancestor=piyush9090/image-upload-logic -aq)
echo "List of containers running now"
docker container ls -a