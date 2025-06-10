{lib, osConfig, pkgs, inputs, vars, ...}:{
  wayland.windowManager.hyprland.enable = true;
  wayland.windowManager.hyprland.package = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.hyprland;
  wayland.windowManager.hyprland.portalPackage = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.xdg-desktop-portal-hyprland;
  wayland.windowManager.hyprland.settings = {

  exec-once = [
    "swaybg -m fill -i ~/.config/nixos/assets/scenes.jpg"
    "dbus-update-activation-environment --systemd DISPLAY WAYLAND-DISPLAY"
    "bash ~/.config/lockonsleep/config.sh"
    "waybar"
  ];

  monitor = [
#    "HDMI-A-1, 1920x1080,2095x1080,1"
    "DP-1, 1920x1080@239.760,2560x0,1"
    "DP-4, 2560x1080@75, 0x0,1"
#    "eDP-2, 2560x1600@165,0x0,1.066667"
  ];

  workspace = [
    "1, monitor:DP-1"
  ];

  "env" = [
    "HYPRCURSOR_SIZE,24"
  ];

  "$mod" = "SUPER";
  input = {
    kb_layout = "gb";
    follow_mouse = 1;
    touchpad.natural_scroll = "yes";
    sensitivity = 0.75;
    accel_profile = "flat";
  };

  device = [
    {
      name = "at-translated-set-2-keyboard";
      kb_layout = "gb";
      kb_variant = "colemak";
    }
    {
      name = "obins-anne-pro-2-c18-(qmk)";
      kb_layout = "us";
    }
  ];

  general = {
    gaps_in = 5;
    gaps_out = 20;
    border_size = 2;
    "col.active_border" = "rgba(cba6f7ff) rgba(cba6f7ff) 45deg";
    "col.inactive_border" = "rgba(440C88FF)";
    layout = "dwindle";
  };

  decoration = {
    rounding = 10;
    blur = {
      enabled = true;
      size = 8;
      passes = 1;
      new_optimizations = 1;
    };
    dim_inactive = true;
    #drop_shadow = "no";
    #shadow_range = 4;
    #shadow_render_power = 3;
    #"col.shadow" = "rgba(1a1a1aee)";
  };

  windowrulev2 = [
    "float, title:^(Picture-in-Picture)$"
    "float, title:^launch$"
    "float, title:^music$"
    "size 30% 35%, title:^launch$"
    "size 30% 35%, title:^music$"
    "pin, title:^(Picture-in-Picture)$"
    "move 67% 72%, title:^(Picture-in-Picture)$"
    "size 33% 28%, title:^(Picture-in-Picture)$"
    "opacity 0.9, class:^foot$"
  ];

  animations = {
    enabled = true;
    bezier = "myBezier, 0.05, 0.9, 0.1, 1.05";
    animation = [
      "windows, 1, 7, myBezier"
      "windowsOut, 1, 7, default, popin 80%"
      "border, 1, 10, default"
      "borderangle, 1, 8, default"
      "fade, 1, 7, default"
      "workspaces, 1, 6, default"
    ];
  };

  dwindle = {
    pseudotile = true;
    preserve_split = "yes";
  };

  master = {
    new_status = "master";
  };

  gestures = {
    workspace_swipe = true;
  };

  misc = {
    disable_hyprland_logo = false;
  };

  binde = [
    # Volume stuffs
    ", XF86AudioRaiseVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+"
    ", XF86AudioLowerVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"
    ", XF86AudioMute, exec, wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"
  ];
  bind = [
    # basic binds
    "$mod, Return, exec, foot"
    "$mod SHIFT, Q, killactive, "
    "$mod SHIFT, space, togglefloating, "
    "$mod, S, exec, exec foot --title launch --app-id fzf-launcher-foot bash -c 'compgen -c | sort -u | fzf | xargs hyprctl dispatch exec --'"
    "$mod, T, exec, foot --title music --app-id mpd-control-foot ncmpcpp"
    "$mod, E, exec, nemo"
    "$mod, ;, pseudo,"
    "$mod, N, togglesplit,"
    "$mod, L, exec, hyprlock"
    "$mod SHIFT, E, exec, hyprctl dispatch exit"
    ", Print ,exec, XDG_SCREENSHOTS_DIR=$HOME/Pictures/screenshots grimblast copysave area"
    "$mod, left, movewindow, l"
    "$mod, right, movewindow, r"
    "$mod, up, movewindow, up"
    "$mod, down, movewindow, down"
    "$mod, F, fullscreen"
    # Switch workspaces
    "$mod, 1, workspace, 1"
    "$mod, 2, workspace, 2"
    "$mod, 3, workspace, 3"
    "$mod, 4, workspace, 4"
    "$mod, 5, workspace, 5"
    "$mod, 6, workspace, 6"
    "$mod, 7, workspace, 7"
    "$mod, 8, workspace, 8"
    "$mod, 9, workspace, 9"
    # Move a window to a given workspace
    "$mod SHIFT, 1, movetoworkspace, 1"
    "$mod SHIFT, 2, movetoworkspace, 2"
    "$mod SHIFT, 3, movetoworkspace, 3"
    "$mod SHIFT, 4, movetoworkspace, 4"
    "$mod SHIFT, 5, movetoworkspace, 5"
    "$mod SHIFT, 6, movetoworkspace, 6"
    "$mod SHIFT, 7, movetoworkspace, 7"
    "$mod SHIFT, 8, movetoworkspace, 8"
    "$mod SHIFT, 9, movetoworkspace, 9"
    # Use mouse to scroll through existing workspaces
    "$mod, mouse_down, workspace, e+1"
    "$mod, mouse_up, workspace, e-1"
  ];
  bindm = [
    "$mod, mouse:272, movewindow"
    "$mod, mouse:273, resizewindow"
  ];
};
}
