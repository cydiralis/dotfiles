# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, lib, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  nix.package = pkgs.lix;  

  services.udev.extraRules = ''
    SUBSYSTEM=="usb", ATTRS{idVendor}=="07ca", ATTRS{idProduct}=="0551", MODE="0666"
    SUBSYSTEM=="usb", ATTRS{idVendor}=="07ca", ATTRS{idProduct}=="4710", MODE="0666"
  '';

  programs = {
    adb.enable = true;
    firefox.enable = true;
    fish.enable = true;
    gamescope = {
      enable = true;
      capSysNice = false;
      # capSysNice = true;
      # package = unstable.gamescope;
    };
    steam = {
      enable = true;
      protontricks.enable = true;
      extraPackages = with pkgs; [
        xorg.libXcursor
        xorg.libXi
        xorg.libXinerama
        xorg.libXScrnSaver
        xorg.libxcb
        libpng
        libpulseaudio
        libvorbis
        stdenv.cc.cc.lib
        libkrb5
        keyutils
        gamemode
        procps
        usbutils
      ] ++ config.fonts.packages;
      extraCompatPackages = with pkgs; [
        steamtinkerlaunch
      ];
      remotePlay.openFirewall = true; # Open ports in the firewall for Steam Remote Play
      dedicatedServer.openFirewall = true; # Open ports in the firewall for Source Dedicated Server
      localNetworkGameTransfers.openFirewall = true; # Open ports in the firewall for Steam Local Network Game Transfers
    };
    flashrom.enable = true;
    nix-ld.enable = true;
    nix-ld.libraries = with pkgs; [xorg.libxcb libao xorg.libX11 libusb1 cargo rustc pkg-config cacert];
  };

  services.journald.extraConfig = ''
        SystemMaxUse=2G
  '';

  hardware.steam-hardware.enable = true;

  services.tailscale = {
    enable = true;
    useRoutingFeatures = "both";
  };

  xdg.portal.config.common.default = "*";
  xdg.portal.wlr = {
    enable = true;
    settings = {
      screencast = {
        chooser_type = "simple";
        chooser_cmd = "${pkgs.slurp}/bin/slurp -f %o -or";
        exec_before = "${lib.getExe' pkgs.swaynotificationcenter "swaync-client"} --dnd-on --skip-wait";
        exec_after = "${lib.getExe' pkgs.swaynotificationcenter "swaync-client"} --dnd-off --skip-wait";
      };
    };
  };
  
  boot.supportedFilesystems = ["exfat" "ntfs" "xfs"];
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.initrd.systemd.enable = true;
  boot.kernelModules = [ "nvidia" "nvidia_modeset" "nvidia_uvm" "nvidia_drm" ];
  boot.extraModprobeConfig = "options nvidia_drm fbdev=1";
  boot.loader.efi.efiSysMountPoint = "/boot/";
  boot.kernelParams = [ "amdgpu.ppfeaturemask=0xffffffff" "amdgpu.seamless=1" "amdgpu.freesync_video=1" "initcall_blacklist=simpledrm_platform_driver_init" "pcie_acs_override=downstream,multifunction" "preempt=voluntary"];
  boot.extraModulePackages = [
    config.boot.kernelPackages.v4l2loopback.out
  ];
  boot.kernelPackages = pkgs.linuxKernel.packages.linux_xanmod_latest;
  boot.kernel.sysctl = {
    "vm.max_map_count" = 2147483642;
  };

  boot.kernelPatches = [
    {
      name = "amdgpu-ignore-ctx-privileges";
      patch = pkgs.fetchpatch {
        name = "cap_sys_nice_begone.patch";
        url = "https://github.com/Frogging-Family/community-patches/raw/master/linux61-tkg/cap_sys_nice_begone.mypatch";
        hash = "sha256-Y3a0+x2xvHsfLax/uwycdJf3xLxvVfkfDVqjkxNaYEo=";
      };
    }
     #{
     #  name = "add-acs-overrides";
     #  patch = pkgs.fetchurl {
     #    name = "add-acs-overrides.patch";
     #    url = "https://raw.githubusercontent.com/some-natalie/fedora-acs-override/main/acs/add-acs-override.patch";
     #    sha256 = "f7d5c0236b2ef5465817c094aef4295867c87b1b3cb4e41c53e24b79b2bd22f6";
     #  };
     #}
  ];


  programs.virt-manager.enable = true;
  systemd.packages = with pkgs; [lact];
  systemd.services.lactd.wantedBy = ["multi-user.target"];
  networking.hostName = "Absolution"; # Define your hostname.

  powerManagement.cpuFreqGovernor = "performance";

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  hardware.graphics = {
    enable = true;
    enable32Bit = true;
    extraPackages = with pkgs; [amdvlk mesa.opencl libvdpau-va-gl vaapiVdpau vulkan-validation-layers rocmPackages.clr.icd];
    extraPackages32 = with pkgs; [driversi686Linux.amdvlk driversi686Linux.mesa.opencl];
  };

  hardware.bluetooth.enable = true;
  services.blueman.enable = true;

  networking.networkmanager = {
    enable = true;
    wifi.backend = "iwd";
  };

    # Set your time zone.
  time.timeZone = "Europe/London";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_GB.UTF-8";

  services.udisks2.enable = true;

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_GB.UTF-8";
    LC_IDENTIFICATION = "en_GB.UTF-8";
    LC_MEASUREMENT = "en_GB.UTF-8";
    LC_MONETARY = "en_GB.UTF-8";
    LC_NAME = "en_GB.UTF-8";
    LC_NUMERIC = "en_GB.UTF-8";
    LC_PAPER = "en_GB.UTF-8";
    LC_TELEPHONE = "en_GB.UTF-8";
    LC_TIME = "en_GB.UTF-8";
  };

  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 30d";
  };

  services.greetd = {
    enable = true;
    restart = true;
    settings.default_session = {
      command = "${pkgs.greetd.tuigreet}/bin/tuigreet --time --cmd sway";
      user = "greeter";
    };
  };

  systemd.services.greetd.serviceConfig = {
    Type = "idle";
    StandardInput = "tty";
    StandardOutput = "tty";
    StandardError = "journal";
    TTYReset = "true";
    TTYHangup = "true";
    TTYVTDisallocate = "true";
  };

  systemd = {
    user.services.polkit-gnome-authentication-agent-1 = {
      description = "polkit-gnome-authentication-agent-1";
      wantedBy = [ "graphical-session.target" ];
      wants = [ "graphical-session.target" ];
      after = [ "graphical-session.target" ];
      serviceConfig = {
          Type = "simple";
          ExecStart = "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1";
          Restart = "on-failure";
          RestartSec = 1;
          TimeoutStopSec = 10;
        };
    };
  };


  # Enable the X11 windowing system.
  services.xserver.enable = true;
  programs.dconf.enable = true;

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "gb";
    variant = "";
  };

  # Enable CUPS to print documents.
  services.printing.enable = true;
  services.printing.drivers = [pkgs.gutenprint];

  nixpkgs.overlays = [
    (self: super: {
      vlc = super.vlc.override {
        libbluray = super.libbluray.override {
          withAACS = true;
          withBDplus = true;
        };
      };
    })
  ];

  security = {
    rtkit.enable = true;
  };

  # Enable sound with pipewire.
  services.pulseaudio.enable = false;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    jack.enable = true;
    extraConfig.pipewire.noresample = { "context.properties" = { "default.clock.allowed-rates" = [ 44100 48000 192000 ]; }; };
    extraConfig.pipewire."92-low-latency" = {
      "context.properties" = {
        "default.clock.rate" = 192000;
        #"default.clock.quantum" = 288;
        #"default.clock.min-quantum" = 32;
        #"default.clock.max-quantum" = 288;
      };
    };
    extraConfig.pipewire-pulse."92-low-latency" = {
      context.modules = [
        {
          name = "libpipewire-module-protocol-pulse";
          args = {
             pulse.min.req = "32/48000";
             pulse.default.req = "32/48000";
             pulse.max.req = "192000";
          #   pulse.min.quantum = "32/48000";
          #   pulse.max.quantum = "288/192000";
          };
        }
      ];
      stream.properties = {
        node.latency = "32/48000";
        resample.quality = 1;
      };
    };
  };

  # Define a user account. Don't forget to set a password with ‘passwd’.
  
  users.defaultUserShell = pkgs.fish;
  
  users.users.alyx = {
    isNormalUser = true;
    description = "Alyx";
    extraGroups = [ "gamemode" "networkmanager" "wheel" "libvirtd" "camera" "qemu-libvirtd" "lxd" ];
    packages = with pkgs; [
    ];
  };

  services.libinput.enable = true;

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;
  nixpkgs.config.permittedInsecurePackages = [
    "dotnet-sdk-7.0.410"
    "dotnet-sdk-6.0.428"
    "dotnet-runtime-7.0.20"
  ];

  services.ananicy = { # https://github.com/NixOS/nixpkgs/issues/351516
    enable = true;
    package = pkgs.ananicy-cpp;
    rulesProvider = pkgs.ananicy-cpp;
    extraRules = [
      {
        "name" = "gamescope";
        "nice" = -20;
      }
    ];
  };

  environment.systemPackages = with pkgs; [
    wget
    neovim
    cbfstool
    steamtinkerlaunch
    vulkan-tools
    r2modman
    index_camera_passthrough
    wayvr-dashboard
    r2mod_cli
    gamemode
    git
    lact
    looking-glass-client
    keepassxc
    pulseaudio
    winetricks
    p7zip
    cabextract
    unzip
    wineWowPackages.stable
    (pkgs.python3.withPackages (ps: with ps; [tkinter]))
  ];

  environment.sessionVariables = {
    HYPRLAND_INSTANCE_SIGNATURE = "balls";
  };

  system.stateVersion = "24.11"; # Did you read the comment?

}
