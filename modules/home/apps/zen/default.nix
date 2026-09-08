{
  pkgs,
  inputs,
  lib,
  ...
}: let
  # Shared preferences across all Zen profiles
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

    # 5. Private Window shortcut preference (Ctrl+Shift+N)
    "zen.keyboard.open-private-window" = "Ctrl+Shift+N";

    # 6. Pin Tab shortcut preference (Ctrl+D instead of bookmarking)
    "zen.keyboard.toggle-pin-tab" = "Ctrl+D";
    "zen.keyboard.pin-tab" = "Ctrl+D";
    "zen.keyboard.bookmark-page" = "";

    # 7. Disable Ctrl + mouse scroll zooming
    "mousewheel.with_control.action" = 0; # 0 = Scroll page instead of zoom

    # 8. Tab switching shortcuts (Ctrl+Alt+Up for Left, Ctrl+Alt+Down for Right)
    "zen.keyboard.previous-tab" = "Ctrl+Alt+Up";
    "zen.keyboard.next-tab" = "Ctrl+Alt+Down";

    # Enable custom userChrome stylesheets
    "toolkit.legacyUserProfileCustomizations.stylesheets" = true;
  };

  # Essentials settings for Default, School, and Healtouch profiles (GCal and Gmail)
  essentialsSettings =
    commonSettings
    // {
      "browser.newtabpage.pinned" = builtins.toJSON [
        {
          url = "https://calendar.google.com";
          title = "Google Calendar";
        }
        {
          url = "https://mail.google.com";
          title = "Gmail";
        }
      ];
      "zen.workspaces.essentials" = builtins.toJSON [
        "https://calendar.google.com"
        "https://mail.google.com"
      ];
    };

  # Declarative Zen Mods from Zen Theme Store across all profiles
  commonMods = [
    "a6335949-4465-4b71-926c-4a52d34bc9c0" # Better Find Bar
    "906c6915-5677-48ff-9bfc-096a02a72379" # Floating Status Bar
    "79dde383-4fe7-404a-a8e6-9be440022542" # Tidy Popup
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

    ${commonUserChrome}
  '';

  # Zen Custom CSS (Shortcuts & Accent Color handling)
  commonUserChrome = ''
    /* ==========================================================================
       Mod: Private Window Shortcut Remap (Ctrl+Shift+N)
       ========================================================================== */
    #key_openPrivateWindow {
      key: "N" !important;
      modifiers: "accel,shift" !important;
    }

    /* ==========================================================================
       Mod: Remap Ctrl+D to Pin Tab (instead of bookmarking)
       ========================================================================== */
    #addBookmarkAsKb {
      key: "" !important;
      modifiers: "" !important;
    }

    #key_togglePinTab,
    #key_pinTab,
    #cmd_togglePinTab {
      key: "D" !important;
      modifiers: "accel" !important;
    }

    /* ==========================================================================
       Mod: Tab Switching (Ctrl+Alt+Up for Left/Prev, Ctrl+Alt+Down for Right/Next)
       ========================================================================== */
    #key_selectPrevTab,
    #key_prevTab {
      key: "VK_UP" !important;
      modifiers: "accel,alt" !important;
    }

    #key_selectNextTab,
    #key_nextTab {
      key: "VK_DOWN" !important;
      modifiers: "accel,alt" !important;
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

  # 1. Remove non-symlink profiles.ini prior to checkLinkTargets so Home Manager doesn't error about clobbering
  home.activation.cleanZenProfilesIni = lib.hm.dag.entryBefore ["checkLinkTargets"] ''
    PROFILES_INI="$HOME/.config/zen/profiles.ini"
    if [ -f "$PROFILES_INI" ] && [ ! -L "$PROFILES_INI" ]; then
      rm -f "$PROFILES_INI"
    fi
  '';

  # 2. Ensure zen-themes.json exists so zen-browser-flake mod installer can update theme list without error
  home.activation.initZenThemesJson = lib.hm.dag.entryBefore ["onFilesChange"] ''
    for p in "$HOME/.config/zen"/*/; do
      if [ -d "$p" ]; then
        if [ ! -f "$p/zen-themes.json" ]; then
          echo "[]" > "$p/zen-themes.json"
        fi
      fi
    done

    for name in "Default" "Villain Arc" "School" "Healtouch" "CAMRU"; do
      mkdir -p "$HOME/.config/zen/$name"
      if [ ! -f "$HOME/.config/zen/$name/zen-themes.json" ]; then
        echo "[]" > "$HOME/.config/zen/$name/zen-themes.json"
      fi
    done
  '';

  # 3. Convert profiles.ini from read-only Nix store symlink to a writable file so Zen Browser can update active profile state without error
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
        settings = mkSettings "#c8d3e6" essentialsSettings; # Cool slate grey-blue (similar to School but a tad more grey)
        userChrome = mkUserChrome "#c8d3e6";
        search = searchConfig;
        mods = commonMods;
      };

      "Villain Arc" = {
        id = 1;
        path = "awqvdtx6.Villain Arc";
        settings = mkSettings "#45475a" commonSettings; # Incognito Grey
        userChrome = mkUserChrome "#45475a";
        search = searchConfig;
        mods = commonMods;
      };

      School = {
        id = 2;
        path = "jlcduw4a.School";
        settings = mkSettings "#dce5f5" essentialsSettings; # White with light blue tint
        userChrome = mkUserChrome "#dce5f5";
        mods = commonMods;
      };

      Healtouch = {
        id = 3;
        path = "kv8ujjg6.Healtouch";
        settings = mkSettings "#a6e3a1" essentialsSettings; # Light Green
        userChrome = mkUserChrome "#a6e3a1";
        mods = commonMods;
      };

      CAMRU = {
        id = 4;
        path = "azi4n6er.CAMRU";
        settings = mkSettings "#89b4fa" commonSettings; # Classic Zen Blue
        userChrome = mkUserChrome "#89b4fa";
        mods = commonMods;
      };
    };
  };
}
