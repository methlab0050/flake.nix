{
  inputs,
  pkgs,
  ...
}: {
  packages = [
    inputs.co.packages.${pkgs.stdenv.system}.default
    inputs.nix-inspect.packages.${pkgs.stdenv.system}.default
  ];

  scripts.inspect.exec = "nix-inspect";

  treefmt = {
    enable = true;
    config.programs = {
      alejandra.enable = true;
      deadnix.enable = true;
    };
  };

  scripts.fmt.exec = "treefmt";

  # Git pre-commit hooks
  git-hooks.hooks = {
    alejandra.enable = true;
    deadnix.enable = true;
  };
}
