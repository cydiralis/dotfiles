{lib, osConfig, pkgs, inputs, vars, ...}:{
  wayland.windowManager.sway = {
    package = pkgs.swayfx;
    enable = (!vars.isDeck);
    checkConfig = false; #gles2 renderer error
    extraConfig = import ./swayfx;
    config = {
      modifier = "Mod4";
      terminal = "foot";
      output = {
        DP-1 = {
          mode = "1920x1080@239.760Hz";
          pos = "0 0";
        };
        DP-4 = {
          mode = "2560x1080";
          pos = "1920 0";
        };
        HDMI-A-1 = {
          mode = "1920x1080";
          pos = "1440 1080";
        };
      };
      workspaceOutputAssign = (if vars.isLaptop then
        # For Laptop: assign workspace 1 to eDP-1
        [
          { workspace = "1"; output = "eDP-1"; }
        ]
      else
        # For Desktop: assign workspaces to different outputs
        [
          { workspace = "1"; output = "DP-1"; }
          { workspace = "2"; output = "DP-4"; }
          { workspace = "3"; output = "HDMI-A-1"; }
        ]
      );
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
        "10429:10507:UGTABLET_UE12_PLUS" = {
           map_to_output = "HDMI-A-1";
        };
        "type:keyboard" = {
          xkb_layout = (if !vars.isLaptop then "gb" else "us");
          xkb_variant = (if !vars.isLaptop then "''" else "colemak");
        };
        "type:pointer" = {
          accel_profile = "flat";
        };
        "1:1:AT_Translated_Set_2_keyboard" = {
          xkb_variant = "colemak";
        };
      };
      bars = [];
      defaultWorkspace = "workspace number 1";
      startup = [
        { command = "waybar"; }
        { command = "udiskie --appindicator -t"; }
        { command = "kanshi"; }
        { command = "swaync"; }
        { command = (if !vars.isTough then "swaybg -m fill -i ~/.config/nixos/assets/FATEINVERSION.png" else "swaybg -m fill -i ~/.config/nixos/assets/twinkbook.png"); }
        { command = "kde-indicator"; }
        { command = "blueman-applet"; }
      ];
      workspaceLayout = "default";
      keybindings = lib.mkOptionDefault {
        "Print" = "exec grimblast copysave area";
        "Mod4+s" = "exec foot --title launch --app-id fzf-launcher-foot bash -c 'compgen -c | sort -u | fzf | xargs swaymsg exec --'";
	"Mod4+t" = "exec foot --title music --app-id mpd-control-foot ncmpcpp";
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
        "Mod4+f" = "fullscreen toggle";
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
