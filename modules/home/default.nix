{
  pkgs,
  pkgs_rolling,
  ...
}: {
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
    discord
    imhex
    inkscape
    pkgs_rolling.godot
    # j
    zathura
    tree
    deno
    torcs
    pkgs_rolling.marktext
  ];
}
