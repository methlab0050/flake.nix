{...}: {
  # Enable Nix experimental features
  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # Enable nh helper
  programs.nh.enable = true;
}
