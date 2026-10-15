{pkgs, ...}: {
  plugins = {
    mini-ai.enable = true;
    treesitter = {
      enable = true;
      folding.enable = true;
      # Native Nixvim highlighting (nvim-treesitter main branch); the old
      # settings.highlight.* path is legacy upstream config.
      highlight = {
        enable = true;
        disable = [
          "latex"
          "markdown"
        ];
      };
      settings = {
        indent = {
          enable = true;
        };
        incremental_selection = {
          enable = true;
        };
      };
      grammarPackages = with pkgs.vimPlugins.nvim-treesitter.builtGrammars; [
        angular
        bash
        c
        c_sharp
        cpp
        css
        dockerfile
        gitcommit
        gitignore
        helm
        html
        javascript
        json
        lua
        markdown
        nix
        prisma
        python
        regex
        rust
        starlark
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
      settings.select = {
        enable = true;
        lookahead = true;
      };
    };
    # tpope's indent fixes
    sleuth.enable = true;
  };
}
