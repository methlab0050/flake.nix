{
  inputs,
  system,
  pkgs,
  ...
}: {
  home.packages = [
    inputs.antigravity-nix.packages.${system}.google-antigravity-cli
    inputs.claude-code.packages.${pkgs.stdenv.system}.default
    pkgs.xclip
  ];
}
