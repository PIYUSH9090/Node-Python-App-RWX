#StopImageUploadLogicLocally.sh
echo "Stop ImageUpload Logic Locally"+ `date`
ps ax | grep image-upload | cut -f2 -d" " - | xargs kill -9
ps ax | grep image-upload | cut -f1 -d" " - | xargs kill -9
ps ax | grep image-upload | cut -f2 -d" " - | xargs kill -9
ps ax | grep image-upload | cut -f1 -d" " - | xargs kill -9
ps ax | grep image-upload