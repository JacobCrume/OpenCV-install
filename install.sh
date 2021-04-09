#!/bin/bash

if [ "$EUID" -ne 0 ]
  then echo "Please run as root"
  exit
fi

echo -e ‘\n alias”python=python3”’ >> ~/.bashrc
echo ‘alias”pip=pip3”’ >> ~/.bashrc
apt-get install build-essential cmake unzip pkg-config 
apt-get install libjpeg-dev libpng-dev libtiff-dev libavcodec-dev libavformat-dev libswscale-dev libv4l-dev libxvidcore-dev libx264-dev
apt-get install libgtk-3-dev libcanberra-gtk*
apt-get install libatlas-base-dev gfortran
apt-get install python3-dev
cd ~
wget -O opencv.zip https://github.com/opencv/opencv/archive/4.0.0.zip
wget -O opencv_contrib.zip https://github.com/opencv/opencv_contrib/archive/4.0.0.zip
unzip opencv.zip
unzip opencv_contrib.zi
mv opencv-4.0.0 opencv
mv opencv_contrib-4.0.0 opencv_contrib
wget https://bootstrap.pypa.io/get-pip.py
python3 get-pip.py
pip install virtualenv virtualenvwrapper
rm -rf ~/get-pip.py ~/.cache/pip
echo -e "\n# virtualenv and virtualenvwrapper" >> ~/.profile
echo "export WORKON_HOME=$HOME/.virtualenvs" >> ~/.profile
echo "export VIRTUALENVWRAPPER_PYTHON=/usr/bin/python3" >> ~/.profile
echo "source /usr/local/bin/virtualenvwrapper.sh" >> ~/.profile
source ~/.profile
mkvirtualenv cv -p python3
workon cv
pip install numpy
cd ~/opencv
mkdir build
cd build
cmake -D CMAKE_BUILD_TYPE=RELEASE -D CMAKE_INSTALL_PREFIX=/usr/local -D OPENCV_EXTRA_MODULES_PATH=~/opencv_contrib/modules -D ENABLE_NEON=ON -D ENABLE_VFPV3=ON -D BUILD_TESTS=OFF -D OPENCV_ENABLE_NONFREE=ON -D INSTALL_PYTHON_EXAMPLES=OFF -D BUILD_EXAMPLES=OFF ..
make -j4
make install
ldconfig
cd ~/.virtualenvs/cv/lib/python3.5/site-packages/
ln -s /usr/local/python/cv2/python-3.5/cv2.cpython-35m-arm-linux-gnueabihf.so cv2.so
cd ~
workon cv
python
