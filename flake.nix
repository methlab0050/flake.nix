{
  description = "My NixOS Flake Configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-26.05";

    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixpkgs-unstable";

    nixpkgs-rolling.url = "github:cachix/devenv-nixpkgs/rolling";

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

    claude-code = {
      url = "github:sadjow/claude-code-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    sonoma-lockscreen = {
      url = "github:methlab0050/wack-sonoma-lockscreen";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    bigsur-sound-theme = {
      url = "github:gxanshu/macos-bigsur-sound-theme-linux";
      flake = false;
    };

    devenv = {
      url = "github:cachix/devenv";
    };

    quickshell = {
      # add ?ref=<tag> to track a tag
      url = "git+https://git.outfoxxed.me/outfoxxed/quickshell";

      # THIS IS IMPORTANT
      # Mismatched system dependencies will lead to crashes and other issues.
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = {
    nixpkgs,
    home-manager,
    ...
  } @ inputs: let
    system = "x86_64-linux";
    # Change this eventually
    hostName = "nixos";
    pkgs = nixpkgs.legacyPackages.${system};
    specialArgs = {
      inherit inputs;
      inherit hostName;
      inherit system;
      pkgs_rolling = inputs.nixpkgs-rolling.legacyPackages.${system};
    };
  in {
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
