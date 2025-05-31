{pkgs, vars, ...}:{
  home.packages = with pkgs; [
    prismlauncher
    clonehero
    cinny-desktop
    blender-hip
    mpc
    kanshi
    emacs
    comma
    osu-lazer-bin
    grayjay
    gzdoom
    wttrbar
    openrct2
    inkscape
    hyfetch
    fastfetch
    pamixer
    pavucontrol
    gimp
    tetrio-desktop
    timidity
    transmission_4-qt
    vesktop
    ripcord
    vlc
    playerctl
    librewolf
    v4l-utils
  ] ++ (if vars.class != "handheld" then [gamescope libgpod bs-manager libimobiledevice strawberry openscad openutau wlr-randr grim slurp grimblast swaynotificationcenter udiskie gtklock swaybg fzf wl-clipboard brightnessctl nemo xfce.ristretto xfce.tumbler] else []);
}
