{pkgs, ...}: {
  home.packages = with pkgs; [
    ghostty
  ];

  home.file.".config/ghostty/config.ghostty".source = ./config.ghostty;
}
