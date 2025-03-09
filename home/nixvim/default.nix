{vars, lib, ...}:{
  programs.nixvim = {
    enable = true;
    colorschemes.catppuccin.enable = true;
    colorschemes.catppuccin.settings.flavour = "mocha";
    plugins = { 
      treesitter.enable = true;
      fidget.enable = true; 
      lualine.enable = true;
      lualine.settings.options.theme = "dracula";
      cmp = {
        enable = true;
        settings = {
	  performance.throttle = 30;
          sources = [{name = "nvim_lsp";}{name = "luasnip";}{name = "path";}{name = "buffer";}];
	  mapping = {
	    "<Tab>" = "cmp.mapping.select_next_item()";
	    "<S-Tab>" = "cmp.mapping.select_prev_item()";
	    "<C-space>" = "cmp.mapping.confirm({ select = false })";
	  };
	};
      };
      lsp = {
        enable = true;

	servers.nixd = {
	  enable = true;
	  extraOptions.offset_encoding = "utf-8";
	  settings.nixpkgs.expr = "import <nixpkgs>{}";
	  settings.options = {
	    nixos.expr = "(builtins.getFlake \"/home/${vars.user}/.config/nixos\").nixosConfigurations.apollo.options";
	    home-manager.expr = "(builtins.getFlake \"/home/${vars.user}/.config/nixos\").homeConfigurations.generic.options"; 
	    nixvim.expr = "(builtins.getFlake \"/home/${vars.user}/.config/nixos\").homeConfigurations.generic.options.programs.nixvim.type.getSubOptions []";
	  };
	};
      };
    };
  };
}
