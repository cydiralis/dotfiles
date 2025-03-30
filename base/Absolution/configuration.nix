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
    steam.enable = true;
    flashrom.enable = true;
    nix-ld.enable = true;
    nix-ld.libraries = with pkgs; [xorg.libxcb libao xorg.libX11 libusb1 cargo rustc pkg-config cacert];
  };

  services.journald.extraConfig = ''
        SystemMaxUse=2G
  '';

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
  boot.kernelParams = [ "amdgpu.ppfeaturemask=0xffffffff" "amdgpu.seamless=1" "amdgpu.freesync_video=1" "initcall_blacklist=simpledrm_platform_driver_init"];
  boot.extraModulePackages = [
    config.boot.kernelPackages.v4l2loopback.out
  ];

#  boot.kernelPatches = [
#    {
#      name = "amdgpu-ignore-ctx-privileges";
#      patch = pkgs.fetchpatch {
#        name = "cap_sys_nice_begone.patch";
#        url = "https://github.com/Frogging-Family/community-patches/raw/master/linux61-tkg/cap_sys_nice_begone.mypatch";
#        hash = "sha256-Y3a0+x2xvHsfLax/uwycdJf3xLxvVfkfDVqjkxNaYEo=";
#      };
#    }
#  ];


  programs.virt-manager.enable = true;
  virtualisation = {
    libvirtd = {
      enable = true;
      extraConfig = ''
        user="alyx"
      '';
      qemu.ovmf.enable = true;
      qemu.package = pkgs.qemu_kvm;
      qemu.runAsRoot = true;
    };
    spiceUSBRedirection.enable = true;
  };

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
    extraPackages = with pkgs; [monado-vulkan-layers mesa.opencl libvdpau-va-gl vaapiVdpau vulkan-validation-layers rocmPackages.clr.icd];
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

  # Enable sound with pipewire.
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    jack.enable = true;
  };

  # Define a user account. Don't forget to set a password with ‘passwd’.
  
  users.defaultUserShell = pkgs.fish;
  
  users.users.alyx = {
    isNormalUser = true;
    description = "Alyx";
    extraGroups = [ "networkmanager" "wheel" "libvirtd" "camera" ];
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

  environment.systemPackages = with pkgs; [
    wget
    neovim
    cbfstool
    git
    lact
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
