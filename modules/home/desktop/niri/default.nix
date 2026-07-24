{ pkgs, lib, ... }:

{
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
          Mod { toggle-overview; }
      }

      input {
        touchpad {
          natural-scroll
        }
      }
    '';
  };
}
