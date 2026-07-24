{config, pkgs, ...}: {
  programs.niri.enable = true;
  services.greetd = {
    enable = true;
    settings = {
      default_session = {
        command = "${config.programs.niri.package}/bin/niri-session";
        user = "mehtabs";
      };
    };
  };

  security.polkit.enable = true;

  systemd.user.services.niri.enableDefaultPath = false;

  environment.systemPackages = [
    pkgs.alacritty
  ];
}