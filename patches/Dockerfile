FROM resin/rpi-raspbian:wheezy

RUN set -ex; \
    apt-get update -qq; \
    apt-get install -y \
        gcc \
        make \
        zlib1g \
        zlib1g-dev \
        libssl-dev \
        git \
        apt-transport-https \
        ca-certificates \
        curl \
        lxc \
        iptables \
    ; \
    rm -rf /var/lib/apt/lists/*

# Build Python 2.7.9 from source
RUN set -ex; \
    curl -LO https://www.python.org/ftp/python/2.7.9/Python-2.7.9.tgz; \
    tar -xzf Python-2.7.9.tgz; \
    cd Python-2.7.9; \
    ./configure --enable-shared; \
    make; \
    make install; \
    cd ..; \
    rm -rf /Python-2.7.9; \
    rm Python-2.7.9.tgz

# Make libpython findable
ENV LD_LIBRARY_PATH /usr/local/lib

# Install setuptools
RUN set -ex; \
    curl -LO https://bootstrap.pypa.io/ez_setup.py; \
    python ez_setup.py; \
    rm ez_setup.py

# Install pip
RUN set -ex; \
    curl -LO https://pypi.python.org/packages/source/p/pip/pip-7.0.1.tar.gz; \
    tar -xzf pip-7.0.1.tar.gz; \
    cd pip-7.0.1; \
    python setup.py install; \
    cd ..; \
    rm -rf pip-7.0.1; \
    rm pip-7.0.1.tar.gz

ENV ALL_DOCKER_VERSIONS 1.7.1

RUN set -ex; \
    curl -L http://downloads.hypriot.com/docker-hypriot_1.7.1-1_armhf.deb -o docker-hypriot_1.7.1-1_armhf.deb; \
    dpkg -x docker-hypriot_1.7.1-1_armhf.deb /tmp/docker || true; \
    mv /tmp/docker/usr/bin/docker /usr/local/bin/docker-1.7.1; \
    rm -f docker-hypriot_1.7.1-1_armhf.deb; \
    rm -rf /tmp/docker

# Set the default Docker to be run
RUN ln -s /usr/local/bin/docker-1.7.1 /usr/local/bin/docker

RUN useradd -d /home/user -m -s /bin/bash user
WORKDIR /code/

ADD requirements.txt /code/
RUN pip install -r requirements.txt

ADD requirements-dev.txt /code/
RUN pip install -r requirements-dev.txt

ADD . /code/
RUN python setup.py install

RUN apt-get update -qq && \
    apt-get install -qy wget bzip2 && \
    cd /tmp && \
    wget -q https://pypi.python.org/packages/source/P/PyInstaller/PyInstaller-2.1.tar.gz && \
    tar xzf PyInstaller-2.1.tar.gz && \
    cd PyInstaller-2.1/bootloader && \
    python ./waf configure --no-lsb build install && \
    ln -s /tmp/PyInstaller-2.1/PyInstaller/bootloader/Linux-32bit-arm /usr/local/lib/python2.7/site-packages/PyInstaller/bootloader/Linux-32bit-arm

# Patch pyinstaller to run as root inside the container
RUN sed -i '/    if is_unix:/i\ \ \ \ return 0' /usr/local/lib/python2.7/site-packages/PyInstaller/utils/misc.py

ENTRYPOINT ["/usr/local/bin/docker-compose"]
