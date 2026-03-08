{...}: {
  plugins = {
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
