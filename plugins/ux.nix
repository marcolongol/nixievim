{
  pkgs,
  config,
  ...
}: {
  extraPlugins = [
    pkgs.vimPlugins.windows-nvim
  ];
  extraConfigLua =
    # lua
    ''
      vim.o.winwidth = 10
      vim.o.winminwidth = 10
      vim.o.equalalways = false
      require('windows').setup()
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
