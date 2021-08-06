if [ "$LEVEL" == "DEBUG" ]; then
	echo "Level is DEBUG. Press enter when paused"
else
	echo "Level is NOT DEBUG. There will be no wait"	
fi
cd ../

# We are creating shell script for deployment of this city_api project 
echo 'Reset Docker to prevent connection error'
unset DOCKER_HOST
unset DOCKER_TLS_VERIFY
unset DOCKER_TLS_PATH
echo "First we need to do the docker login"
docker login
docker ps

# Now we want to build docker image from BuildImageUploadLogicDocker.sh file.
# So that we have to go to that directory. 
echo "Building ImageUpload-logic component in no hup mode"
cd ImageUpload-logic
# TODO move it to how to run the directories.
sh BuildImageUploadLogicDocker.sh > ../logs/ImageUpload-logic.log

# Again return to root directory
cd ../

CURRENT_DATE=`date +%b-%d-%y_%I_%M_%p`
echo "Starting At "$CURRENT_DATE
echo "Deleting Deployments"
kubectl get deployments

# Before this step you should have already project created in gcloud and also you have enable the api and services in the kubernates engine api


# Before creating new service need to remove old services
echo "Before creating new service we need to remove old services"
kubectl get svc
kubectl delete svc image-upload-pv-pod
kubectl get svc

if [ "$LEVEL" == "DEBUG" ]; then
	echo "Press Enter if ImageUpload-logic is pushed to docker hub."
	read ImageUploadLogicIsPushed
else
	echo 'ImageUpload-logic pushed.'	
fi


# Appling deployment yaml file
echo "deployment."
kubectl apply -f resource-manifests/ImageUploadDeployment.yaml --record
kubectl get deployments
kubectl get pods

# Appling logic yaml file
echo "ImageUpload-logic service."
kubectl apply -f resource-manifests/Image-Upload-logic.yaml
kubectl get services
kubectl get pods
kubectl get service image-upload-pv-pod

# Here we set the while loop it will sleep after 5 times it is executing. 
echo "ImageUpload service."
ImageUploadIp=""
ImageUploadPort=""
while [ -z $ImageUploadIp ]; do
    sleep 5
    kubectl get svc
    ImageUploadIp=`kubectl get service image-upload-pv-pod --output=jsonpath='{.status.loadBalancer.ingress[0].ip}'`
	ImageUploadPort=`kubectl get service image-upload-pv-pod --output=jsonpath='{.spec.ports[0].port}'`
done

# Now we will get our image upload IP & PORT.
echo "launch "$ImageUploadIp":"$ImageUploadPort


trap : 0

 echo >&2 '
************
*** DONE gCloudDeployment-IU.sh ***
************'