# ImageUpload and CrackDetection webapp with NFS-server on GKE - ReadWriteMany(RWX)

=:> In this task we will use Common cluster and common PV-PVC for both(IU & CD) webapp.
 
## Create GKE cluster and Persistent Disk in Google Compute Engine

To create these things run the createCluster-PD.sh shell file

```
sh createCluster-PD.sh
```

Now your cluster and PD is ready for opration, you can create the nfs-server. 

## Create NFS Server in GKE

Now the disk is created, let’s create the NFS server.

```
kubectl apply -f 001-nfs-server.yaml
```

## Create NFS Service

The compute disk and nfs-server is ready, let's create nfs-service

```
kubectl apply -f 002-nfs-server-service.yaml
```

Also check the service is created perfectly or not.

```
kubectl get svc nfs-server
```

## Create Persistent Volume and Persistent Volume Claim

#### Note : Note down the *clusterIP* from the nfs-service as it will be required for the next part.

Now we create a persistent volume and a persistent volume claim in kubernetes.

```
kubectl apply -f 003-pv-pvc.yaml
```

#### Note : Notice here that storage is 10Gi on both PV and PVC. It’s 10Gi on PV because the Compute Engine persistent disk we created was of the size 10Gi.You can have any storage value for PVC as long as you don’t exceed the storage value defined in PV.

## Run ImageUpload App

To run the image-upload app we need to run the 1 command only
but first go to the ImageUploadApp/GKE then use this command,

```
sh gCloudDeployment-IU.sh
```

Now wait for completing the running process and you will get at last port with ip address, copy that and paste in browser, you will get your interface of your webapp in browser.

## Run CrackDetection App

Same as image-upload, first got to perticular directory - /CrackDetectionApp/GKE.

```
sh gCloudDeployment-CD.sh
```

Now same as image-upload webapp wait for completing the running process and you will get at last port with ip address, copy that and paste in browser, you will get your interface of your webapp in browser.

##### You can see there is both webapp running on single cluster and single PV-PVC.

Now you can login to the both Deployment(pod) and check wheather your stored data as is or not which is in nfs-server deployment pod.
For all the pod if data is there same as same which means you have now multiple pod with shared data.
To login the pod use the command

```
kubectl exec -it << pod-name >> -- /bin/bash
```


Thank you... :)