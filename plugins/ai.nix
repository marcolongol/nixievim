{
  config,
  inputs,
  lib,
  pkgs,
  ...
}: let
  inherit (config.nixievim.mkKey) mkKeymap wKeyObj;
  claudecode = pkgs.vimUtils.buildVimPlugin {
    pname = "claudecode-nvim";
    version = inputs.claudecode-nvim.shortRev;
    src = inputs.claudecode-nvim;
  };
in {
  extraPlugins = [claudecode];

  extraConfigLua = ''
    require("claudecode").setup({
      auto_start = true,
      track_selection = true,
    })
  '';

  plugins = {
    copilot-lua = {
      enable = false;
      settings = {
        filetypes.markdown = true;
        suggestion = {
          enabled = true;
          auto_trigger = true;
        };
      };
    };
    blink-copilot.enable = false;
  };

  wKeyList = [
    (wKeyObj ["<leader>a" "󰚩" "AI"])
  ];

  keymaps = [
    (mkKeymap "n" "<leader>ac" "<cmd>ClaudeCode<cr>" "ClaudeCode")
    (mkKeymap "n" "<leader>acf" "<cmd>ClaudeCodeFocus<cr>" "Focus")
    (mkKeymap "n" "<leader>acr" "<cmd>ClaudeCode --resume<cr>" "Resume")
    (mkKeymap "n" "<leader>acc" "<cmd>ClaudeCode --continue<cr>" "Continue")
    (mkKeymap "v" "<leader>acs" "<cmd>ClaudeCodeSend<cr>" "Send selection")
    (mkKeymap "n" "<leader>acb" "<cmd>ClaudeCodeAdd %<cr>" "Add buffer")
    (mkKeymap "n" "<leader>aca" "<cmd>ClaudeCodeDiffAccept<cr>" "Accept diff")
    (mkKeymap "n" "<leader>acd" "<cmd>ClaudeCodeDiffDeny<cr>" "Reject diff")
  ];
}
