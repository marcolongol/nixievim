{
  pkgs,
  config,
  ...
}: let
  inherit (config.nixievim.mkKey) wKeyObj;
in {
  extraPlugins = with pkgs.vimPlugins; [stay-centered-nvim];
  plugins = {
    # Must have plugins to have a decent flow of work
    comment.enable = true;
    debugprint = {
      enable = true;
      settings.keymaps = {
        normal = {
          plain_below = "<leader>dp";
          plain_above = "<leader>dP";
          variable_below = "<leader>dv";
          variable_above = "<leader>dV";
          delete_debug_prints = "<leader>dD";
          toggle_comment_debug_prints = "<leader>dt";
        };
        visual = {
          variable_below = "<leader>dv";
          variable_above = "<leader>dV";
        };
      };
    };
    web-devicons.enable = true;
    nvim-surround.enable = true;
    nvim-autopairs.enable = true;
    todo-comments = {
      enable = true;
      settings.keywords.SECTION = {
        icon = "󰉀";
        color = "error";
      };
    };
    trim.enable = true;
    smart-splits.enable = true;
    lualine.enable = true;
    lz-n.enable = true;
    which-key = {
      enable = true;
      settings.spec = config.wKeyList;
      settings.preset = "modern";
    };
  };

  wKeyList = [
    (wKeyObj ["<leader>d" "󰃤" "debug"])
  ];

  opts = {
    timeout = true;
    timeoutlen = 250;
  };
}
