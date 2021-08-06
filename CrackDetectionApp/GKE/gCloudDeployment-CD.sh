if [ "$LEVEL" == "DEBUG" ]; then
	echo "Level is DEBUG. Press enter when paused"
else
	echo "Level is NOT DEBUG. There will be no wait"	
fi

# We are creating shell script for deployment of this city_api project 
echo 'Reset Docker to prevent connection error'
unset DOCKER_HOST
unset DOCKER_TLS_VERIFY
unset DOCKER_TLS_PATH
echo "First we need to do the docker login"
docker login
docker ps
cd ../

echo "Building CrackDetection-logic component in no hup mode"
cd CrackDetection-logic
# TODO move it to how to run the directories.
sh BuildCrackDetection-logicDocker.sh > ../logs/CrackDetection-logic.log
cd ../

CURRENT_DATE=`date +%b-%d-%y_%I_%M_%p`
echo "Starting At "$CURRENT_DATE
echo "Deleting Deployments"
kubectl get deployments

# Before this step you should have already project created in gcloud and also you have enable the api and services in the kubernates engine api
echo "Before creating new deployment we need to remove old deployments"
kubectl delete deployment crack-detection-pod
kubectl delete pods

echo "Before creating new service we need to remove old services"
kubectl get services
kubectl delete service crack-detection-service
kubectl get services

if [ "$LEVEL" == "DEBUG" ]; then
	echo "Press Enter if CrackDetection-logic is pushed to docker hub."
	read CrackDetectionLogicIsPushed
else
	echo 'CrackDetection-logic pushed.'	
fi

echo "Crack Detection deployment."
kubectl apply -f resource-manifests/CrackDetectionDeployment.yaml --record
kubectl get deployments
kubectl get pods

echo "CrackDetection-logic service."
kubectl apply -f resource-manifests/CrackDetection-logic.yaml
kubectl get services
kubectl get pods
kubectl get service crack-detection-service

echo 'Check rollout status.'	
# INFO: This is to prevent silent Errors.
kubectl rollout status deployment CrackDetection-logic


echo "crackdetection service."
crackdetectionIp=""
crackdetectionPort=""
while [ -z $crackdetectionIp ]; do
    sleep 5
    kubectl get svc
    crackdetectionIp=`kubectl get service crack-detection-service --output=jsonpath='{.status.loadBalancer.ingress[0].ip}'`
	crackdetectionPort=`kubectl get service crack-detection-service --output=jsonpath='{.spec.ports[0].port}'`
done

echo "launch "$crackdetectionIp":"$crackdetectionPort


trap : 0

 echo >&2 '
************
*** DONE gCloudDeployment-CD.sh ***
************'