#!/bin/bash -eux

sudo apt update -qqy
sudo apt upgrade -qqy
sudo raspi-config

sudo apt install -qqy vim curl build-essential git cmake python3-{pip,setuptools} nano unzip gnupg
sudo apt install -qqy lib{eigen3,boost-all,atlas-base,octomap,assimp,urdfdom,yaml-cpp}-dev zram-tools
sudo apt install -qqy mosquitto nginx tmux

python3 -m pip install --user -U pip
python3 -m pip install --user -U numpy scipy matplotlib ipython inputs pybullet


mkdir .ssh
chmod 700 .ssh
vim .ssh/authorized_keys
sudo sed -i 's/#ALLOCATION=256/ALLOCATION=4096/' /etc/default/zramswap
sudo systemctl restart zramswap

# TODO
sudo chown -R pi /usr/local
sudo python3 -m pip install inputs

git clone https://github.com/nim65s/solo-demo.git
mkdir solo-demo/build
cd solo-demo/build || exit 1
cmake -DCMAKE_BUILD_TYPE=Release ..
echo "tmux"
echo "make"
