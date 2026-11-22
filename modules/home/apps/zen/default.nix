{
  pkgs,
  inputs,
  lib,
  ...
}: let
  # Shared preferences across all Zen profiles (prefs.js)
  settings = {
    # 1. Ctrl+Tab cycles through recently most used tabs
    "browser.ctrlTab.sortByRecentlyUsed" = true;

    # 2. Disable Picture-in-Picture
    "media.videocontrols.picture-in-picture.enabled" = false;
    "media.videocontrols.picture-in-picture.video-toggle.enabled" = false;

    # 3. Default Autoplay settings: Allow for video and audio
    "media.autoplay.default" = 0; # 0 = Allow video & audio
    "media.autoplay.blocking_policy" = 0;
    "media.autoplay.enabled.user-gestures-needed" = false;

    # 4. Default Fonts
    "font.name.sans-serif.x-western" = "Arimo Nerd Font";
    "font.name.serif.x-western" = "Tinos Nerd Font";
    "font.name.monospace.x-western" = "CaskaydiaMono NFM";
    "font.default.x-western" = "sans-serif";

    # 5. Disable Ctrl + mouse scroll zooming
    "mousewheel.with_control.action" = 1;
    # "toolkit.legacyUserProfileCustomizations.stylesheets" = true;

    # Google Docs paste acts weird if you don't set this
    "dom.events.testing.asyncClipboard" = true;
  };

  # Declarative Zen Mods from Zen Theme Store across all profiles
  mods = [
    "a6335949-4465-4b71-926c-4a52d34bc9c0" # Better Find Bar
    "79dde383-4fe7-404a-a8e6-9be440022542" # Tidy Popup
    "253a3a74-0cc4-47b7-8b82-996a64f030d5" # Floating History
  ];

  # Declarative Keyboard Shortcuts (schema mapped directly to zen-keyboard-shortcuts.json)
  keyboardShortcuts = [
    {
      id = "key_privatebrowsing";
      key = "N";
      modifiers = {
        control = true;
        shift = true;
      };
    }
    {
      id = "addBookmarkAsKb";
      disabled = true;
    }
    {
      id = "zen-toggle-pin-tab";
      key = "d";
      modifiers = {
        control = true;
      };
    }
  ];

  # Custom Search Engines for Default and Villain Arc profiles (@nix and @cargo)
  searchConfig = {
    force = true;
    engines = {
      "Nix Packages" = {
        urls = [
          {
            template = "https://search.nixos.org/packages";
            params = [
              {
                name = "channel";
                value = "26.05";
              }
              {
                name = "query";
                value = "{searchTerms}";
              }
            ];
          }
        ];
        icon = "https://search.nixos.org/favicon.ico";
        updateInterval = 24 * 60 * 60 * 1000;
        definedAliases = ["@nix"];
      };

      "Crates.io" = {
        urls = [
          {
            template = "https://crates.io/search";
            params = [
              {
                name = "q";
                value = "{searchTerms}";
              }
            ];
          }
        ];
        icon = "https://crates.io/favicon.ico";
        updateInterval = 24 * 60 * 60 * 1000;
        definedAliases = ["@cargo"];
      };
    };
  };

  mkExtensionSettings = builtins.mapAttrs (
    _: pluginId: {
      install_url = "https://addons.mozilla.org/firefox/downloads/latest/${pluginId}/latest.xpi";
      installation_mode = "force_installed";
    }
  );

  # Helper to define essential pinned tabs for a space
  mkPins = id: {
    "Google Calendar" = {
      id = "00000000-0000-4000-8000-00000000010" + toString id;
      url = "https://calendar.google.com";
      position = 100 + id;
      isEssential = true;
    };
    "Gmail" = {
      id = "00000000-0000-4000-8000-00000000020" + toString id;
      url = "https://mail.google.com";
      position = 200 + id;
      isEssential = true;
    };
  };

  profiles = [
    {
      path = "sbal7yhb.Default Profile";
      name = "Default";
      search = searchConfig;
    }
    {
      path = "awqvdtx6.Villain Arc";
      search = searchConfig;
      pins = {};
    }
    {
      path = "jlcduw4a.School";
    }
    {
      path = "kv8ujjg6.Healtouch";
    }
    {
      path = "azi4n6er.CAMRU";
    }
    {
      path = "GDDC";
    }
    {
      path = "GAME";
    }
  ];

  mkProfile = id: profileSettings: let
    path = profileSettings.path;
    name =
      if profileSettings ? name
      then profileSettings.name
      else lib.last (lib.splitString "." path);
    pins = mkPins (id + 1);
  in {
    "${name}" =
      {
        inherit id pins settings mods keyboardShortcuts;
      }
      // removeAttrs profileSettings ["name"];
  };

  mkXdgDesktopEntry = profileSettings: let
    path = profileSettings.path;
    name =
      if profileSettings ? name
      then profileSettings.name
      else lib.last (lib.splitString "." path);
  in {
    "zen-${name}" = {
      name = "${name}";
      genericName = "Web Browser";
      comment = "Launch Zen Twilight with ${name} profile";
      exec = "zen-twilight -P \"${name}\" %U";
      icon = "zen-beta";
      terminal = false;
      type = "Application";
      categories = ["Network" "WebBrowser"];
      mimeType = [
        "text/html"
        "text/xml"
        "application/xhtml+xml"
        "x-scheme-handler/http"
        "x-scheme-handler/https"
      ];
    };
  };

  profileManager = {
    "zen-picker" = {
      name = "Zen Profile Manager";
      comment = "Launch Zen Twilight profile manager";
      exec = "zen-twilight --ProfileManager %U";
      icon = "zen-twilight";
    };
  };
in {
  imports = [
    inputs.zen-browser.homeModules.twilight
  ];

  # Install required Nerd Fonts
  home.packages = with pkgs; [
    nerd-fonts.arimo
    nerd-fonts.tinos
    nerd-fonts.caskaydia-mono
  ];

  programs.zen-browser = {
    enable = true;
    setAsDefaultBrowser = true;

    env = {
      MOZ_ENABLE_WAYLAND = "1";
    };

    policies = {
      ExtensionSettings = mkExtensionSettings {
        "left-tab-right-tab@jeffersonscher.com" = "hotkeys-for-tabs-left-right";
        "uBlock0@raymondhill.net" = "ublock-origin";
        "ctrl-shift-c-copy@jeffersonscher.com" = "ctrl-shift-c-should-copy";
        "sound-boobooster@yeahyeah" = "600-sound-booster-max-volume";
      };
    };

    profiles = lib.mergeAttrsList (lib.imap0 mkProfile profiles);
  };

  xdg.desktopEntries = lib.mergeAttrsList (map mkXdgDesktopEntry profiles) // profileManager;
}
