{
  description = "My NixOS Flake Configuration";
  
  inputs = {
    # You might want to change this branch to match the version of NixOS you are currently using, 
    # e.g., "github:NixOS/nixpkgs/nixos-23.11" or "nixos-24.05".
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-26.05"; 
    
    wsf = {
      url = "github:daniel-g-carrasco/wayland-scroll-factor";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { nixpkgs, wsf, ... }: {
    # Replace "nixos" here with your machine's actual hostname.
    # You can find your hostname in configuration.nix under `networking.hostName`
    nixosConfigurations.nixos = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [
        wsf.nixosModules.default
        { programs.wsf.enable = true; }
        
        # This line is where your existing configuration gets imported!
        ./configuration.nix 
      ];
    };
  };
}
