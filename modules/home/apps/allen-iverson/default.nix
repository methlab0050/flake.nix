{
  inputs,
  system,
  pkgs,
  ...
}: {
  home.packages = [
    inputs.antigravity-nix.packages.${system}.google-antigravity-cli
    inputs.claude-code.packages.${system}.default
    pkgs.xclip
  ];
}
