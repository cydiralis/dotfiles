{pkgs, ...}:{
  fonts.packages = with pkgs; [
    font-awesome
    jetbrains-mono
    nerd-fonts.iosevka
    noto-fonts
    noto-fonts-cjk-sans
    noto-fonts-emoji
    source-han-sans
    source-han-sans-japanese
    source-han-serif-japanese
    comfortaa
  ];
}
