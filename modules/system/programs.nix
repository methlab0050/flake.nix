{
  pkgs,
  inputs,
  system,
  ...
}: {
  programs.steam.enable = true;

  environment.systemPackages = with inputs; [
    helium.defaultPackage.${system}
  ];

  fonts.packages = with pkgs.nerd-fonts; [
    arimo
    tinos
    caskaydia-mono
  ];
}
