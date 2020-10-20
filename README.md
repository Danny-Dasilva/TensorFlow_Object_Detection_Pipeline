# TensorFlow_2_Object_Detection
tensorflow2 object detection training pipeline





build docker container

`sudo docker build ./ -t obj_detect`



export path 

`DETECT_DIR=$PWD`

run docker container


```
docker run -ti --name edgetpu-detect \
--rm -it --privileged -p 6006:6006 \
-e DISPLAY=$DISPLAY \
-v /tmp/.X11-unix:/tmp/.X11-unix \
--mount type=bind,src=${DETECT_DIR},dst=/models/research/object_detection/images \
--gpus all \
obj_detect
```




tensorboard

`sudo docker exec -it edgetpu-detect /bin/bash`

`tensorboard --logdir=training`

Usefull scripts

give docker gui permissions
`xhost +local:docker`

clear docker memory

`docker system prune -a`
