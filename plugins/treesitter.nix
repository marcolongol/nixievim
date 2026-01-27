{pkgs, ...}: {
  plugins = {
    mini-ai.enable = true;
    treesitter = {
      enable = true;
      folding = true;
      settings = {
        highlight = {
          enable = true;
          disable = [
            "latex"
            "markdown"
          ];
        };
        indent = {
          enable = true;
        };
        incremental_selection = {
          enable = true;
        };
      };
      grammarPackages = with pkgs.vimPlugins.nvim-treesitter.builtGrammars; [
        bash
        c
        cpp
        css
        html
        javascript
        json
        lua
        markdown
        nix
        python
        rust
        toml
        typescript
        vim
        vimdoc
        yaml
      ];
    };
    treesitter-context = {
      enable = true;
      settings = {
        max_lines = 4;
        min_window_height = 40;
      };
    };
    treesitter-textobjects = {
      enable = true;
      select = {
        enable = true;
        lookahead = true;
      };
    };
    # tpope's indent fixes
    sleuth.enable = true;
  };
}
