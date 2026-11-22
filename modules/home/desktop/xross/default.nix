{
  pkgs,
  lib,
  inputs,
  system,
  ...
}: let
  # Desktop entries, by their exact .desktop file names
  browser = "zen-twilight.desktop";
  files = "org.gnome.Nautilus.desktop";
  pdf = "org.pwmt.zathura.desktop";
  markdown = "marktext.desktop";
  text = "codium.desktop";
  # GNOME apps
  images = "org.gnome.Loupe.desktop";
  video = "org.gnome.Showtime.desktop";
  audio = "org.gnome.Decibels.desktop";
  archives = "org.gnome.FileRoller.desktop";

  # Map every mime type in `mimes` to `app`
  assoc = app: mimes: lib.genAttrs mimes (_: app);
in {
  home.packages = with pkgs; [
    swaybg
    adwaita-icon-theme
    swayidle
    sherlock-launcher
    inputs.quickshell.packages.${system}.default

    # GNOME apps, installed explicitly so xross doesn't rely on the GNOME session
    nautilus
    loupe
    showtime
    decibels
    gnome-text-editor
    file-roller
    seahorse # GUI for gnome-keyring
  ];

  # Portals: GNOME's backend first, GTK's as the fallback, gnome-keyring for secrets.
  # Note: this points NIX_XDG_DESKTOP_PORTAL_DIR at the home profile for every
  # session, so all three backends are listed here (GNOME needs them too).
  xdg.portal = {
    enable = true;
    extraPortals = with pkgs; [
      xdg-desktop-portal-gnome
      xdg-desktop-portal-gtk
      gnome-keyring
    ];
    # Written to ~/.config/xdg-desktop-portal/xross-portals.conf
    config.xross = {
      default = ["gnome" "gtk"];
      "org.freedesktop.impl.portal.Secret" = ["gnome-keyring"];
    };
  };

  # Secret Service + PKCS#11. SSH is left to gcr-ssh-agent.
  services.gnome-keyring = {
    enable = true;
    components = ["secrets" "pkcs11"];
  };

  # Plain values override the zen module's mkDefault associations
  xdg.mimeApps = {
    enable = true;
    defaultApplications = lib.mergeAttrsList [
      (assoc browser [
        "text/html"
        "application/xhtml+xml"
        "x-scheme-handler/http"
        "x-scheme-handler/https"
        "x-scheme-handler/about"
        "x-scheme-handler/unknown"
      ])
      (assoc files ["inode/directory"])
      (assoc pdf ["application/pdf"])
      (assoc markdown ["text/markdown" "text/x-markdown"])
      (assoc images [
        "image/png"
        "image/jpeg"
        "image/gif"
        "image/webp"
        "image/bmp"
        "image/tiff"
        "image/svg+xml"
        "image/avif"
        "image/heif"
        "image/jxl"
      ])
      (assoc video [
        "video/mp4"
        "video/x-matroska"
        "video/webm"
        "video/quicktime"
        "video/x-msvideo"
        "video/mpeg"
        "video/ogg"
      ])
      (assoc audio [
        "audio/mpeg"
        "audio/flac"
        "audio/ogg"
        "audio/opus"
        "audio/wav"
        "audio/x-wav"
        "audio/mp4"
        "audio/aac"
        "audio/webm"
      ])
      (assoc text [
        "text/plain"
        "application/json"
        "application/toml"
        "application/yaml"
      ])
      (assoc archives [
        "application/zip"
        "application/x-tar"
        "application/gzip"
        "application/x-compressed-tar"
        "application/x-xz-compressed-tar"
        "application/x-bzip2-compressed-tar"
        "application/x-zstd-compressed-tar"
        "application/zstd"
        "application/x-7z-compressed"
        "application/vnd.rar"
        "application/x-rar"
      ])
    ];
  };

  home.file.".config/xross/config.toml".source = ./config.toml;
  home.file.".config/xross/background.jpg".source = ./background.jpg;
  home.file.".config/sherlock/config.toml".text = ''
    [units]
    currency = "cad"
  '';
}
