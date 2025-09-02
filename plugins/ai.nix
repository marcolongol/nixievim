{
  config,
  lib,
  ...
}: let
  inherit (config.nixievim.mkKey) mkKeymap wKeyObj;
in {
  plugins = {
    claude-code = {
      enable = true;
      settings = {
        window = {
          position = "vertical";
        };
      };
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
    (mkKeymap "n" "<leader>acc" "<cmd>ClaudeCodeContinue<cr>" "Continue")
    (mkKeymap "n" "<leader>acr" "<cmd>ClaudeCodeResume<cr>" "Resume")
  ];
}
