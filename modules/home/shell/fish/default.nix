{pkgs, ...}: {
  home.packages = [pkgs.fish];

  home.file.".config/fish" = {
    source = ./config;
    recursive = true;
  };
}
