{
  lib,
  config,
  pkgs,
  ...
}: let
  inherit (config.nixievim.mkKey) mkKeymap wKeyObj;
  inherit (lib.nixvim) mkRaw;
in {
  extraConfigLuaPre = ''
    -- Returns true if no prettier config is found upward from the buffer's directory
    no_prettier = function(ctx)
      local prettier_files = { ".prettierrc", ".prettierrc.js", ".prettierrc.cjs", ".prettierrc.json", ".prettierrc.yml", ".prettierrc.yaml", "prettier.config.js", "prettier.config.cjs" }
      if vim.fs.find(prettier_files, { upward = true, path = ctx.dirname })[1] then
        return false
      end
      local pkg = vim.fs.find("package.json", { upward = true, path = ctx.dirname })[1]
      if pkg then
        local ok, decoded = pcall(vim.fn.json_decode, vim.fn.readfile(pkg))
        if ok and decoded and decoded.prettier then return false end
      end
      return true
    end
  '';

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
          javascript = [{ name = "biome"; condition = mkRaw "no_prettier"; }];
          typescript = [{ name = "biome"; condition = mkRaw "no_prettier"; }];
          javascriptreact = [{ name = "biome"; condition = mkRaw "no_prettier"; }];
          typescriptreact = [{ name = "biome"; condition = mkRaw "no_prettier"; }];
          json = [{ name = "biome"; condition = mkRaw "no_prettier"; }];
          html = [{ name = "biome"; condition = mkRaw "no_prettier"; }];
          css = [{ name = "biome"; condition = mkRaw "no_prettier"; }];
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
