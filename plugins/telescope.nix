{
  config,
  lib,
  ...
}: let
  inherit (config.nixievim.mkKey) mkKeymap wKeyObj;
in {
  plugins.telescope = {
    enable = true;
    extensions = {fzf-native.enable = true;};
    settings = {
      defaults = {
        prompt_prefix = " ";
        selection_caret = " ";
        path_display = ["truncate"];
        sorting_strategy = "ascending";
        layout_strategy = "horizontal";
        layout_config = {
          horizontal = {
            prompt_position = "top";
            preview_width = 0.55;
            results_width = 0.8;
          };
          vertical = {mirror = false;};
          width = 0.87;
          height = 0.8;
          preview_cutoff = 120;
        };
        file_ignore_patterns = ["^.git/" "^.svn/" "^node_modules/" "^%.cache/"];
        winblend = 0;
        border = {};
        borderchars = ["─" "│" "─" "│" "╭" "╮" "╯" "╰"];
        color_devicons = true;
        use_less = true;
        set_env = {COLORTERM = "truecolor";};
      };
      pickers = {
        find_files = {
          find_command = ["fd" "--type" "f" "--strip-cwd-prefix"];
        };
        buffers = {
          show_all_buffers = true;
          sort_lastused = true;
          previewer = true;
          mappings = {
            i = {"<c-d>" = "delete_buffer";};
            n = {"dd" = "delete_buffer";};
          };
        };
      };
    };
  };

  wKeyList = [
    (wKeyObj ["<leader>f" "" "Find"])
  ];

  keymaps = [
    (mkKeymap "n" "<leader>ff" "<cmd>Telescope find_files<cr>" "Find files")
    (mkKeymap "n" "<leader>fg" "<cmd>Telescope live_grep<cr>" "Live grep")
    (mkKeymap "n" "<leader>fb" "<cmd>Telescope buffers<cr>" "Find buffers")
    (mkKeymap "n" "<leader>fh" "<cmd>Telescope help_tags<cr>" "Find help")
    (mkKeymap "n" "<leader>fr" "<cmd>Telescope oldfiles<cr>" "Recent files")
  ];
}
