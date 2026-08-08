{
  pkgs,
  inputs,
  system,
  ...
}: {
  programs.steam.enable = true;

  environment.systemPackages = with inputs; [
    helium.defaultPackage.${system}
    zen-browser.packages.${system}.default
  ];

  fonts.packages = with pkgs.nerd-fonts; [
    arimo
    tinos
    caskaydia-mono
  ];
}
