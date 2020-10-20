FROM nvidia/cuda:10.0-cudnn7-devel

ENV DEBIAN_FRONTEND=noninteractive


# python installation
ENV PYTHON_VERSION 3.7.9
ENV HOME /root
ENV PYTHON_ROOT $HOME/local/python-$PYTHON_VERSION
ENV PATH $PYTHON_ROOT/bin:$PATH
ENV PYENV_ROOT $HOME/.pyenv
RUN apt-get update && apt-get upgrade -y \
 && apt-get install -y \
    gdebi \
    nano \
    git \
    make \
    build-essential \
    libssl-dev \
    zlib1g-dev \
    libbz2-dev \
    libreadline-dev \
    libsqlite3-dev \
    wget \
    unzip \
    curl \
    llvm \
    libncurses5-dev \
    libncursesw5-dev \
    xz-utils \
    tk-dev \
    libffi-dev \
    liblzma-dev \
 && git clone https://github.com/pyenv/pyenv.git $PYENV_ROOT \
 && $PYENV_ROOT/plugins/python-build/install.sh \
 && /usr/local/bin/python-build -v $PYTHON_VERSION $PYTHON_ROOT \
 && rm -rf $PYENV_ROOT



# tensorflow and object detection api installation
RUN apt-get install -y protobuf-compiler python-pil python-lxml python-tk python3-pip
RUN python -m pip install --upgrade pip setuptools && pip3 install tensorflow-gpu==1.15 scipy tf_slim opencv-python
# RUN pip3 install tensorflow-gpu==2.2.0
RUN mkdir /protoc_3.3 && \
    cd protoc_3.3 && \
    wget https://github.com/google/protobuf/releases/download/v3.3.0/protoc-3.3.0-linux-x86_64.zip && \
    chmod 775 protoc-3.3.0-linux-x86_64.zip && \
    unzip protoc-3.3.0-linux-x86_64.zip

RUN pip3 install Cython contextlib2 pillow lxml matplotlib pandas numpy

RUN git clone https://github.com/tensorflow/models.git
Run git clone https://github.com/Danny-Dasilva/TensorFlow_Object_Detection_Pipeline.git

RUN git clone https://github.com/cocodataset/cocoapi.git && \
    cd cocoapi/PythonAPI && \
    make && \
    cp -r pycocotools /models/research/

RUN cd /models/research && \
    /protoc_3.3/bin/protoc object_detection/protos/*.proto --python_out=. 

ENV PYTHONPATH $PYTHONPATH:/models/research:/models/research/slim
#important
# CMD export PYTHONPATH=$PYTHONPATH:`pwd`:`pwd`/slim

Run mkdir models/research/object_detection/training
Run cp TensorFlow_Object_Detection_Pipeline/setup/pipeline.config models/research/object_detection/training
Run cp TensorFlow_Object_Detection_Pipeline/setup/generate_labelmap.py models/research/object_detection

Run cp TensorFlow_Object_Detection_Pipeline/setup/generate_tfrecord.py models/research/object_detection/
Run cp TensorFlow_Object_Detection_Pipeline/setup/xml_to_csv.py models/research/object_detection/


Run cp TensorFlow_Object_Detection_Pipeline/setup/export_tflite_ssd_graph.py models/research/object_detection/
Run cp TensorFlow_Object_Detection_Pipeline/setup/constants.sh models/research/object_detection/

Run cp -r TensorFlow_Object_Detection_Pipeline/setup/ssd_mobilenet_v2_quantized_300x300 models/research/object_detection/


Run rm -rf models/research/pycocotools/cocoeval.py
Run rm -rf models/research/object_detection/metrics/coco_tools.py
Run cp TensorFlow_Object_Detection_Pipeline/setup/coco_tools.py models/research/object_detection/metrics/
Run cp TensorFlow_Object_Detection_Pipeline/setup/cocoeval.py models/research/pycocotools/

# COPY utils/create_tf_record.py /models/research/object_detection/dataset_tools/ 
# COPY utils/shell_script /models/reserach/.
ARG work_dir=/models/research/object_detection

# edge tpu compiler installation

RUN curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add -
RUN echo "deb https://packages.cloud.google.com/apt coral-edgetpu-stable main" | tee /etc/apt/sources.list.d/coral-edgetpu.list
RUN apt-get update
RUN apt-get install -y edgetpu-compiler

WORKDIR ${work_dir}


