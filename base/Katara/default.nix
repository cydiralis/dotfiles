{config, pkgs, ...}:{
  imports = [
    ./configuration.nix
    ../overrides.nix
    ../ssh.nix
    ../substituters.nix
    ../fonts.nix
  ];
}
