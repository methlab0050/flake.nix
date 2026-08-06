{pkgs, ...}: {
  home.packages = [
    pkgs.devenv
  ];

  programs.direnv.enable = true;
}