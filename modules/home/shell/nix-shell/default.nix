{
  inputs,
  pkgs,
  ...
}: {
  nixpkgs.overlays = [
    inputs.devenv.overlays.default
  ];
  home.packages = [
    pkgs.devenv
  ];

  programs.direnv.enable = true;
}
