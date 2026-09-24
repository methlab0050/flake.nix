{
  pkgs,
  inputs,
  lib,
  ...
}: let
  # Shared preferences across all Zen profiles (prefs.js)
  commonSettings = {
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
    "mousewheel.with_control.action" = 0; # 0 = Scroll page instead of zoom

    # Enable custom userChrome stylesheets
    "toolkit.legacyUserProfileCustomizations.stylesheets" = true;
  };

  # Declarative Zen Mods from Zen Theme Store across all profiles
  commonMods = [
    "a6335949-4465-4b71-926c-4a52d34bc9c0" # Better Find Bar
    "906c6915-5677-48ff-9bfc-096a02a72379" # Floating Status Bar
    "79dde383-4fe7-404a-a8e6-9be440022542" # Tidy Popup
  ];

  # Declarative Keyboard Shortcuts (schema mapped directly to zen-keyboard-shortcuts.json)
  commonKeyboardShortcuts = [
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

  # Helper to set profile-specific accent color settings
  mkSettings = accentColor: baseSettings:
    baseSettings
    // {
      "zen.theme.accent-color" = accentColor;
    };

  # Helper to set profile-specific accent color in userChrome CSS
  mkUserChrome = accentColor: ''
    :root {
      --zen-primary-color: ${accentColor} !important;
      --zen-colors-primary: ${accentColor} !important;
    }
  '';
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
      ExtensionSettings = {
        "proton-pass@proton.me" = {
          install_url = "https://addons.mozilla.org/firefox/downloads/latest/proton-pass/latest.xpi";
          installation_mode = "normal_installed";
        };
        "hotkeys-for-tabs-left-right@jscher2000" = {
          install_url = "https://addons.mozilla.org/firefox/downloads/latest/hotkeys-for-tabs-left-right/latest.xpi";
          installation_mode = "normal_installed";
        };
        "uBlock0@raymondhill.net" = {
          install_url = "https://addons.mozilla.org/firefox/downloads/latest/ublock-origin/latest.xpi";
          installation_mode = "normal_installed";
        };
      };
    };

    profiles = {
      Default = {
        id = 0;
        isDefault = true;
        path = "sbal7yhb.Default Profile";
        settings = mkSettings "#c8d3e6" commonSettings;
        userChrome = mkUserChrome "#c8d3e6";
        search = searchConfig;
        mods = commonMods;
        keyboardShortcuts = commonKeyboardShortcuts;
      };

      "Villain Arc" = {
        id = 1;
        path = "awqvdtx6.Villain Arc";
        settings = mkSettings "#45475a" commonSettings;
        userChrome = mkUserChrome "#45475a";
        search = searchConfig;
        mods = commonMods;
        keyboardShortcuts = commonKeyboardShortcuts;
      };

      School = {
        id = 2;
        path = "jlcduw4a.School";
        settings = mkSettings "#dce5f5" commonSettings;
        userChrome = mkUserChrome "#dce5f5";
        mods = commonMods;
        keyboardShortcuts = commonKeyboardShortcuts;
      };

      Healtouch = {
        id = 3;
        path = "kv8ujjg6.Healtouch";
        settings = mkSettings "#a6e3a1" commonSettings;
        userChrome = mkUserChrome "#a6e3a1";
        mods = commonMods;
        keyboardShortcuts = commonKeyboardShortcuts;
      };

      CAMRU = {
        id = 4;
        path = "azi4n6er.CAMRU";
        settings = mkSettings "#89b4fa" commonSettings; # Classic Zen Blue
        userChrome = mkUserChrome "#89b4fa";
        mods = commonMods;
        keyboardShortcuts = commonKeyboardShortcuts;
      };

      GDDC = {
        id = 5;
        settings = mkSettings "#94e2d5" commonSettings; # Teal Blue
        userChrome = mkUserChrome "#94e2d5";
        mods = commonMods;
        keyboardShortcuts = commonKeyboardShortcuts;
      };

      GAME = {
        id = 6;
        settings = mkSettings "#cba6f7" commonSettings; # Purple / Mauve
        userChrome = mkUserChrome "#cba6f7";
        mods = commonMods;
        keyboardShortcuts = commonKeyboardShortcuts;
      };
    };
  };
}
