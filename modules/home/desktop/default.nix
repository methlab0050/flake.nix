{
  inputs,
  pkgs,
  lib,
  ...
}: let
  sonomaMeta = builtins.fromJSON (builtins.readFile "${inputs.sonoma-lockscreen}/metadata.json");

  sonoma-lockscreen = pkgs.stdenvNoCC.mkDerivation {
    pname = "wack-sonoma-lockscreen";
    version = "unstable";
    extensionUuid = sonomaMeta.uuid;

    src = inputs.sonoma-lockscreen;

    dontBuild = true;

    installPhase = ''
      runHook preInstall
      mkdir -p $out/share/gnome-shell/extensions/${sonoma-lockscreen.extensionUuid}
      cp -r * $out/share/gnome-shell/extensions/${sonoma-lockscreen.extensionUuid}/
      runHook postInstall
    '';
  };

  extensions = with pkgs.gnomeExtensions; [
    advanced-alttab-window-switcher
    dash-to-dock
    custom-hot-corners-extended
    sonoma-lockscreen
  ];
in {
  home.packages = with pkgs;
    [
      gnome-tweaks
      colloid-icon-theme
    ]
    ++ extensions;

  xdg.dataFile = {
    "sounds/bigsur".source = "${inputs.bigsur-sound-theme}/theme/bigsur";
  };

  home.file = {
    ".config/wayland-scroll-factor/config" = {
      text = ''
        factor=0.1000
        scroll_vertical_factor=0.5000
        scroll_horizontal_factor=0.5000
      '';
    };
  };

  dconf.settings = {
    # GNOME Appearance & Theme Settings
    "org/gnome/desktop/background" = {
      picture-uri = "file:///${./background.png}";
      picture-uri-dark = "file:///${./background.png}";
    };

    "org/gnome/desktop/interface" = {
      clock-format = "12h";
      enable-hot-corners = false;
      icon-theme = "Colloid";
      show-battery-percentage = true;
    };

    "org/gnome/desktop/sound" = {
      event-sounds = true;
      theme-name = "bigsur";
    };

    "org/gnome/desktop/wm/preferences" = {
      button-layout = ":minimize,maximize,close";
    };

    # GNOME Shell Layout & Launcher Settings
    "org/gnome/shell" = {
      enabled-extensions = map (ext: ext.extensionUuid) extensions;
      favorite-apps = [
        "com.mitchellh.ghostty.desktop"
        "org.gnome.Nautilus.desktop"
        "codium.desktop"
        "zen-beta.desktop"
      ];
    };

    # GNOME Extensions Configuration
    "org/gnome/shell/extensions/advanced-alt-tab-window-switcher" = {
      hotkey-above = "A";
      hotkey-close-all-app = "C";
      hotkey-close-quit = "W";
      hotkey-down = "J";
      hotkey-favorites = "O";
      hotkey-fs-on-new-ws = "F";
      hotkey-group-ws = "G";
      hotkey-left = "H";
      hotkey-maximize = "M";
      hotkey-minimize = "D";
      hotkey-move-win-to-monitor = "X";
      hotkey-new-win = "N";
      hotkey-prefs = "P";
      hotkey-right = "L";
      hotkey-search = "E";
      hotkey-single-app = "1+";
      hotkey-sticky = "S";
      hotkey-switch-filter = "Q";
      hotkey-switcher-mode = "Z";
      hotkey-thumbnail = "T";
      hotkey-up = "K";
      switcher-popup-interactive-indicators = false;
      switcher-popup-monitor = 3;
      switcher-popup-second-tab-switch-filter = false;
      switcher-popup-show-if-no-win = false;
      switcher-popup-start-search = false;
      switcher-popup-status = false;
      switcher-popup-sync-filter = true;
      switcher-popup-theme = 1;
      switcher-popup-tooltip-title = 1;
      switcher-popup-wrap = true;
      switcher-ws-thumbnails = 2;
      win-switch-mark-minimized = false;
      win-switch-minimized-to-end = false;
      win-switcher-popup-filter = 3;
      win-switcher-popup-icon-size = 48;
      win-switcher-popup-order = 2;
      win-switcher-popup-preview-size = 192;
      win-switcher-popup-search-all = true;
      win-switcher-popup-sorting = 1;
      win-switcher-popup-titles = 1;
      win-switcher-popup-ws-indexes = false;
    };

    "org/gnome/shell/extensions/dash-to-dock" = {
      animation-time = 0.1;
      autohide = true;
      autohide-in-fullscreen = true;
      background-opacity = 0.8;
      click-action = "minimize-or-overview";
      custom-theme-shrink = true;
      customize-alphas = true;
      dash-max-icon-size = 48;
      dock-position = "BOTTOM";
      extend-height = false;
      height-fraction = 0.9;
      hide-delay = 0.05;
      intellihide-mode = "FOCUS_APPLICATION_WINDOWS";
      isolate-monitors = true;
      isolate-workspaces = true;
      max-alpha = 0.6;
      min-alpha = 0.4;
      multi-monitor = true;
      preferred-monitor = -2;
      preferred-monitor-by-connector = "eDP-1";
      pressure-threshold = 0.0;
      require-pressure-to-show = true;
      scroll-action = "cycle-windows";
      shift-click-action = "minimize";
      show-delay = 0.25;
      show-dock-urgent-notify = true;
      transparency-mode = "DYNAMIC";
    };

    "org/gnome/shell/extensions/wack-lockscreen-clock" = {
      cupertino-always-show-user = true;
      enable-unblank = false;
      esc-to-sleep = true;
      lockscreen-mode = "wack";
    };

    "org/gnome/shell/extensions/custom-hot-corners-extended/misc" = {
      keyboard-shortcuts = [
        "reorder-ws-prev <Control><Super>Left"
        "reorder-ws-next <Control><Super>Right"
      ];
      show-osd-monitor-indexes = false;
      supported-active-extensions = ["aatws"];
      panel-menu-enable = false;
    };

    # System & Desktop Functionality
    "org/gnome/desktop/input-sources" = {
      sources = [
        (lib.gvariant.mkTuple [
          "xkb"
          "us"
        ])
      ];
    };

    "org/gnome/desktop/media-handling" = {
      autorun-never = true;
    };

    "org/gnome/mutter" = {
      experimental-features = [
        "scale-monitor-framebuffer"
        "xwayland-native-scaling"
      ];
    };

    "org/gnome/desktop/peripherals/touchpad" = {
      click-method = "areas";
      two-finger-scrolling-enabled = true;
    };

    # Window Manager & Shell Keybindings
    "org/gnome/desktop/wm/keybindings" = {
      minimize = [];
      raise-or-lower = ["<Super>m"];
      switch-applications = [];
      switch-applications-backward = [];
      switch-to-workspace-down = ["disabled"];
      switch-to-workspace-left = ["<Alt><Super>Left"];
      switch-to-workspace-right = ["<Alt><Super>Right"];
      switch-to-workspace-up = ["disabled"];
      switch-windows = ["<Super>Tab"];
      switch-windows-backward = ["<Shift><Super>Tab"];
    };

    "org/gnome/shell/keybindings" = {
      show-screenshot-ui = ["<Shift><Super>s"];
      toggle-message-tray = ["<Super>v"];
    };
  };
}
