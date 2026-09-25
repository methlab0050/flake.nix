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

  mkExtensionSettings = builtins.mapAttrs (_: pluginId: {
    install_url = "https://addons.mozilla.org/firefox/downloads/latest/${pluginId}/latest.xpi";
    installation_mode = "force_installed";
  });

  # Helper to define essential pinned tabs for a space
  mkPins = id: calPinId: mailPinId: {
    "Google Calendar" = {
      id = calPinId;
      url = "https://calendar.google.com";
      position = 100 + id + 1;
      # isEssential = true;
    };
    "Gmail" = {
      id = mailPinId;
      url = "https://mail.google.com";
      position = 200 + id + 1;
      # isEssential = true;
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

  # Remove non-symlink target collisions before checkLinkTargets so Home Manager links cleanly
  home.activation.cleanZenProfileCollisions = lib.hm.dag.entryBefore ["checkLinkTargets"] ''
    PROFILES_INI="$HOME/.config/zen/profiles.ini"
    if [ -f "$PROFILES_INI" ] && [ ! -L "$PROFILES_INI" ]; then
      rm -f "$PROFILES_INI"
    fi

    for profile in "GDDC" "GAME" "Default" "Villain Arc" "School" "Healtouch" "CAMRU" \
                   "sbal7yhb.Default Profile" "awqvdtx6.Villain Arc" "jlcduw4a.School" "kv8ujjg6.Healtouch" "azi4n6er.CAMRU"; do
      for f in "$HOME/.config/zen/$profile/user.js" "$HOME/.config/zen/$profile/chrome/userChrome.css"; do
        if [ -f "$f" ] && [ ! -L "$f" ]; then
          rm -f "$f"
        fi
      done
    done
  '';

  # Ensure profiles.ini is writable so browser start doesn't crash on state saves
  home.activation.makeZenProfilesIniWritable = lib.hm.dag.entryAfter ["linkGeneration"] ''
    PROFILES_INI="$HOME/.config/zen/profiles.ini"
    if [ -L "$PROFILES_INI" ]; then
      TARGET="$(readlink "$PROFILES_INI")"
      rm -f "$PROFILES_INI"
      cp -L "$TARGET" "$PROFILES_INI"
      chmod 644 "$PROFILES_INI"
    fi
  '';

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
      };
    };

    profiles = {
      Default = {
        inherit settings mods keyboardShortcuts;
        id = 0;
        path = "sbal7yhb.Default Profile";
        pins = mkPins 0 "00000000-0000-4000-8000-000000000101" "00000000-0000-4000-8000-000000000201";
        search = searchConfig;
      };

      "Villain Arc" = {
        inherit settings mods keyboardShortcuts;
        id = 1;
        path = "awqvdtx6.Villain Arc";
        pins = mkPins 1 "00000000-0000-4000-8000-000000000102" "00000000-0000-4000-8000-000000000202";
        search = searchConfig;
      };

      School = {
        inherit settings mods keyboardShortcuts;
        id = 2;
        path = "jlcduw4a.School";
        pins = mkPins 2 "00000000-0000-4000-8000-000000000103" "00000000-0000-4000-8000-000000000203";
      };

      Healtouch = {
        inherit settings mods keyboardShortcuts;
        id = 3;
        path = "kv8ujjg6.Healtouch";
        pins = mkPins 3 "00000000-0000-4000-8000-000000000104" "00000000-0000-4000-8000-000000000204";
      };

      CAMRU = {
        inherit settings mods keyboardShortcuts;
        id = 4;
        path = "azi4n6er.CAMRU";
        pins = mkPins 4 "00000000-0000-4000-8000-000000000105" "00000000-0000-4000-8000-000000000205";
      };

      GDDC = {
        inherit settings mods keyboardShortcuts;
        id = 5;
        pins = mkPins 5 "00000000-0000-4000-8000-000000000106" "00000000-0000-4000-8000-000000000206";
      };

      GAME = {
        inherit settings mods keyboardShortcuts;
        id = 6;
        pins = mkPins 6 "00000000-0000-4000-8000-000000000107" "00000000-0000-4000-8000-000000000207";
      };
    };
  };
}
