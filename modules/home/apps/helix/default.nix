{pkgs, ...}: {
  imports = [
    ./languages.nix
  ];

  programs.helix = {
    enable = true;

    defaultEditor = true;

    settings = {
      theme = "monokai_dimmed";

      editor = {
        line-number = "relative";
        cursorline = true;
        mouse = true;

        cursor-shape = {
          insert = "bar";
          normal = "block";
          select = "underline";
        };

        file-picker = {
          hidden = false;
        };
      };
    };

    themes = {
      monokai_dimmed = ./monokai_dimmed.toml;
    };
  };
}
