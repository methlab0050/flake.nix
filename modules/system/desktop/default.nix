{inputs, ...}: {
  imports = [
    inputs.wsf.nixosModules.default
  ];
  # Enable the GNOME Desktop Environment.
  services.displayManager.gdm.enable = true;
  services.desktopManager.gnome.enable = true;
  programs.wsf.enable = true;
}
