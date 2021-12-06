# Solo Demo

Setup a RPi with everything required for the demo with Solo at SIANE:
run `rpi.sh`, then `make` (ideally inside a `tmux`).

This can also be used to build the demo and its dependencies on a standard PC:
```bash
mkdir build
cd build
cmake -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX=where_you_want ..
make
```
