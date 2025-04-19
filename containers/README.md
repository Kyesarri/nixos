# changes 19 apr 25
figured out i was using a backwards method, exposing containers via the internal lan
containers are now moving to an internal network titled 'internal' with nginx
chilling infront of all containers. this leaves way less configuration options
for each container and simplifies all processes adding more in the future.

what this means is lots of updates to the containers, lots less macvlan configurations as nginx-lan will be handling all
containers running on erying.

also adding some systemd services per container to manage volumes (removing /etc/oci.cont/contName for most), networking,
starting and stopping the containers.

really the configs are changing to how it should have been from the start, rather than the mess it's ended up being :)

# containers
most are podman with some nspawn / nixos containers, many use mac-vlan running on internal network on static addresses

secrets / ip managed by gitcrypt

storage in /etc/oci.cont/contName for erying / new containers, some still in ~/.containers

each container ***should*** generate directories with correct perms

many are being ported over to modules, with their configuration defined in each host's [containers.nix](../hosts/erying/containers.nix)

example:

    {config, ...}:{
    # ...
        imports = [ ../../containers ];
        cont = {
            adguard = {
                enable = true;
                macvlanIp = "192.168.0.1";
                vlanIp = "10.10.10.1";
                image = "adguard/adguardhome:latest"; # not required
                contName = "adguard-${config.networking.hostName}"; # not required
                timeZone = "Australia/Melbourne"; # not required
            };
        };
    # ...
    }

i'm also moving most containers over to the vlan on each host, with comms to the containers via nginx-lan / tailscale

## adguard
barebones without any defined configs

## arr
barebones bazarr / prowlarr / radarr / readarr / sonarr

#TODO add transmission w' flood to stack

## backend-network
network for inter container comms - leverages tailscale subnet routing for inter host comms

## cockroachdb
isn't a working container - barebones for use in other containers - see zitadel

## compreface
not running - pending config - may implement into doubletake

## cpai
codeproject ai for face recognition - may implement into doubletake

## dms
docker mail server - is a #TODO atm

## doubletake
toying with face recognition, barebones no config

## emqx
mqtt container, barebones, legacy config dirs

## esphome
barebones, but working, in service atm

## frigate
complete frigate container with coral m.2, igpu and configuration

## fweedee
testing grounds for 3d-printer packages

## ghost
website / blog

## haos
barebones container, pending migration from serv to erying

## headscale
tailscale replacement - needs work

## home-assistant
legacy home-assistant, may migrate to haos config above eventually

## homer
landing page for home services, barebones container with config.yml in tree

## i2pd
for scary dark interwebs

## immich
nspawn container, local image host - using host ip currently #TODO nspawn macvlan

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

## nginx-lan
barebones, running, legacy storage dirs

## nginx-wan
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

## radicale
calendar / todo sync lad

## subgen & subsai
generate subtitles for local media using "ai"

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