{...}: {
  # Formatter configuration
  treefmt = {
    enable = true;
    config.programs.alejandra.enable = true;
  };

  # Git pre-commit hooks
  git-hooks.hooks = {
    alejandra.enable = true;
  };
}
