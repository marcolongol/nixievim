{lib, ...}: let
  inherit (lib.nixvim) mkRaw;
in {
  plugins = {
    blink-cmp = {
      enable = true;
      settings = {
        appearance = {
          nerd_font_variant = "normal";
          use_nvim_cmp_as_default = true;
        };
        completion = {
          documentation = {
            auto_show = true;
            window = {
              border = "rounded";
              max_width = 80;
              max_height = 20;
            };
          };
        };
        keymap = {preset = "enter";};
        signature = {enabled = true;};
        sources = {
          default = ["lsp" "path" "snippets" "buffer" "copilot"];
          providers = {
            copilot = {
              async = true;
              module = "blink-copilot";
              name = "copilot";
              score_offset = 100;
            };
            buffer = {score_offset = -10;};
            lsp = {fallbacks = [];};
          };
        };
      };
    };
    luasnip.enable = true;
  };
}
