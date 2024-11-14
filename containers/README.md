# containers
podman containers, most are mac-vlan running on internal network on static addresses

secrets / ip managed by gitcrypt

storage in /etc/oci.cont/contName for erying / new containers, some still in ~/.containers

each container ***should*** generate directories with correct perms

## adguard
barebones without any defined configs

## arr
barebones bazarr / prowlarr / radarr / readarr / sonarr

todo add transmission w' flood to stack

## cockroachdb
isn't a working container - barebones for use in other containers - see zitadel

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
complete frigate container with coral m.2 and igpu, config 

## fweedee
testing grounds for 3d-printer packages

## ghost
website / blog

## haos
barebones container, pending migration from serv to erying

## home-assistant
legacy home-assistant, may migrate to haos config above eventually

## homer
landing page for home services, barebones container with config.yml in tree

## i2pd
for scary dark interwebs

## invidious
not running - another project that needs time

## klipper
3d printer boi - being replaced "eventually" by fweedee

## mainsail
same as above

## matter
basic home assistant matter container, no configs, unsure if working correctly as i've got no matter devices yet

## minecraft
paper minecraft server with a gate proxy, complete with configs

## netbird
think tailscale but self-hosted, this became a much larger project than i anticipated - zitadel & cockroachdb

## nginx-proxy-manager
barebones, running, legacy storage dirs

## nginx-proxy-manager-2
same as above, used for wan connections

## observium
not running currently

## octoprint
barebones container

## orcaslicer
3d printer slicer running in a container! quite a cool docker image

## overseerr
barebones overseerr container, simple enough to configure once running

## peanut
ups monitor container - un-used currently may migrate to nspawn container

## plex
my first oci container that was working correctly, legacy, barebones (mostly) with some simple storage defined

## syncthing
sync things between devices

## tailscale
tailscale subnet router, simple boi, manual provision to own tailnet

## testing-networking
testing ground, as networking hurts my smooth brain

## ustreamer
testing pass-through of host webcam to container - probs not needed anymore

## zigbee2mqtt
not using currently to be implemented eventually

## zitadel
auth platform, is way more work than anticipated but is working