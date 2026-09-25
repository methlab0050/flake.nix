{
  inputs,
  pkgs,
  ...
}: {
  packages = [
    inputs.co.packages.${pkgs.stdenv.system}.default
  ];

  # Git pre-commit hooks
  git-hooks.hooks = {
    alejandra.enable = true;
    deadnix.enable = true;
  };
}
