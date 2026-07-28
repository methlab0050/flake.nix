{pkgs, ...}: {
  home.packages = with pkgs; [
    onlyoffice-desktopeditors
    libreoffice-fresh
    hunspell
    hunspellDicts.en_US
    hunspellDicts.en_CA
  ];
}
