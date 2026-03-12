{pkgs, ...}: {
  plugins = {
    lsp.servers.prismals = {
      enable = true;
      package = pkgs.prisma-language-server;
    };
    conform-nvim.settings.formatters_by_ft.prisma = ["prisma_format"];
  };
}