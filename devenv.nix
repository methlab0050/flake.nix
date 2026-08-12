{pkgs, ...}: {
  # Formatter configuration
  treefmt = {
    enable = true;
    config.programs.alejandra.enable = true;
  };

  # Git pre-commit hooks
  pre-commit.hooks = {
    alejandra.enable = true;
  };
}
