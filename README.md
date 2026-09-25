# My GOATED NixOS config
Bahhh 🐐🐐🐐


## Project Structure
```
.
├── devenv.nix      # Development environment (mostly git hooks)
├── devenv.lock
├── devenv.yaml
├── flake.nix       # Dependencies/root project file
├── flake.lock      # Dependencies lock
├── hosts
│   └── framework   # Hardware specific-stuff for my laptop
└── modules
    ├── home        # Home-manager config
    └── system      # NixOs config
```

## TODO
- Add configs
    - vscodium
- Change gnome emoji picker from ctrl+; to ctrl+.
    - Remove default emoji picker at ctrl+.
- set ghostty as default term in nautilus
    - [See this thread](https://discourse.nixos.org/t/howto-disable-most-gnome-default-applications-and-what-they-are/13505)
- zen:
    - Extensions and extension shortcuts
        - Use Rycee to get extensions to work
        - Might have to manually overwrite extension-settings.json for shortcuts
    - Pins
    - Shortcuts
        - Might have to remove zen-shortcuts.json before hand
- Add smile emoji picker
- Rewrite fish to properly use home manager (maybe)

I hope GNOME 51 will have full support for 150% display scale.

