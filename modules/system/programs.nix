{
  pkgs,
  inputs,
  system,
  ...
}: {
  programs.direnv.enable = true;
  programs.git.enable = true;
  programs.steam.enable = true;

  environment.systemPackages = with pkgs;
    [
      imhex
      inputs.helium.defaultPackage.${system}
      inkscape
      godot
    ]
    ++ (map (pkg: pkg.packages.${system}.default) (
      with inputs; [
        nil
        zen-browser
      ]
    ));

  fonts.packages = with pkgs.nerd-fonts; [
    arimo
    tinos
    caskaydia-mono
  ];
}
