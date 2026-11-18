{
  pkgs,
  inputs,
  system,
  ...
}: {
  home.packages = with pkgs; [
    swaybg
    adwaita-icon-theme
    swayidle
    sherlock-launcher
    inputs.quickshell.packages.${system}.default
  ];

  home.file.".config/xross/config.toml".source = ./config.toml;
  home.file.".config/xross/background.jpg".source = ./background.jpg;
  home.file.".config/sherlock/config.toml".text = ''
    [units]
    currency = "cad"
  '';
}
