# containers
majority of containers are using macvlan managed by erying host

some legacy still running on serv

secrets / ip managed by gitcrypt

storage in /etc/oci.cont/contName for erying / new containers

each container *should* generate directories with correct perms

## adguard
barebones without any defined configs

## arr
barebones bazarr / prowlarr / radarr / readarr / sonarr

todo add transmission w' flood to stack

## compreface
not running - pending config - may implement into doubletake

## cpai
codeproject ai for face recognition - may implement into doubletake

## doubletake
toying with face recognition, barebones no config

## emqx
mqtt container, barebones, legacy config dirs

## esphome
un-used but working, barebones

## frigate
complete frigate container with coral m.2 and igpu, config complete

## haos
barebones container, pending migration from serv to erying

## home-assistant
legacy home-assistant, may migrate to haos config above eventually

## homer
to be landing page for home services, barebones container with config.yml in tree - to be added to .nix

## invidious
not running - another project that needs time

## matter
basic home assistant matter container, no configs, unsure if working correctly as i've got no matter devices yet

## nginx-proxy-manager
barebones, running, legacy storage dirs

## observium
not running currently

## plex
my first oci container that was working correctly, legacy, barebones (mostly) with some simple storage defined

## zigbee2mqtt
not using currently to be implemented eventually