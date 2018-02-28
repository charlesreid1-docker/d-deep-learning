FROM ubuntu



############## apt ##############

# get ready
RUN apt-get install -y apt-utils
# essentials
RUN apt-get install -y git curl vim unzip openssh-client wget
# dev
RUN apt-get install -y build-essential cmake
# lin alg
RUN apt-get install -y libopenblas-dev
# img stuff
RUN apt-get install -y libjpeg-dev zlib1g-dev
# python
RUN apt-get install -y python3.6 python3.6-dev python3-pip



############## python ##############

RUN pip3 install --no-cache-dir --upgrade pip setuptools

# For convenience, alias (but don't sym-link) 
# python & pip to python3 & pip3 as recommended in:
# http://askubuntu.com/questions/351318/changing-symlink-python-to-python3-causes-problems
RUN echo "alias python='python3'" >> /root/.bash_aliases
RUN echo "alias pip='pip3'" >> /root/.bash_aliases

# pillow and it's dependencies
RUN pip3 --no-cache-dir install Pillow
# common libraries
RUN pip3 --no-cache-dir install numpy scipy pandas matplotlib seaborn six



############### jupyter ##############

RUN pip3 --no-cache-dir install jupyter

# Allow access from outside the container, and skip trying to open a browser.
# NOTE: disable authentication token for convenience. DON'T DO THIS ON A PUBLIC SERVER.
RUN mkdir /root/.jupyter
RUN echo "c.NotebookApp.ip = '*'" \
         "\nc.NotebookApp.open_browser = False" \
         "\nc.NotebookApp.token = ''" \
         > /root/.jupyter/jupyter_notebook_config.py
EXPOSE 8888

############### machine learing ##############

# Tensorflow 
RUN pip3 install --no-cache-dir --upgrade tensorflow 
# Expose port for TensorBoard
EXPOSE 6006

# scikit 
RUN pip3 install --no-cache-dir sklearn scikit-image 

# Keras
RUN pip3 install --no-cache-dir h5py keras

############### opencv ##############

# OpenCV 3.2
# Dependencies
RUN apt-get install -y --no-install-recommends \
    libjpeg8-dev libtiff5-dev libjasper-dev libpng12-dev \
    libavcodec-dev libavformat-dev libswscale-dev libv4l-dev libgtk2.0-dev \
    liblapacke-dev checkinstall
# Get source from github
RUN git clone -b 3.2.0 --depth 1 https://github.com/opencv/opencv.git /usr/local/src/opencv
# Compile
RUN cd /usr/local/src/opencv && mkdir build && cd build && \
    cmake -D CMAKE_INSTALL_PREFIX=/usr/local \
          -D BUILD_TESTS=OFF \
          -D BUILD_PERF_TESTS=OFF \
          -D PYTHON_DEFAULT_EXECUTABLE=$(which python3) \
          .. && \
    make -j"$(nproc)" && \
    make install

################ cleanup ###############

RUN apt-get clean && apt-get autoremove

WORKDIR "/root"
CMD ["/bin/bash"]

