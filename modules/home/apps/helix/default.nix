{...}: {
  imports = [
    ./languages.nix
  ];

  programs.helix = {
    enable = true;

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

        soft-wrap = {
          enable = true;
          wrap-indicator = "";
        };
      };

      keys = {
        normal = {
          "C-left" = "move_prev_word_start";
          "C-right" = "move_next_word_start";
        };
        insert = {
          "C-left" = "move_prev_word_start";
          "C-right" = "move_next_word_start";
        };
        select = {
          "C-left" = "move_prev_word_start";
          "C-right" = "move_next_word_start";
        };
      };
    };

    themes = {
      monokai_dimmed = ./monokai_dimmed.toml;
    };
  };
}
