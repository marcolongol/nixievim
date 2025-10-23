{
  pkgs,
  config,
  lib,
  ...
}: let
  inherit (lib.nixvim) mkRaw;
  inherit (config.nixievim.mkKey) mkKeymap mkKeymapWithOpts wKeyObj;
in {
  keymaps = [
    (mkKeymap "n" "<leader>e" ":Neotree toggle<cr>" "Toggle Neotree")
  ];

  wKeyList = [
    (wKeyObj ["<leader>e" "󰙅" "Neotree"])
  ];

  plugins.neo-tree = {
    enable = true;
    settings = {
      enable_diagnostics = true;
      enable_git_status = true;
      enable_modified_markers = true;
      close_if_last_window = true;
      popup_border_style = "rounded";
      sources = [
        "filesystem"
        "buffers"
        "git_status"
      ];
      source_selector = {
        winbar = true;
        statusline = true;
      };
      buffers = {
        bind_to_cwd = false;
        follow_current_file = {
          enabled = true;
        };
      };
      filesystem = {
        use_libuv_file_watcher = true;
        follow_current_file.enabled = true;
      };
    };
  };

  plugins.bufferline.settings.options.offsets = [
    {
      filetype = "neo-tree";
      text = "Explorer";
      highlight = "PanelHeading";
      padding = 1;
    }
  ];
}
