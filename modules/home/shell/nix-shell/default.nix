{pkgs-unstable, ...}: {
  home.packages = [
    pkgs-unstable.devenv
  ];

  programs.direnv.enable = true;
}
