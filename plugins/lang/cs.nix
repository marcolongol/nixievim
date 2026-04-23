{...}: {
  plugins = {
    # roslyn-nvim plugin: bundles roslyn-ls binary and handles sln/csproj target picking
    roslyn.enable = true;

    lsp.servers = {
      # csharp_ls as a lighter fallback/companion for files outside roslyn's scope
      csharp_ls.enable = true;
    };

    conform-nvim.settings.formatters_by_ft.cs = ["csharpier"];
  };
}
