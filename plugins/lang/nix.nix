{
  lib,
  pkgs,
  ...
}: {
  plugins = {
    lint = {
      lintersByFt = {
        nix = ["deadnix"];
      };
      linters = {
        deadnix = {
          cmd = lib.getExe pkgs.deadnix;
        };
      };
    };
    lsp.servers = {
      nixd = {
        enable = true;
        settings = {
          nixpkgs.expr = "import <nixpkgs> {}";
          formatting.command = ["alejandra"];
        };
      };
      statix.enable = true;
    };
  };
}
