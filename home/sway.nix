{lib, osConfig, pkgs, inputs, ...}:{
  wayland.windowManager.sway = {
    package = pkgs.swayfx;
    enable = true;
    checkConfig = false; #gles2 renderer error
    extraConfig = import ./swayfx;
    config = {
      modifier = "Mod4";
      terminal = "foot";
      output = {
        DP-1 = {
          mode = "1920x1080@239.760Hz";
          pos = "2560 0";
        };
        DP-2 = {
          mode = "2560x1080";
          pos = "0 0";
        };
        HDMI-A-1 = {
          mode = "1920x1080";
          pos = "1440 1080";
        };
      };
      gaps = {
        inner = 5;
        outer = 7;
      };
      input = {
        "type:touchpad" = {
          accel_profile = "flat";
          dwt = "disabled";
          scroll_factor = "0.3";
        };
        "type:keyboard" = {
          xkb_layout = "gb";
        };
        "type:pointer" = {
          accel_profile = "flat";
        };
      };
      bars = [];
      defaultWorkspace = "workspace number 1";
      startup = [
        { command = "waybar"; }
        { command = "udiskie --appindicator -t"; }
        { command = "kanshi"; }
        { command = "swaync"; }
        { command = "swaybg -m fill -i ~/.config/nixos/assets/FATEINVERSION.png"; }
        { command = "kde-indicator"; }
        { command = "blueman-applet"; }
      ];
      workspaceLayout = "default";
      keybindings = lib.mkOptionDefault {
        "Print" = "exec grimblast copy area";
        "Mod4+d" = "exec foot --title launch --app-id fzf-launcher-foot bash -c 'compgen -c | sort -u | fzf | xargs swaymsg exec --'";
	"Mod4+f" = "exec foot --title music --app-id mpd-control-foot ncmpcpp";
        "XF86AudioRaiseVolume" = "exec wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+ -l 1.0";
        "XF86AudioLowerVolume" = "exec wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-";
        "XF86AudioMute" = "exec wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle";
        "XF86AudioPlay" = "exec playerctl play-pause";
        "XF86AudioNext" = "exec playerctl next";
        "XF86AudioPrev" = "exec playerctl previous";
        "XF86AudioStop" = "exec playerctl stop";
        "XF86AudioMicMute" = "exec wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle";
        "XF86MonBrightnessDown" = "exec brightnessctl s 10%-";
        "XF86MonBrightnessUp" = "exec brightnessctl s +10%";
        "XF86AudioMedia" = "exec vlc";
        "XF86Launch1" = "exec nmcli device wifi rescan";
        "Shift_L+Control_L+B" = "exec playerctl position 10-";
        "Shift_L+Control_L+F" = "exec playerctl position 10+";
      };
      floating.criteria = [
        { app_id = "^fzf-launcher-foot$";}
	{ app_id = "^mpd-control-foot$";}
      ];
      window = {
        titlebar = false;
      };
    };
  };
}
