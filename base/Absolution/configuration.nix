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
    KERNEL=="cpu_dma_latency", GROUP="gamemode"
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
    gamemode = {
      enable = true;
      settings = {
        general = {
          renice = 10;
        };
        # gpu = {
        #   apply_gpu_optimisations = "accept-responsibility";
        #   gpu_device = 1;
        #   amd_performance_level = "high";
        # };
      };
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
  boot.initrd.kernelModules = [ "amdgpu" ];
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
    extraPackages = with pkgs; [mesa.opencl libvdpau-va-gl vaapiVdpau vulkan-validation-layers rocmPackages.clr.icd];
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
    sudo = {
      extraRules = [
        {
          groups = [
            "gamemode"
          ];
          commands = [
            {
              command = "${pkgs.gamemode}/bin/gamemoderun";
              options = [ "NOPASSWD" ];
            }
            {
              command = "${pkgs.gamemode}/libexec/procsysctl";
              options = [ "NOPASSWD" ];
            }
            {
              command = "${pkgs.gamemode}/libexec/cpugovctl";
              options = [ "NOPASSWD" ];
            }
            {
              command = "${pkgs.gamemode}/libexec/gpuclockctl";
              options = [ "NOPASSWD" ];
            }
            {
              command = "^/nix/store/.*/bin/gamemoderun$";
              options = [ "NOPASSWD" ];
            }
            {
              command = "^/nix/store/.*/libexec/procsysctl$";
              options = [ "NOPASSWD" ];
            }
            {
              command = "^/nix/store/.*/libexec/cpugovctl$";
              options = [ "NOPASSWD" ];
            }
            {
              command = "^/nix/store/.*/libexec/gpuclockctl$";
              options = [ "NOPASSWD" ];
            }
          ];
        }
      ];
    };
    pam = {
      # Higher resource limits. Used by Lutris/Wine.
      loginLimits = [
        { domain = "@gamemode"; item = "nofile"; type = "soft"; value = "1048576"; }
        { domain = "@gamemode"; item = "nofile"; type = "hard"; value = "1048576"; }
        { domain = "@gamemode"; type = "-"; item = "rtprio"; value = 98; }
        { domain = "@gamemode"; type = "-"; item = "memlock"; value = "unlimited"; }
        { domain = "@gamemode"; type = "-"; item = "nice"; value = -11; }
      ];
    };
    # wrappers = {
    #   mangohud = {
    #     owner = "root";
    #     group = "root";
    #     source = "${pkgs.mangohud}/bin/mangohud";
    #     capabilities = "cap_sys_nice+pie";
    #   };
    #   mangoapp = {
    #     owner = "root";
    #     group = "root";
    #     source = "${pkgs.mangohud}/bin/mangoapp";
    #     capabilities = "cap_sys_nice+pie";
    #   };
    # };
  };

  security.polkit.extraConfig = ''
    polkit.addRule(function (action, subject) {
      if ((action.id == "com.feralinteractive.GameMode.governor-helper" ||
        action.id == "com.feralinteractive.GameMode.gpu-helper" ||
        action.id == "com.feralinteractive.GameMode.cpu-helper" ||
        action.id == "com.feralinteractive.GameMode.procsys-helper") &&
        subject.isInGroup("gamemode"))
      {
        return polkit.Result.YES;
      }
    });
  '';

  environment.etc."polkit-1/actions/com.feralinteractive.GameMode.policy".text = ''
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE policyconfig PUBLIC
 "-//freedesktop//DTD PolicyKit Policy Configuration 1.0//EN"
 "http://www.freedesktop.org/standards/PolicyKit/1.0/policyconfig.dtd">
<policyconfig>

  <!--
    Copyright (c) 2017-2019, Feral Interactive
    All rights reserved.
  -->

  <vendor>Feral GameMode Activation</vendor>
  <vendor_url>http://www.feralinteractive.com</vendor_url>
  
  <action id="com.feralinteractive.GameMode.governor-helper">
    <description>Modify the CPU governor</description>
    <message>Authentication is required to modify the CPU governor</message>
    <defaults>
      <allow_any>no</allow_any>
      <allow_inactive>no</allow_inactive>
      <allow_active>no</allow_active>
    </defaults>
    <annotate key="org.freedesktop.policykit.exec.path">${pkgs.gamemode}/libexec/cpugovctl</annotate>
  </action>

  <action id="com.feralinteractive.GameMode.gpu-helper">
    <description>Modify the GPU clock states</description>
    <message>Authentication is required to modify the GPU clock states</message>
    <defaults>
      <allow_any>no</allow_any>
      <allow_inactive>no</allow_inactive>
      <allow_active>no</allow_active>
    </defaults>
    <annotate key="org.freedesktop.policykit.exec.path">${pkgs.gamemode}/libexec/gpuclockctl</annotate>
    <annotate key="org.freedesktop.policykit.exec.allow_gui">true</annotate>
  </action>

  <action id="com.feralinteractive.GameMode.cpu-helper">
    <description>Modify the CPU core states</description>
    <message>Authentication is required to modify the CPU core states</message>
    <defaults>
      <allow_any>no</allow_any>
      <allow_inactive>no</allow_inactive>
      <allow_active>no</allow_active>
    </defaults>
    <annotate key="org.freedesktop.policykit.exec.path">${pkgs.gamemode}/libexec/cpucorectl</annotate>
    <annotate key="org.freedesktop.policykit.exec.allow_gui">true</annotate>
  </action>

  <action id="com.feralinteractive.GameMode.procsys-helper">
    <description>Modify the /proc/sys values</description>
    <message>Authentication is required to modify the /proc/sys/ values</message>
    <defaults>
      <allow_any>no</allow_any>
      <allow_inactive>no</allow_inactive>
      <allow_active>no</allow_active>
    </defaults>
    <annotate key="org.freedesktop.policykit.exec.path">${pkgs.gamemode}/libexec/procsysctl</annotate>
    <annotate key="org.freedesktop.policykit.exec.allow_gui">true</annotate>
  </action>
</policyconfig>
  '';

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
