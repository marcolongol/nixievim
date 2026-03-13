{lib, ...}: let
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
    conform-nvim.settings = {
      formatters_by_ft = {
        javascript = [ "biome" "prettier" ];
        typescript = [ "biome" "prettier" ];
        javascriptreact = [ "biome" "prettier" ];
        typescriptreact = [ "biome" "prettier" ];
        json = [ "biome" "prettier" ];
        html = [ "biome" "prettier" ];
        css = [ "biome" "prettier" ];
      };
      formatters = {
        biome.condition = mkRaw "no_prettier";
        prettier.condition = mkRaw "function(ctx) return not no_prettier(ctx) end";
      };
    };
    ts-autotag.enable = true;
    ts-comments.enable = true;
    lsp.servers = {
      angularls = {
        enable = true;
        filetypes = [ "html" "typescript" "typescriptreact" "typescript.tsx" "htmlangular" ];
        rootMarkers = [ "angular.json" "project.json" "nx.json" "tsconfig.json" ];
      };
      ts_ls.enable = true;
      eslint.enable = true;
      tailwindcss.enable = true;
      svelte.enable = true;
      jsonls.enable = true;
      html.enable = true;
      emmet_ls.enable = true;
      cssls.enable = true;
      biome.enable = true;
    };
  };
}
