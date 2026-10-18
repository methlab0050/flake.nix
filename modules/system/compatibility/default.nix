{...}: {
  imports = [
    ./iphone.nix
    ./windows.nix
  ];

  programs.steam.enable = true;
}
