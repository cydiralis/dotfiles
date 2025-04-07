{
  description = "various system flakes";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixgl.url = "github:nix-community/nixGL";
    nixpkgs-xr.url = "github:nix-community/nixpkgs-xr";
    jovian.url = "github:Jovian-Experiments/Jovian-NixOS";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    catppuccin.url = "github:catppuccin/nix";
    nixvim.url = "github:nix-community/nixvim";
    nix-index-database.url = "github:nix-community/nix-index-database";
    nix-index-database.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = inputs@{ self, nixpkgs, nixpkgs-xr, home-manager, jovian, ...}:{
    nixosConfigurations."Absolution" = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [
        ./base/Absolution
        nixpkgs-xr.nixosModules.nixpkgs-xr
	home-manager.nixosModules.home-manager {
	  #imports = [ inputs.nix-index-database.hmModules.nix-index ];
          home-manager.backupFileExtension = "hm-backup";
	  home-manager.extraSpecialArgs = {
	    inherit inputs;
	    vars = {
	      isNixOS = true;
	      class = "desktop";
              user = "alyx"; #cursed way of setting username
	    };
	  };
	  home-manager.useGlobalPkgs = true;
	  home-manager.useUserPackages = true;
	  home-manager.users.alyx = ./home;
	}
      ];
    };
    nixosConfigurations."Ishima" = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [
        ./base/Ishima
        nixpkgs-xr.nixosModules.nixpkgs-xr
        jovian.nixosModules.jovian
        home-manager.nixosModules.home-manager {
          home-manager.backupFileExtension = "hm-backup";
          #imports = [ inputs.nix-index-database.hmModules.nix-index ];
          home-manager.extraSpecialArgs = {
            inherit inputs;
            vars = {
              isNixOS = true;
              isDeck = true;
              class = "desktop";
              user = "alyx"; #cursed way of setting username
            };
          };
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.users.alyx = ./home;
        }
      ];
    };    
    #other confs go here, cant be assed rn
    homeConfigurations.generic = home-manager.lib.homeManagerConfiguration {
      pkgs = import nixpkgs { system = "x86_64-linux"; overlays = [inputs.nixgl.overlay]; };
      modules = [ ./home ];
      extraSpecialArgs = { 
        inherit inputs; 
        vars = {
          isNixOS = false;
          class = "laptop";
          user = "alyx";
        };
      };
    };
  };
}
