{
  inputs,
  pkgs,
  lib,
  ...
}:
{
  home.packages = with pkgs; [
    gnome-tweaks
    colloid-icon-theme
    gnomeExtensions.advanced-alttab-window-switcher
    gnomeExtensions.dash-to-dock
  ];

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
      picture-options = "zoom";
      picture-uri = "file:///${./background.png}";
      picture-uri-dark = "file:///${./background.png}";
    };
    # TODO - config background

    "org/gnome/desktop/interface" = {
      accent-color = "blue";
      clock-format = "12h";
      color-scheme = "default";
      enable-hot-corners = false;
      gtk-theme = "Adwaita";
      icon-theme = "Colloid";
      locate-pointer = false;
      show-battery-percentage = true;
      text-scaling-factor = 1.0;
    };

    "org/gnome/desktop/sound" = {
      event-sounds = true;
      theme-name = "bigsur";
    };
    "org/gnome/desktop/wm/preferences" = {
      auto-raise = false;
      button-layout = ":minimize,maximize,close";
      focus-mode = "click";
    };

    # GNOME Shell Layout & Launcher Settings
    "org/gnome/shell" = {
      command-history = [ "r" ];
      enabled-extensions = [
        "dash-to-dock@micxgx.gmail.com"
        "wack-lockscreen-clock@rinzler69-wastaken.github.com"
        "advanced-alt-tab@G-dH.github.com"
      ];
      favorite-apps = [
        "com.mitchellh.ghostty.desktop"
        "org.gnome.Nautilus.desktop"
        "codium.desktop"
        "zen-beta.desktop"
      ];
      last-selected-power-profile = "power-saver";
      welcome-dialog-last-shown-version = "50.1";
    };

    "org/gnome/tweaks" = {
      show-extensions-notice = false;
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
      always-center-icons = false;
      animation-time = 0.1;
      apply-custom-theme = false;
      autohide = true;
      autohide-in-fullscreen = true;
      background-opacity = 0.8;
      click-action = "minimize-or-overview";
      custom-theme-shrink = true;
      customize-alphas = true;
      dash-max-icon-size = 48;
      dock-fixed = false;
      dock-position = "BOTTOM";
      extend-height = false;
      height-fraction = 0.9;
      hide-delay = 0.05;
      icon-size-fixed = false;
      intellihide = true;
      intellihide-mode = "FOCUS_APPLICATION_WINDOWS";
      isolate-monitors = true;
      isolate-workspaces = true;
      max-alpha = 0.6;
      middle-click-action = "launch";
      multi-monitor = true;
      preferred-monitor = -2;
      preferred-monitor-by-connector = "eDP-1";
      pressure-threshold = 0.0;
      preview-size-scale = 0.0;
      require-pressure-to-show = true;
      scroll-action = "cycle-windows";
      shift-click-action = "minimize";
      shift-middle-click-action = "launch";
      show-delay = 0.25;
      show-dock-urgent-notify = true;
      show-trash = true;
      transparency-mode = "DYNAMIC";
    };

    "org/gnome/shell/extensions/wack-lockscreen-clock" = {
      cupertino-always-show-user = true;
      enable-unblank = false;
      esc-to-sleep = true;
      lockscreen-mode = "wack";
    };

    # System & Desktop Functionality
    "org/gnome/desktop/a11y/magnifier" = {
      cross-hairs-length = 58;
    };

    "org/gnome/desktop/a11y/mouse" = {
      dwell-click-enabled = false;
    };

    "org/gnome/desktop/applications/terminal" = {
      exec = "xdg-terminal-exec";
    };

    "org/gnome/desktop/break-reminders/eyesight" = {
      play-sound = true;
    };

    "org/gnome/desktop/break-reminders/movement" = {
      duration-seconds = lib.gvariant.mkUint32 300;
      interval-seconds = lib.gvariant.mkUint32 1800;
      play-sound = true;
    };

    "org/gnome/desktop/input-sources" = {
      sources = [
        (lib.gvariant.mkTuple [
          "xkb"
          "us"
        ])
      ];
      # xkb-options = [ ];
    };

    "org/gnome/desktop/media-handling" = {
      autorun-never = true;
    };

    "org/gnome/mutter" = {
      dynamic-workspaces = true;
      edge-tiling = true;
      experimental-features = [
        "scale-monitor-framebuffer"
        "xwayland-native-scaling"
      ];
      overlay-key = "Super";
      workspaces-only-on-primary = true;
    };

    "org/gnome/settings-daemon/plugins/color" = {
      night-light-enabled = false;
      night-light-schedule-automatic = false;
    };

    "org/gnome/desktop/peripherals/touchpad" = {
      click-method = "areas";
      two-finger-scrolling-enabled = true;
    };

    # Window Manager & Shell Keybindings
    "org/gnome/desktop/wm/keybindings" = {
      minimize = [ ];
      raise-or-lower = [ "<Super>m" ];
      switch-applications = [ ];
      switch-applications-backward = [ ];
      switch-to-workspace-down = [ "disabled" ];
      switch-to-workspace-left = [ "<Alt><Super>Left" ];
      switch-to-workspace-right = [ "<Alt><Super>Right" ];
      switch-to-workspace-up = [ "disabled" ];
      switch-windows = [ "<Super>Tab" ];
      switch-windows-backward = [ "<Shift><Super>Tab" ];
    };

    "org/gnome/shell/keybindings" = {
      show-screenshot-ui = [ "<Shift><Super>s" ];
      toggle-message-tray = [ "<Super>v" ];
    };
  };

}
