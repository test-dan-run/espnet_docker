FROM pytorch/pytorch:1.11.0-cuda11.3-cudnn8-runtime

ENV TZ=Asia/Singapore
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

RUN apt-get update && apt-get install -y \
    cmake wget git \
    libsndfile1-dev sox ffmpeg flac \
    && rm -rf /var/lib/apt/lists/* \
    && apt-get clean

# Keeps Python from generating .pyc files in the container
ENV PYTHONDONTWRITEBYTECODE 1

# Turns off buffering for easier container logging
ENV PYTHONUNBUFFERED 1

# clone ESPnet repo
RUN git clone https://github.com/espnet/espnet
RUN python3 -m pip install --upgrade pip && python3 -m pip install --no-cache-dir wheel Cython clearml boto3

# install ESPnet
RUN cd espnet/tools && ./setup_python.sh $(command -v python3)
RUN cd espnet/tools && make TH_VERSION=1.10.0 CUDA_VERSION=11.3

RUN ["bash"]
