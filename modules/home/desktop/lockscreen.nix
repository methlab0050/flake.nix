{
  inputs,
  pkgs,
}: let
  sonomaMeta = builtins.fromJSON (builtins.readFile "${inputs.sonoma-lockscreen}/metadata.json");

  extensionUuid = sonomaMeta.uuid;
in
  pkgs.stdenvNoCC.mkDerivation {
    inherit extensionUuid;
    pname = "wack-sonoma-lockscreen";
    version = "unstable";

    src = inputs.sonoma-lockscreen;

    nativeBuildInputs = [
      pkgs.glib
    ];

    dontBuild = true;

    installPhase = ''
      runHook preInstall
      mkdir -p $out/share/gnome-shell/extensions/${extensionUuid}
      cp -r * $out/share/gnome-shell/extensions/${extensionUuid}/
      glib-compile-schemas $out/share/gnome-shell/extensions/${extensionUuid}/schemas
      runHook postInstall
    '';
  }
