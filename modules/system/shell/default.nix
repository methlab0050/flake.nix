{...}: {
  imports = [
    ./fish.nix
  ];

  xdg.terminal-exec = {
    enable = true;
    settings.default = ["ghostty.desktop"];
  };
}
