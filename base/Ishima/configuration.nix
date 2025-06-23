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
  
  services.desktopManager.plasma6.enable = true;
  jovian.devices.steamdeck.enable = true;
  jovian.steam.autoStart = true;
  jovian.steam.enable = true;
  jovian.steam.user = "alyx";
  jovian.steam.desktopSession = "plasma";
  jovian.devices.steamdeck.autoUpdate = true;


  programs = {
    adb.enable = true;
    firefox.enable = true;
    fish.enable = true;
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
  
  boot.supportedFilesystems = ["exfat" "ntfs" "xfs"];
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.initrd.systemd.enable = true;
  boot.initrd.kernelModules = [ "amdgpu" ];
  boot.loader.efi.efiSysMountPoint = "/boot/";

  networking.hostName = "Ishima"; # Define your hostname.

  powerManagement.cpuFreqGovernor = "performance";

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  hardware.graphics = {
    enable = true;
    enable32Bit = true;
    extraPackages = with pkgs; [libvdpau-va-gl vaapiVdpau vulkan-validation-layers rocmPackages.clr.icd];
  };

  hardware.amdgpu = {
    opencl.enable = true;
    initrd.enable = true;
    amdvlk.supportExperimental.enable = true;
    amdvlk.support32Bit.enable = true;
    amdvlk.enable = true;
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

  # Enable the X11 windowing system.
  services.xserver.enable = true;
  programs.dconf.enable = true;

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

  # Enable CUPS to print documents.
  services.printing.enable = true;
  services.printing.drivers = [pkgs.gutenprint];

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
  };

  # Define a user account. Don't forget to set a password with ‘passwd’.
  
  programs.bash = {
    interactiveShellInit = ''
      if [[ $(${pkgs.procps}/bin/ps --no-header --pid=$PPID --format=comm) != "fish" && -z ''${BASH_EXECUTION_ST>
      then
        shopt -q login_shell && LOGIN_OPTION='--login' || LOGIN_OPTION=""
        exec ${pkgs.fish}/bin/fish $LOGIN_OPTION
      fi
    '';
  };
  
  users.users.alyx = {
    isNormalUser = true;
    description = "Alyx";
    extraGroups = [ "networkmanager" "wheel" "camera" ];
    packages = with pkgs; [
    ];
  };

  services.libinput.enable = true;

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  environment.systemPackages = with pkgs; [
    wget
    neovim
    cbfstool
    git
    keepassxc
    pulseaudio
    steamdeck-firmware
    jupiter-dock-updater-bin
    winetricks
    p7zip
    cabextract
    unzip
    wineWowPackages.stable
    (pkgs.python3.withPackages (ps: with ps; [tkinter]))
  ];

  system.stateVersion = "24.11"; # Did you read the comment?

}
