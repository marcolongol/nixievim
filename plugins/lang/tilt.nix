{
  lib,
  pkgs,
  ...
}: let
  buildifier = lib.getExe pkgs.bazel-buildtools;
in {
  extraConfigLua = ''
    -- Use starlark treesitter parser for Tiltfiles
    vim.treesitter.language.register("starlark", "tiltfile")
  '';

  filetype.pattern = {
    ".*Tiltfile.*" = "tiltfile";
  };

  plugins.conform-nvim.settings = {
    formatters_by_ft.tiltfile = ["buildifier"];
    formatters.buildifier.command = buildifier;
  };

  plugins.lsp = {
    servers.tilt_ls = {
      enable = true;
      cmd = ["${lib.getExe pkgs.tilt}" "lsp" "start"];
      filetypes = ["tiltfile"];
    };
  };
}
