{inputs, ...}: {
  imports = [
    inputs.zen-browser.homeModules.beta
  ];

  programs.zen-browser = {
    enable = true;
    setAsDefaultBrowser = true;
    env = {
      MOZ_ENABLE_WAYLAND = "1";
    };
  };
}
