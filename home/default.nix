{
  pkgs,
  inputs,
  system,
  ...
}:
{

  imports = [
    ./gnome
    # ./niri
  ];
  
  home.stateVersion = "26.05";
  home.username = "mehtabs";
  home.homeDirectory = "/home/mehtabs";

  # programs.home-manager.enable = true;

  home.packages = [
    inputs.antigravity-nix.packages.${system}.google-antigravity-cli
    pkgs.mission-center
    pkgs.discord
  ];

}
