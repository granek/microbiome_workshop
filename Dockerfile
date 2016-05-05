# Copyright (c) Jupyter Development Team.
# Distributed under the terms of the Modified BSD License.

# Derived from:
# wget https://raw.githubusercontent.com/jupyter/docker-stacks/master/r-notebook/Dockerfile
# wget https://raw.githubusercontent.com/jupyter/docker-stacks/master/datascience-notebook/Dockerfile
# wget https://raw.githubusercontent.com/jupyter/docker-stacks/master/scipy-notebook/Dockerfile

FROM jupyter/r-notebook

MAINTAINER Josh Granek <josh@duke.edu>

USER root

# Install less
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    less \
    && apt-get clean && \
    rm -rf /var/lib/apt/lists/*

##--------------------------------------------------
USER jovyan

# Install Python 2 packages
RUN conda create --quiet --yes -p $CONDA_DIR/envs/python2 python=2.7 \
    'ipython=4.1*' \
    'ipywidgets=4.1*' \
    'pandas=0.17*' \
    'numexpr=2.5*' \
    'matplotlib=1.5*' \
    'scipy=0.17*' \
    'seaborn=0.7*' \
    'cython=0.23*' \
    'patsy=0.4*' \
    'statsmodels=0.6*' \
    && conda clean -tipsy

# Install Bash Kernel
RUN pip install --user --no-cache-dir bash_kernel && \
    python -m bash_kernel.install

USER root

# Install Python 2 kernel spec globally to avoid permission problems when NB_UID
# switching at runtime.
RUN $CONDA_DIR/envs/python2/bin/python -m ipykernel install

USER jovyan
##--------------------------------------------------
