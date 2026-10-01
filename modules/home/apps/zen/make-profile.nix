{lib, ...}: id: {
  inherit id;

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

  pins = {
    "Google Calendar" = {
      url = "https://calendar.google.com";
      position = 100;
      id = "00000000-0000-4000-8000-0000000001${lib.fixedWidthNumber 2 id}";
      isEssential = true;
    };
    "Gmail" = {
      url = "https://mail.google.com";
      position = 200;
      id = "00000000-0000-4000-8000-0000000002${lib.fixedWidthNumber 2 id}";
      isEssential = true;
    };
  };
}
