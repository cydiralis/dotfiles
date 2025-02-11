{pkgs, ...}:{
  home.pointerCursor = {
    gtk.enable = true;
    x11.enable = true;
    package = pkgs.catppuccin-cursors.mochaMauve;
    name = "catppuccin-mocha-mauve-cursors";
    size = 24;
  };
  catppuccin = {
    enable = true;
    gtk.enable = false;
    kvantum.enable = true;
    waybar.enable = false;
  };
  gtk = {
    #catppuccin.enable = false;
    enable = true;
    theme = {
      name = "catppuccin-mocha-mauve-standard";
      package = pkgs.catppuccin-gtk.override {
        accents = ["mauve"];
	size = "standard";
	variant = "mocha";
      };
    };
    iconTheme.package = pkgs.adwaita-icon-theme;
    iconTheme.name = "Adwaita";
  };
  qt = {
    enable = true;
    style.name = "kvantum";
    #style.catppuccin.enable = true;
    platformTheme.name = "kvantum";
  };
}
