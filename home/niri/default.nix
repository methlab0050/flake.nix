{ pkgs, lib, ... }:

{
  home.file.".config/niri/config-original.kdl".source = "${pkgs.niri}/share/doc/niri/config.kdl";

  programs.waybar = {
    enable = true;
  };

  home.packages = with pkgs; [
    swaybg
    xwayland-satellite
    noctalia-shell
  ];

  home.file.".config/niri/config.kdl" = {
    force = true;
    text = ''
      spawn-at-startup "waybar"
      spawn-at-startup "noctalia-shell"
      spawn-at-startup "xwayland-satellite"
      spawn-at-startup "${pkgs.swaybg}/bin/swaybg" "-i" "${./background.jpg}" "-m" "fill"

      binds {
          Mod+Return { spawn "ghostty"; }
          Mod+T { spawn "ghostty"; }
      }

      input {
        touchpad {
          natural-scroll
        }
      }
    '';
  };
}
