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
    enableDiagnostics = true;
    enableGitStatus = true;
    enableModifiedMarkers = true;
    closeIfLastWindow = true;
    popupBorderStyle = "rounded";
    sources = [
      "filesystem"
      "buffers"
      "git_status"
    ];
    sourceSelector = {
      winbar = true;
      statusline = true;
    };
    buffers = {
      bindToCwd = false;
      followCurrentFile = {
        enabled = true;
      };
    };
    filesystem = {
      useLibuvFileWatcher = true;
      followCurrentFile.enabled = true;
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
