{
  lib,
  config,
  pkgs,
  ...
}: let
  inherit (config.nixievim.mkKey) mkKeymap wKeyObj;
  inherit (lib.nixvim) mkRaw;
in {
  plugins = {
    lsp = {
      enable = true;
      inlayHints = true;
      servers = {
        typos_lsp = {
          enable = true;
          extraOptions.init_options.diagnosticSeverity = "Hint";
        };
      };
    };
    conform-nvim = {
      enable = true;
      settings = {
        format_on_save = {
          timeout_ms = 500;
        };
        default_format_opts.lsp_format = "prefer";
        formatters_by_ft = {
          "_" = [
            "squeeze_blanks"
            "trim_whitespace"
            "trim_newlines"
          ];
        };
        formatters.squeeze_blanks.command = lib.getExe' pkgs.coreutils "cat";
      };
    };
    lint.enable = true;
    trouble.enable = true;
    tiny-inline-diagnostic.enable = true;
  };

  diagnostic.settings = {
    virtual_text = false;
    underline = true;
    signs = true;
    severity_sort = true;
    float = {
      border = "rounded";
      source = "always";
      focusable = false;
    };
  };

  wKeyList = [
    (wKeyObj ["<leader>x" "" "Trouble"])
  ];

  keymaps = [
    (mkKeymap "n" "<leader>xx" "<cmd>Trouble diagnostics toggle<cr>" "Diagnostics")
    (mkKeymap "n" "<leader>xl" "<cmd>Trouble loclist toggle<cr>" "Loclist")
    (mkKeymap "n" "<leader>xq" "<cmd>Trouble qflist toggle<cr>" "Qflist")

    (mkKeymap "n" "gd" "<cmd>lua vim.lsp.buf.definition()<cr>" "Go to Definition")
    (mkKeymap "n" "gt" "<cmd>lua vim.lsp.buf.type_definition()<cr>" "Go to Type Definition")
  ];

  # SECTION: Auto Commands
  autoCmd = [
    {
      desc = "Fix all linting issues on save";
      event = "BufWritePre";
      callback = mkRaw ''
        function()
          vim.lsp.buf.code_action({
            context = { only = { "source.fixAll" } },
            apply = true,
          })
        end
      '';
    }
  ];

  imports = with builtins;
  with lib;
    map (fn: ./${fn}) (
      filter (fn: (fn != "default.nix" && !hasSuffix ".md" "${fn}")) (attrNames (readDir ./.))
    );
}
