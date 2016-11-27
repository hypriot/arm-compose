FROM resin/rpi-raspbian:wheezy

RUN set -ex; \
    apt-get update -qq; \
    apt-get install -y \
        locales \
        gcc \
        make \
        zlib1g \
        zlib1g-dev \
        libssl-dev \
        git \
        ca-certificates \
        curl \
        libsqlite3-dev \
        apt-transport-https \
        bzip2 \
        python3 \
    ; \
    rm -rf /var/lib/apt/lists/*

RUN set -ex; \
    curl -L https://packagecloud.io/Hypriot/Schatzkiste/packages/debian/wheezy/docker-hypriot_1.8.3-1_armhf.deb/download -o docker-hypriot_1.8.3-1_armhf.deb; \
    dpkg -x docker-hypriot_1.8.3-1_armhf.deb /tmp/docker || true; \
    mv /tmp/docker/usr/bin/docker /usr/local/bin/docker; \
    rm -f docker-hypriot_1.8.3-1_armhf.deb; \
    rm -rf /tmp/docker

# Build Python 2.7.9 from source
RUN set -ex; \
    curl -L https://www.python.org/ftp/python/2.7.9/Python-2.7.9.tgz | tar -xz; \
    cd Python-2.7.9; \
    ./configure --enable-shared; \
    make; \
    make install; \
    cd ..; \
    rm -rf /Python-2.7.9

# Build python 3.4 from source
# RUN set -ex; \
#     curl -L https://www.python.org/ftp/python/3.4.3/Python-3.4.3.tgz | tar -xz; \
#     cd Python-3.4.3; \
#     ./configure --enable-shared; \
#     make; \
#     make install; \
#     cd ..; \
#     rm -rf /Python-3.4.3

# Make libpython findable
ENV LD_LIBRARY_PATH /usr/local/lib

# Install setuptools
RUN set -ex; \
    curl -L https://bootstrap.pypa.io/ez_setup.py | python

# Install pip
RUN set -ex; \
    curl -L https://pypi.python.org/packages/source/p/pip/pip-8.1.1.tar.gz | tar -xz; \
    cd pip-8.1.1; \
    python setup.py install; \
    cd ..; \
    rm -rf pip-8.1.1

# Python3 requires a valid locale
RUN echo "en_US.UTF-8 UTF-8" > /etc/locale.gen && locale-gen
ENV LANG en_US.UTF-8

RUN useradd -d /home/user -m -s /bin/bash user
WORKDIR /code/

RUN pip install tox==2.1.1

ADD requirements.txt /code/
ADD requirements-dev.txt /code/
ADD .pre-commit-config.yaml /code/
ADD setup.py /code/
ADD tox.ini /code/
ADD compose /code/compose/
RUN tox --notest

RUN set -ex; \
    cd /tmp; \
    curl -L https://github.com/pyinstaller/pyinstaller/releases/download/3.0/PyInstaller-3.0.tar.gz | tar -xz; \
    cd PyInstaller-3.0/bootloader; \
    curl -LO https://raw.githubusercontent.com/matysek/pyinstaller/6d65e7cea428ac207a27297c8adc169c17ee5776/bootloader/wscript; \
    python ./waf distclean --no-lsb all; \
    ln -s /tmp/PyInstaller-3.0 /code/.tox/py27/lib/python2.7/site-packages/PyInstaller; \
    sed -i '/    if is_unix:/i\ \ \ \ return 0' /code/.tox/py27/lib/python2.7/site-packages/PyInstaller/PyInstaller/utils/misc.py

ADD . /code/
RUN chown -R user /code/

ENV VENV /code/.tox/py27
RUN mkdir -p dist
RUN chmod 777 dist
RUN $VENV/bin/pip install -q -r requirements-build.txt
RUN ./script/build/write-git-sha
RUN su -c "source $VENV\/bin\/activate && $VENV\/lib\/python2.7\/site-packages\/PyInstaller\/pyinstaller.py docker-compose.spec" user
RUN ls -l dist
