{ pkgs, lib, ... }:

{
  programs.waybar = {
    enable = true;
  };

  home.packages = with pkgs; [
    swaybg
  ] ++ (lib.optional (pkgs ? noctalia) pkgs.noctalia);

  programs.niri = {
    enable = true;
    settings = {
      spawn-at-startup = [
        { command = [ "waybar" ]; }
        { command = [ "noctalia" ]; }
        { command = [ "${pkgs.swaybg}/bin/swaybg" "-i" "${./background.jpg}" "-m" "fill" ]; }
      ];
      binds = {
        "Mod+Return".action.spawn = [ "ghostty" ];
        "Mod+T".action.spawn = [ "ghostty" ];
      };
    };
  };
}