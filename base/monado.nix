{
  inputs,
  config,
  pkgs,
  lib,
  ...
}: {
 
  services.monado = {
    enable = true;
    defaultRuntime = true; # Register as default OpenXR runtime
  };

  systemd.user.services.monado.environment = {
    STEAMVR_LH_ENABLE = "1";
    XRT_COMPOSITOR_COMPUTE = "1";
#    U_PACING_COMP_MIN_TIME_MS="12";
    WMR_HANDTRACKING = "0";
    AMD_VULKAN_ICD="RADV";
  };
}
