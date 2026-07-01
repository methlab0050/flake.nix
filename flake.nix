{
  description = "My NixOS Flake Configuration";
  
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-26.05"; 
    
    wsf = {
      url = "github:daniel-g-carrasco/wayland-scroll-factor";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-vscode-extensions = {
      url = "github:nix-community/nix-vscode-extensions";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nh = {
      url = "github:nix-community/nh";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    helium = {
      url = "github:FKouhai/helium2nix/main";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nil = {
      url = "github:oxalica/nil";
    };

    zen-browser = {
      url = "github:0xc000022070/zen-browser-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    winapps = {
      url = "github:winapps-org/winapps";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, nixos-hardware, ... } @ inputs: {
    # Replace "nixos" here with your machine's actual hostname.
    # You can find your hostname in configuration.nix under `networking.hostName`
    nixosConfigurations.nixos = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [
        nixos-hardware.nixosModules.framework-13th-gen-intel
        ({inputs, ...}: { 
          imports = [inputs.wsf.nixosModules.default];
          programs.wsf.enable = true;
          programs.nh.enable = true;
        })
        inputs.home-manager.nixosModules.default
        {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.extraSpecialArgs = { inherit inputs; };
            home-manager.users.mehtabs = ./home.nix;
        }
        
        # This line is where your existing configuration gets imported!
        ./configuration.nix 
      ];

      specialArgs = {
        inherit inputs;
      };
    };
  };
}
