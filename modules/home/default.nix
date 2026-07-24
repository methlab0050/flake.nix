{
  pkgs,
  inputs,
  system,
  ...
}:
{

  imports = [
    ./apps
    ./desktop
    ./shell
  ];
  
  home.stateVersion = "26.05";
  home.username = "mehtabs";
  home.homeDirectory = "/home/mehtabs";

  # programs.home-manager.enable = true;

  home.packages = [
    pkgs.mission-center
    pkgs.discord
  ];

}
