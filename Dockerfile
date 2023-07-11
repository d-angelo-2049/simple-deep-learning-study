FROM nvidia/cuda:11.4.3-devel-ubuntu20.04

# set timezone to Asia/Tokyo
ENV TZ=Asia/Tokyo
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

# mamba install
ENV MAMBA_ROOT_PREFIX=/opt/conda
ENV PATH=$MAMBA_ROOT_PREFIX/bin:$PATH

RUN apt update && apt install curl --yes \
    && curl -L https://micromamba.snakepit.net/api/micromamba/linux-64/latest | tar -xj "bin/micromamba" \
    && touch /root/.bashrc \
    && ./bin/micromamba shell init -s bash -p $MAMBA_ROOT_PREFIX  \
    && grep -v '[ -z "\$PS1" ] && return' /root/.bashrc  > $MAMBA_ROOT_PREFIX/bashrc


# Create a new environment
COPY pytorch2-py3_9.yaml .
RUN micromamba create -f pytorch2-py3_9.yaml -p /opt/conda_env
ENV PATH /opt/conda_env/bin:$PATH

# clean packages
RUN micromamba clean --all --yes
# Set the default environment
ENV CONDA_DEFAULT_ENV /opt/conda_env
SHELL ["micromamba", "shell", "-p", "/opt/conda_env", "-s", "/bin/bash", "-c"]

# set the working directory to /simple-deep-learning-study
WORKDIR /simple-deep-learning-study
