{pkgs, ...}: {
  imports = [
    ./apps
    ./desktop
    ./shell
  ];

  nixpkgs.config.allowUnfree = true;

  home.stateVersion = "26.05";
  home.username = "mehtabs";
  home.homeDirectory = "/home/mehtabs";

  programs.home-manager.enable = true;

  home.packages = with pkgs; [
    mission-center
    discord
    imhex
    inkscape
    godot
    nil
  ];
}
