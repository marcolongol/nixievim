{...}: {
  plugins = {
    ts-autotag.enable = true;
    ts-comments.enable = true;
    lsp.servers = {
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
