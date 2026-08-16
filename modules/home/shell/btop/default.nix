{pkgs, ...}: {
  home.packages = with pkgs; [
    btop
  ];

  home.file.".config/btop/btop.conf".source = ./btop.conf;
}
