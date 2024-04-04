# frigate

module runs frigate as a docker container / service on host machine, configuration assumes using modern (= or > 10th gen) intel with iGPU for hw accel

sees around 1% cpu core usage per camera feed

my config consists of 3 (one not installed) reolink RLC-520A / IPC_523128M5MP running the latest firmware (as of 03.04.24)

most port forwarding should be enabled by this module, however you may need to configure your hardware accel / drivers on your host machine

config is using placeholder credentials, need to work on secrets management :D

see [serv](../../hosts/serv/default.nix) > hardware + enviornment config