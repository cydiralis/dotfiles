{lib, osConfig, pkgs, inputs, vars, config, ...}:{
  programs.niri = {
    settings = {
      prefer-no-csd = true;
      input.keyboard.xkb.layout = "gb";
      input.focus-follows-mouse.enable = true;
      binds = with config.lib.niri.actions; {
        "Mod+Return".action = spawn "foot";
        "XF86AudioRaiseVolume".action = spawn "wpctl" "set-volume" "@DEFAULT_AUDIO_SINK@" "5%+";
        "XF86AudioLowerVolume".action = spawn "wpctl" "set-volume" "@DEFAULT_AUDIO_SINK@" "5%-";
        "XF86AudioMute".action = spawn "wpctl" "set-mute" "@DEFAULT_AUDIO_SINK@" "toggle";
        "Mod+S".action = spawn "foot" "--title" "launch" "--app-id" "fzf-launcher-foot" "bash" "-c" "niri msg action spawn -- bash -c \"$(compgen -c | sort -u | fzf --bind=enter:replace-query+print-query) >/dev/null\"";
        "Mod+W".action = spawn "hyprlock";
        "Mod+T".action = spawn "foot" "--title" "music" "--app-id" "mpd-control-foot" "ncmpcpp";
        "Mod+Shift+Q" = {
           repeat = false;
           action = close-window;
        };
        "Mod+Y" = {
           repeat = false;
           action = toggle-overview;
        };
        "Mod+Left".action = focus-column-left;
        "Mod+Down".action = focus-window-down;
        "Mod+Up".action =  focus-window-up;
        "Mod+Right".action = focus-column-right;
        "Mod+H".action = focus-column-left;
        "Mod+N".action = focus-window-down;
        "Mod+E".action = focus-window-up;
        "Mod+I".action = focus-column-right;
        "Mod+Shift+Left".action = move-column-left;
        "Mod+Shift+Down".action = move-window-down;
        "Mod+Shift+Up".action = move-window-up;
        "Mod+Shift+Right".action = move-column-right; 
        "Mod+Shift+H".action = move-column-left; 
        "Mod+Shift+N".action = move-window-down;
        "Mod+Shift+E".action = move-window-up;
        "Mod+Shift+I".action = move-column-right;
        "Mod+Home".action = focus-column-first;
        "Mod+End".action = focus-column-last;
	"Mod+Shift+Home".action = move-column-to-first;
        "Mod+Shift+End".action = move-column-to-last;
        "Print".action = screenshot;
        "Ctrl+Print".action = screenshot-window;
        "Mod+Shift+F".action = quit;
        "Mod+Shift+T".action = power-off-monitors;
        "Mod+Shift+Space".action = toggle-window-floating;
        "Mod+Shift+V".action = switch-focus-between-floating-and-tiling;
        "Mod+F".action = maximize-column;
        "Mod+Alt+F".action = fullscreen-window;
        "Mod+Ctrl+F".action = expand-column-to-available-width;
        "Mod+1".action = focus-workspace 1;
        "Mod+2".action = focus-workspace 2;
        "Mod+3".action = focus-workspace 3;
        "Mod+4".action = focus-workspace 4;
        "Mod+5".action = focus-workspace 5;
        "Mod+6".action = focus-workspace 6;
        "Mod+7".action = focus-workspace 7;
        "Mod+8".action = focus-workspace 8;
        "Mod+9".action = focus-workspace 9;
        "Mod+Ctrl+Left".action = focus-monitor-left;
        "Mod+Ctrl+Down".action = focus-monitor-down;
        "Mod+Ctrl+Up".action = focus-monitor-up;
        "Mod+Ctrl+Right".action = focus-monitor-right;
        "Mod+Ctrl+H".action = focus-monitor-left;
        "Mod+Ctrl+N".action = focus-monitor-down;
        "Mod+Ctrl+E".action = focus-monitor-up;
        "Mod+Ctrl+I".action = focus-monitor-right;
        "Mod+Shift+Ctrl+Left".action = move-column-to-monitor-left;
        "Mod+Shift+Ctrl+Down".action = move-column-to-monitor-down; 
        "Mod+Shift+Ctrl+Up".action = move-column-to-monitor-up;
        "Mod+Shift+Ctrl+Right".action = move-column-to-monitor-right;
        "Mod+Shift+Ctrl+H".action = move-column-to-monitor-left;
        "Mod+Shift+Ctrl+N".action = move-column-to-monitor-down;
        "Mod+Shift+Ctrl+E".action = move-column-to-monitor-up;
        "Mod+Shift+Ctrl+I".action = move-column-to-monitor-right;
        "Mod+Page_Down".action = focus-workspace-down;
	"Mod+Page_Up".action = focus-workspace-up;
        "Mod+L".action = focus-workspace-down;
        "Mod+U".action = focus-workspace-up;
        "Mod+Ctrl+Page_Down".action = focus-workspace-down;
        "Mod+Ctrl+Page_Up".action = move-column-to-workspace-up;
        "Mod+Ctrl+L".action = move-column-to-workspace-down;
        "Mod+Ctrl+U".action = move-column-to-workspace-up;
        "Mod+Shift+Page_Down".action = move-workspace-down;
        "Mod+Shift+Page_Up".action = move-workspace-up;
        "Mod+Shift+L".action = move-workspace-down;
        "Mod+Shift+U".action = move-workspace-up;
        "Mod+Comma".action = consume-window-into-column;
        "Mod+Period".action = expel-window-from-column;
        "Mod+P".action = switch-preset-column-width;
        "Mod+Shift+P".action = switch-preset-window-height;
        "Mod+Ctrl+P".action = reset-window-height;
        "Mod+C".action = center-column;
        "Mod+Ctrl+C".action = center-visible-columns;
        "Mod+Minus".action = set-column-width "-10%";
        "Mod+Equal".action = set-column-width "+10%";
        "Mod+Shift+Minus".action = set-window-height "-10%";
        "Mod+Shift+Equal".action = set-window-height "+10%";
      };
      outputs.DP-1 = {
        mode = {
          height = 1080;
          refresh = 239.76;
          width = 1920;
        };
        position = {
          x = 2560;
          y = 0;
        };
      };
      outputs.DP-4 = {
        mode = {
          height = 1080;
          refresh = 75.0;
          width = 2560;
        };
        position = {
          x = 0;
          y = 0;
        };
      };
      spawn-at-startup = [
        {command = ["waybar"];}
        {command = ["xwayland-satellite"];}
        {command = if !vars.isTough then ["swaybg" "-m" "fill" "-i" "/home/alyx/.config/nixos/assets/scenes.jpg"] else ["swaybg" "-m" "fill" "-i" "/home/alyx/.config/nixos/assets/scenes.jpg"];}
      ];
      environment = {
        DISPLAY = ":0";
      };
      window-rules = [
        {matches = [{title = "^launch$";}];
        open-floating = true;
        }
        {matches = [{title = "^music$";}];
        open-floating = true;
        }
        {matches = [{title = "^(Picture-in-Picture)$";}];
        open-floating = true;
        }
        {matches = [{title = "^music$";}];
        open-floating = true;
        }
        {
         geometry-corner-radius = {
           bottom-left = 12.0;
           bottom-right = 12.0;
           top-left = 12.0;
           top-right = 12.0;
         };
         draw-border-with-background = false;
         clip-to-geometry = true;
        }
      ];
      layout = {
        focus-ring = {
          enable = true;
          active = {color = "rgb(203 166 247)";};
          inactive = {color = "rgb(68 12 136)";};
        };
      };
    };
  };
}
