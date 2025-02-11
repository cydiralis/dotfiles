# Welcome to my Nix flake!
![](/assets/desktop.png)
This repo is used to store the flake for my NixOS and non-NixOS systems, it includes a home-manager configuration that ~~(should)~~ DOES!!! work both standalone and as a NixOS module, which manages an MPD server, swayfx (this is because hyprland has bad vram management), waybar, etc

# General layout:
the configuration.nix and hardware-configuration.nix files are stored in the base directory, they can be detached from the flake and used as a non-graphical configurations.

The home directory is where all the home-manager configuration goes and everything that is managed by it, sway, waybar, theming etc.

### /home/
In here, there is a default.nix file which ~~should~~ does work as a standalone home-manager config and is the entrypoint for it

packages.nix - general packages not managed by home-manager that are to be installed by it as they are graphical, or a hm-configured thing uses it

swayfx - This is where the swayfx-specific stuff goes due to being unable to declaratively configure this because of the nature of home-manager

sway.nix - This is the sway configuration

theming.nix - This file is used for general theme configuration.

#### /home/waybar/
This directory stores the waybar configuration. It is not configured in Nix.

Please note that mkOutOfStoreSymlink is used to configure waybar's files so I do not need to rebuild for any change.

### /base/
This directory has many different Nix files that are imported based on what is wanted in the configuration.

The format is /base/hostname/default.nix (this will be elaborated on)

fonts.nix - self explanatory, configures fonts for the system.

overrides.nix - package overrides are kept in here where possible as it makes it easier to find.

ssh.nix - This is where the SSH server is configured. password authentication is off and is exclusively key use only.

substituters.nix - This is where substituters are added.

syncthing.nix - This is where syncthing would be configured if used. It is not currently present due to a lack of need for syncthing

#### /base/hostname/
This is where the configurations are stored for each host.

configuration.nix & hardware-configuration.nix - self explanatory

default.nix - This is where flake.nix imports the config from. It imports configuration.nix and any of the various .nix files in /base/ that are wanted)

### /assets/
This folder is for general assets e.g. wallpapers or stuff to show in this document.

### TODO
- [ ] Manage shell via home-manager so standalone configs will have hm-managed stuff in the path
- [ ] Move Syncthing config to home-manager so it's across all hosts - not a focus due to not using syncthing
- [x] Find a way to only declare username once in home.nix so changing username is only one line
- [ ] MAYBE tune sway + waybar configs for touchscreen use (like Sxmo on postmarketOS)
- [ ] Move stuff like git email and other personally identifiable information to a secret managing system


### Credits
beanigen - this flake and readme are based off theirs with minor modifications for my usage
