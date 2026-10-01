{
  pkgs,
  inputs,
  lib,
  ...
}: let
  mkDefaultProfile = import ./make-profile.nix {inherit lib;};

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
        icon = "https://search.nixos.org/images/nixos-logomark-default-gradient-none.svg";
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

  mkProfiles = id: profiles:
    if profiles == []
    then {}
    else let
      profile = builtins.head profiles;
      profileName = lib.last (lib.splitString "." profile.path);
      profiles = builtins.tail profiles;
    in
      {
        "${profileName}" = (mkDefaultProfile id) // profile;
      }
      // mkProfiles (id + 1) profiles;
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
      };
    };

    profiles = mkProfiles 0 [
      {
        path = "sbal7yhb.Default Profile";
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
  };
}
