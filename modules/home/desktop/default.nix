{ ... }: {
  imports = [
    ./gnome
  ];

  targets.genericLinux.enable = true;
  xdg.enable = true;
  xdg.mime.enable = true;
}
