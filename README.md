# arm-compose

This is an automated build for docker-compose on ARM.
This build clones the official repo [docker/compose](https://github.com/docker/compose) and generates an ARMv7 binary.

## Installation

You can find the DEB package for `docker-compose` in Hypriot's Schatzkiste. Add the repo if it isn't already added (newer versions of the HypriotOS SD image already have this entry). 

### Add repo

```bash
sudo apt-get update
sudo apt-get install -y apt-transport-https
echo "deb https://packagecloud.io/Hypriot/Schatzkiste/debian/ jessie main" | sudo tee /etc/apt/sources.list.d/hypriot.list
```

### Install or Update

```bash
sudo apt-get update
sudo apt-get install docker-compose
```

## Contributing

### Customize the build

The only customization is done in the `VERSION` file. This file contains the tag to build.

### Build script

This steps to build the ARM binary can be found in the drone.yml.

### Patches

There are some file that have to be patched in the upstream repo. These files are in the `patches` folder.

#### Patches for ARM

For the ARM cpu type we have to patch the Dockerfile to adjust the `FROM` line and downloading a docker deb package as well as the PyInstaller 3.0 ARM bootloader.

* Dockerfile

