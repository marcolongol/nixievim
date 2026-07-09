{
  pkgs,
  ...
}: {
  extraPlugins = [
    pkgs.vimPlugins.windows-nvim
    # codewindow only borrows get_vim_range from the nvim-treesitter plugin,
    # whose legacy version collides with our modern treesitter pin. Inline that
    # one helper so we can drop the dep and keep full syntax coloring (the rest
    # of its highlighter runs against core treesitter, not the plugin).
    (pkgs.vimPlugins.codewindow-nvim.overrideAttrs {
      dependencies = [];
      postPatch = ''
        substituteInPlace lua/codewindow/highlight.lua \
          --replace-fail 'ts_utils = require("nvim-treesitter.ts_utils")' \
          'ts_utils = { get_vim_range = function(r, buf) local sr, sc, er, ec = r[1] + 1, r[2] + 1, r[3] + 1, r[4]; if ec == 0 then er = er - 1; ec = math.max(#(vim.api.nvim_buf_get_lines(buf, er - 1, er, false)[1] or ""), 1) end; return sr, sc, er, ec end }'
      '';
    })
  ];
  extraConfigLua =
    # lua
    ''
      vim.o.winwidth = 10
      vim.o.winminwidth = 10
      vim.o.equalalways = false
      require('windows').setup()

      -- minimap; <leader>mm toggles, see apply_default_keybinds for the rest.
      -- treesitter/lsp/git coloring is on by default; only override the excludes.
      require('codewindow').setup({
        minimap_width = 10, -- default 20
        exclude_filetypes = { "help", "neo-tree" },
      })
      require('codewindow').apply_default_keybinds()
    '';

  plugins = {
    colorizer = {
      enable = true;
      settings = {
        user_default_options = {
          names = true;
          RRGGBBAA = true;
          AARRGGBB = true;
          rgb_fn = true;
          hsl_fn = true;
          css = true;
          css_fn = true;
          tailwind = true;
          mode = "virtualtext";
          virtualtext = "■";
          always_update = true;
        };
      };
    };
    fidget = {
      enable = true;
      settings = {
        progress.display.progress_icon = ["moon"];
        notification.window = {
          relative = "editor";
          winblend = 0;
          border = "rounded";
        };
      };
    };
    noice = {
      enable = true;
      settings = {
        presets = {
          bottom_search = true;
          command_palette = true;
          long_message_to_split = true;
          lsp_doc_border = true;
        };
        views = {
          cmdline_popup = {
            position = {
              row = -2;
              col = "50%";
            };
          };
          cmdline_popupmenu.position = {
            row = -5;
            col = "50%";
          };
        };

        lsp = {
          override = {
            "vim.lsp.util.convert_input_to_markdown_lines" = true;
            "vim.lsp.util.stylize_markdown" = true;
            "cmp.entry.get_documentation" = true;
          };
          hover.enabled = true;
          message.enabled = true;
          signature.enabled = true;
          progress.enabled = true;
        };
      };
    };
  };
}
