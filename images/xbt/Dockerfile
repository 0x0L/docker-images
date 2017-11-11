FROM debian:9

MAINTAINER 0x0L <0x0L@github.com>

ENV LANG=C.UTF-8 LC_ALL=C.UTF-8

RUN apt-get update; apt-get dist-upgrade -y \
 && apt-get install -y \
      ack \
      build-essential bzip2 \
      ca-certificates \
      git graphviz \
      libglib2.0-0 libsm6 libxext6 libxrender1 \
      neovim \
      procps \
      tmux \
      tree \
      unzip \
      wget \
      xclip \
 && apt-get clean; apt-get autoclean

ENV PATH /opt/conda/bin:$PATH

# Matplotlib PyQt5 backend tries to import non existent libs
# See https://github.com/ContinuumIO/anaconda-issues/issues/1806
ENV QT_QPA_PLATFORM offscreen

WORKDIR /tmp

RUN wget --quiet https://repo.continuum.io/miniconda/Miniconda3-latest-Linux-x86_64.sh \
 && bash Miniconda3-latest-Linux-x86_64.sh -b -p /opt/conda \
 && rm Miniconda3-latest-Linux-x86_64.sh

# Add to profile.d for login shells
RUN echo 'export PATH=/opt/conda/bin:$PATH' > /etc/profile.d/conda.sh \
 && conda config --system --set show_channel_urls true \
 && conda config --system --set auto_update_conda false

RUN conda update --all --yes \
 && conda install \
      alembic \
      beautifulsoup4 boto bottleneck \
      cmake cython \
      dask distributed \
      flask \
      hdf4 hdf5 \
      ipyparallel ipywidgets \
      lxml \
      markdown matplotlib mock \
      networkx nltk nodejs nose notebook numba numexpr numpy \
      pandas patsy pep8 protobuf pymc3 pyodbc pytables pytest pywavelets \
      redis \
      scikit-learn scipy seaborn sqlalchemy sqlite statsmodels sympy \
      theano tqdm \
      uvloop \
      xarray xlrd xlsxwriter xlwt \
 && conda install -c conda-forge \
      ipympl \
      jupyterhub jupyterlab \
      netcdf4 \
 && conda clean -ay

RUN export CVXOPT_BLAS_EXTRA_LINK_ARGS="-L/opt/conda/lib;-Wl,-rpath,/opt/conda/lib,--no-as-needed;-lmkl_rt;-lpthread;-lm;-ldl" \
 && export CVXOPT_BLAS_LIB=mkl_rt CVXOPT_LAPACK_LIB=mkl_rt \
 && wget --quiet http://faculty.cse.tamu.edu/davis/SuiteSparse/SuiteSparse-4.5.6.tar.gz \
 && tar -xf SuiteSparse-4.5.6.tar.gz \
 && export CVXOPT_SUITESPARSE_SRC_DIR=/tmp/SuiteSparse \
 && pip install --no-cache-dir cvxopt --no-binary cvxopt \
 && rm -fr /tmp/*

RUN git clone --recursive https://github.com/dmlc/xgboost \
 && cd xgboost; make -j4; make pypack; cd .. \
 && pip install --no-cache-dir ./xgboost/python-package \
 && rm -fr /tmp/*

RUN pip install --no-cache-dir --no-binary :all: lightgbm

# On import tensorflow 1.4 produces a warning
# See https://github.com/tensorflow/tensorflow/issues/14182
#
# Tensorboard pip package downgrades bleach from 2.0 to 1.5
# (and html5lib accordingly). As only nbconvert depends on this,
# it should not be too much of an issue.
# See https://github.com/tensorflow/tensorboard/issues/607
RUN pip install --no-cache-dir \
      https://storage.googleapis.com/tensorflow/linux/cpu/tensorflow-1.4.0-cp36-cp36m-linux_x86_64.whl

RUN pip install --no-cache-dir \
      arch \
      catboost \
      deap \
      edward \
      GPy gplearn graphviz \
      hmmlearn \
      keras \
      pykalman \
      git+https://github.com/thu-ml/zhusuan

# PyQt5 is set by conda as the default backend. Switch back to Agg
RUN sed -i 's/^backend.*//g' /opt/conda/lib/python3.6/site-packages/matplotlib/mpl-data/matplotlibrc

RUN jupyter nbextension enable --system --py widgetsnbextension

ADD https://github.com/krallin/tini/releases/download/v0.16.1/tini /usr/bin/tini
RUN chmod +x /usr/bin/tini

ENTRYPOINT [ "/usr/bin/tini", "--" ]
CMD [ "/bin/bash" ]
