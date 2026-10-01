{
  pkgs,
  inputs,
  ...
}: {
  programs.vscode = {
    enable = true;
    # Optional: use VSCodium instead of Microsoft VS Code
    package = pkgs.vscodium-fhs;

    # Manage extensions from nixpkgs
    extensions = with inputs.nix-vscode-extensions.extensions; [
      smcpeak.default-keys-windows
      PKief.material-icon-theme
      jnoortheen.nix-ide
      mkhl.direnv
      bmalehorn.vscode-fish
      # datakurre.devenv
    ];

    # Manage user settings (settings.json)
    userSettings = {
      "json.schemaDownload.trustedDomains" = {
        "https://developer.microsoft.com/json-schemas/" = true;
        "https://github.com" = true;
        "https://json-schema.org/" = true;
        "https://json.schemastore.org/" = true;
        "https://raw.githubusercontent.com/devcontainers/spec/" = true;
        "https://raw.githubusercontent.com/microsoft/vscode/" = true;
        "https://schemastore.azurewebsites.net/" = true;
        "https://www.schemastore.org/" = true;
      };
      "workbench.colorTheme" = "Monokai Dimmed";
      "terminal.integrated.profiles.linux" = {
        "bash" = {
          "path" = "bash";
          "icon" = "terminal-bash";
        };
        "zsh" = {
          "path" = "zsh";
        };
        "fish" = {
          "path" = "/run/current-system/sw/bin/fish";
        };
        "tmux" = {
          "path" = "tmux";
          "icon" = "terminal-tmux";
        };
        "pwsh" = {
          "path" = "pwsh";
          "icon" = "terminal-powershell";
        };
      };
      "terminal.integrated.defaultProfile.linux" = "fish";
      "workbench.iconTheme" = "material-icon-theme";
      "editor.bracketPairColorization.enabled" = false;
      "nix.serverPath" = "nixd";
      "nix.serverSettings" = {
        "nixd" = {};
      };
      "nix.enableLanguageServer" = true;
      "files.exclude" = {
        "**/.direnv" = true;
        "**/.devenv" = true;
      };
      "explorer.confirmDragAndDrop" = false;
      "direnv.restart.automatic" = true;
      "material-icon-theme.files.associations" = {
        "*.toml" = "Settings";
      };
      "workbench.colorCustomizations" = {
        "editorInlayHint.typeForeground" = "#e0e8e7"; # // Text color for type hints
        "editorInlayHint.typeBackground" = "#373434"; # // Background box color (#00000000 for fully transparent/no box)
      };
    };
  };
}
