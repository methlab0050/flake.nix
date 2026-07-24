{inputs, system, pkgs, ...}: {
  home.packages = [
    inputs.antigravity-nix.packages.${system}.google-antigravity-cli
    pkgs.xclip
  ];
}