{
  inputs,
  config,
  pkgs,
  lib,
  ...
}: {
  services.wivrn = {
  enable = true;
  openFirewall = true;

  # Write information to /etc/xdg/openxr/1/active_runtime.json, VR applications
  # will automatically read this and work with WiVRn (Note: This does not currently
  # apply for games run in Valve's Proton)
    defaultRuntime = true;

  # Run WiVRn as a systemd service on startup
  autoStart = true;

  # Config for WiVRn (https://github.com/WiVRn/WiVRn/blob/master/docs/configuration.md)
  config = {
    enable = true;
    json = {
      # 1.0x foveation scaling
      scale = 1.0;
      # 65 Mb/s
      bitrate = 65000000;
    };
  };
};
}
