{
  pkgs,
  lib,
  ...
}: {
  home.packages = with pkgs; [
    vim
  ];

  home.activation.copyVimrc = lib.hm.dag.entryAfter ["writeBoundary"] ''
    if [ ! -e "$HOME/.vimrc" ]; then
      $DRY_RUN_CMD cp ${./.vimrc} "$HOME/.vimrc"
      $DRY_RUN_CMD chmod u+w "$HOME/.vimrc"
    fi
  '';
}
