{
  lib,
  pkgs,
  ...
}: {
  plugins = {
    lint = {
      lintersByFt = {
        python = ["pylint" "mypy"];
      };
      linters = {
        pylint = {
          cmd = lib.getExe pkgs.pylint;
        };
        mypy = {
          cmd = lib.getExe pkgs.mypy;
        };
      };
    };
    lsp.servers = {
      ruff.enable = true;
      pyright = {
        enable = true;
        settings = {
          python = {
            analysis = {
              typeCheckingMode = "strict";
              autoSearchPaths = true;
              useLibraryCodeForTypes = true;
            };
          };
        };
      };
    };
  };
}
