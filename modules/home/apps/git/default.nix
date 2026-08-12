{...}: {
  programs.git = {
    enable = true;
    settings = {
      user = {
        name = "meth";
        email = "methlab006@gmail.com";
      };

      init.defaultBranch = "main";
      merge.conflictstyle = "zdiff3";
    };

    ignores = [
      ".direnv"
      "*.swp"
      ".env"
      ".devenv"
    ];
  };

  programs.delta = {
    enable = true;
    options = {
      navigate = true;
      dark = true;
      line-numbers = true;
    };
    enableGitIntegration = true;
  };

  programs.lazygit = {
    enable = true;
    settings = {
      gui = {
        theme = {
          selectedLineBgColor = ["#313244"];
          selectedRangeBgColor = ["#313244"];
        };
      };
      git = {
        pagers = [
          {
            colorArg = "always";
            pager = "delta --dark --paging=never";
          }
        ];
      };
    };
  };
}
