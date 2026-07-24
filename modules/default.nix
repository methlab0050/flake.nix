{ inputs, system, hostName, ... }: {
  imports = [
    ./system
    inputs.home-manager.nixosModules.default
  ];

  home-manager.useGlobalPkgs = true;
  home-manager.useUserPackages = true;
  home-manager.extraSpecialArgs = {
    inherit inputs;
    inherit system;
    inherit hostName;
  };
  home-manager.users.mehtabs = ./home;
}
