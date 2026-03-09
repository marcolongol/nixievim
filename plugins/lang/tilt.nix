{
  lib,
  pkgs,
  ...
}: {
  extraConfigLua = ''
    -- Use starlark treesitter parser for Tiltfiles
    vim.treesitter.language.register("starlark", "tiltfile")
  '';

  filetype.pattern = {
    ".*Tiltfile.*" = "tiltfile";
  };

  plugins.lsp = {
    servers.tilt_ls = {
      enable = true;
      cmd = ["${lib.getExe pkgs.tilt}" "lsp" "start"];
      filetypes = ["tiltfile"];
    };
  };
}
