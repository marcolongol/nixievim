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

    minuet = {
      enable = true;
      # key from $NIXIEVIM_ANTHROPIC_KEY_FILE, else $ANTHROPIC_API_KEY
      luaConfig.pre = ''
        local minuet_key = os.getenv("ANTHROPIC_API_KEY") or ""
        local key_file = os.getenv("NIXIEVIM_ANTHROPIC_KEY_FILE")
        if key_file then
          local f = io.open(key_file)
          if f then
            minuet_key = vim.trim(f:read("*a"))
            f:close()
          end
        end
      '';
      settings = {
        provider = "claude";
        request_timeout = 3;
        provider_options.claude = {
          model = "claude-haiku-5-5";
          max_tokens = 256;
          # thinking adds latency
          optional.thinking.type = "disabled";
          api_key = lib.nixvim.mkRaw "function() return minuet_key end";
        };
        virtualtext = {
          # no key: manual trigger only, no error spam
          auto_trigger_ft = lib.nixvim.mkRaw ''minuet_key ~= "" and { "*" } or {}'';
          keymap = {
            accept = "<A-A>";
            accept_line = "<A-a>";
            accept_n_lines = "<A-z>";
            next = "<A-]>";
            prev = "<A-[>";
            dismiss = "<A-e>";
          };
        };
      };
    };
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
