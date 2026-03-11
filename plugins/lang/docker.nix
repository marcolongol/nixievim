{
  lib,
  pkgs,
  ...
}: {
  plugins = {
    lsp.servers.dockerls.enable = true;

    conform-nvim.settings = {
      formatters_by_ft.dockerfile = ["hadolint"];
      formatters.hadolint.command = lib.getExe pkgs.hadolint;
    };

    lint = {
      lintersByFt.dockerfile = ["hadolint"];
      linters.hadolint.cmd = lib.getExe pkgs.hadolint;
    };
  };
}
