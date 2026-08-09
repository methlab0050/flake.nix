{
  description = "My NixOS Flake Configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-26.05";

    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixpkgs-unstable";

    nixos-hardware = {
      url = "github:NixOS/nixos-hardware";
      inputs.nixpkgs.follows = "nixpkgs";
    };

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

    zen-browser = {
      url = "github:0xc000022070/zen-browser-flake";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
      inputs.home-manager.follows = "home-manager";
    };

    home-manager = {
      type = "github";
      owner = "nix-community";
      repo = "home-manager";
      # home-manager keeps giving warnings about the release version,
      # so I found the ref with the corresponding version
      ref = "backport/release-26.05/9551";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    antigravity-nix = {
      url = "github:jacopone/antigravity-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    sonoma-lockscreen = {
      url = "github:rinzler69-wastaken/wack-sonoma-lockscreen";
      flake = false;
    };

    bigsur-sound-theme = {
      url = "github:gxanshu/macos-bigsur-sound-theme-linux";
      flake = false;
    };
  };

  outputs = {
    self,
    nixpkgs,
    nixpkgs-unstable,
    home-manager,
    ...
  } @ inputs: let
    system = "x86_64-linux";
    # Change this eventually
    hostName = "nixos";
    pkgs = nixpkgs.legacyPackages.${system};
    pkgs-unstable = nixpkgs-unstable.legacyPackages.${system};
    specialArgs = {
      inherit inputs;
      inherit hostName;
      inherit system;
      inherit pkgs-unstable;
    };
  in {
    formatter.${system} = pkgs.alejandra;

    # Replace "nixos" here with your machine's actual hostname.
    # You can find your hostname in configuration.nix under `networking.hostName`
    nixosConfigurations.nixos = nixpkgs.lib.nixosSystem {
      inherit system;
      inherit specialArgs;
      modules = [
        ./hosts/framework
        ./modules/system
      ];
    };

    homeConfigurations.mehtabs = home-manager.lib.homeManagerConfiguration {
      inherit pkgs;
      extraSpecialArgs = specialArgs;
      modules = [
        ./modules/home
      ];
    };
  };
}
