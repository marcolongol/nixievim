{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (config.nixievim.mkKey) mkKeymap wKeyObj;
  claudecode = pkgs.vimUtils.buildVimPlugin {
    pname = "claudecode-nvim";
    version = "2026-03-04";
    src = pkgs.fetchFromGitHub {
      owner = "coder";
      repo = "claudecode.nvim";
      rev = "432121f0f5b9bda041030d1e9e83b7ba3a93dd8f";
      hash = "sha256-r8hAUpSsr8zNm+av8Mu5oILaTfEsXEnJmkzRmvi9pF8=";
    };
  };
in {
  extraPlugins = [claudecode];

  extraConfigLua = ''
    require("claudecode").setup({
      auto_start = true,
      track_selection = true,
      terminal = {
        provide = "auto",
        split_side = "right",
        split_width_percentage = 0.30,
        auto_close = true,
      },
    })
  '';

  plugins = {
    snacks = {
      enable = true;
      settings.terminal.enabled = true;
    };
    copilot-lua = {
      enable = true;
      settings = {
        filetypes.markdown = true;
        suggestion = {
          enabled = true;
          auto_trigger = true;
        };
      };
    };
    blink-copilot.enable = true;
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
