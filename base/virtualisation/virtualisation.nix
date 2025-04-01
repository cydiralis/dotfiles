{ pkgs, config, ... }: {

   imports = [
     ./kvmfr-options.nix
     ./libvirt.nix
     ./virtualisationmod.nix
     ./vfio.nix
   ];

  services.virtiofsd.enable = true;

  virtualisation = {
    libvirtd = {
      enable = true;
      onBoot = "ignore";
      onShutdown = "shutdown";
      qemu = {
        package = pkgs.qemu_kvm;
        ovmf = {
          enable = true;
          packages = [ pkgs.OVMFFull.fd ];
        };
        vhostUserPackages = [ pkgs.virtiofsd ];
        swtpm.enable = true;
        runAsRoot = false;
      };
      clearEmulationCapabilities = false;
      deviceACL = [
        "/dev/ptmx"
        "/dev/kvm"
        "/dev/kvmfr0"
        "/dev/vfio/vfio"
        "/dev/vfio/30"
      ];
    };

    kvmfr = {
      enable = true;
      shm = {
        enable = true;
        size = 512;
        user = "alyx";
        group = "qemu-libvirtd";
        mode = "0666";
      };
    };
    spiceUSBRedirection.enable = true;
  };

  virtualisation.vfio = {
    enable = true;
    IOMMUType = "intel";
    devices = [
      "1002:67df"
      "1002:aaf0"
    ];
    ignoreMSRs = true;
    disablePCIeASPM = true;
    disableEFIfb = false;
  };

  boot.kernelModules = [ "kvm-intel" "vhost_vsock" "vfio_virqfd" "vhost-net" ];

}
