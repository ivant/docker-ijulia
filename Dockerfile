FROM phusion/baseimage:0.9.16
MAINTAINER Ivan Tarasov "Ivan.Tarasov@gmail.com"

RUN add-apt-repository ppa:staticfloat/julianightlies && \
    add-apt-repository ppa:staticfloat/julia-deps && \
    apt-get update && \
    apt-get install -y -q --no-install-recommends --no-install-suggests \
      apt-utils \
      build-essential \
      file \
      gettext \
      gcc \
      g++ \
      gfortran \
      glpk-utils \
      graphicsmagick \
      hdf5-tools \
      julia \
      libc6-dev \
      libffi-dev \
      libglib2.0-dev \
      libgnutls28-dev \
      libmagickwand-dev \
      libncurses-dev \
      libnlopt-dev \
      libopenmpi-dev \
      libpcre3-dev \
      libpng12-dev \
      libreadline-dev \
      libssl-dev \
      libsundials-serial-dev \
      libzmq-dev \
      msgpack-python \
      openmpi-bin \
      pandoc \
      pdf2svg \
      pkg-config \
      python \
      python-crypto \
      python-dev \
      python-distribute \
      python-isodate \
      python-jinja2 \
      python-m2crypto \
      python-matplotlib \
      python-numpy \
      python-pip \
      python-requests \
      python-scipy \
      python-setuptools \
      python-software-properties \
      python-sympy \
      python-yaml \
      python-zmq \
      wget

RUN pip install --upgrade notebook ipywidgets
                   
# Ipopt
RUN mkdir ipopt; cd ipopt; wget  http://www.coin-or.org/download/source/Ipopt/Ipopt-3.12.3.tgz; \
    tar -xzf Ipopt-3.12.3.tgz; cd Ipopt-3.12.3; \
    cd ThirdParty/Blas; ./get.Blas; ./configure --prefix=/usr/local --disable-shared --with-pic; make install; cd ../..; \
    cd ThirdParty/Lapack; ./get.Lapack; ./configure --prefix=/usr/local --disable-shared --with-pic; make install; cd ../..; \
    cd ThirdParty/Mumps; ./get.Mumps; cd ../..; \
    ./configure --prefix=/usr/local --enable-dependency-linking --with-blas=/usr/local/lib/libcoinblas.a --with-lapack=/usr/local/lib/libcoinlapack.a; \
    make install; \
    echo "/usr/local/lib" > /etc/ld.so.conf.d/ipopt.conf; ldconfig; \
    cd ../..; \
    rm -rf ipopt

# Cbc
RUN mkdir cbc; cd cbc; wget http://www.coin-or.org/download/source/Cbc/Cbc-2.9.5.tgz; \
    tar -xzf Cbc-2.9.5.tgz; cd Cbc-2.9.5; \
    ./configure --prefix=/usr/local --enable-dependency-linking --without-blas --without-lapack --enable-cbc-parallel; \
    make install; \
    echo "/usr/local/lib" > /etc/ld.so.conf.d/cbc.conf; ldconfig; \
    cd ../..; \
    rm -rf cbc

COPY setup_julia_packages.jl /tmp/
RUN julia -L /tmp/setup_julia_packages.jl

# Generate Jupyter Julia config.
RUN jupyter notebook --generate-config
COPY jupyter_julia_config.py /tmp/
RUN cat /tmp/jupyter_julia_config.py >> /root/.jupyter/jupyter_notebook_config.py

# Clean up.
RUN apt-get clean
RUN rm -rf \
      /tmp/* \
      /var/tmp/* \
      /var/lib/apt/lists/*
                    
EXPOSE 8888

RUN mkdir /etc/service/jupyter && \
    echo '#!/bin/sh\nexec /usr/local/bin/jupyter notebook' > /etc/service/jupyter/run && \
    chmod a+x /etc/service/jupyter/run
CMD /sbin/my_init
