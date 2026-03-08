{
  lib,
  pkgs,
  ...
}: {
  plugins = {
    helm.enable = true;
    schemastore = {
      enable = true;
      yaml.enable = true;
    };
    lsp.servers = {
      yamlls.enable = true;
      helm_ls.enable = true;
    };
    lint = {
      lintersByFt = {
        yaml = ["yamllint"];
        helm = ["yamllint"];
      };
      linters = {
        yamllint = {
          cmd = lib.getExe pkgs.yamllint;
        };
      };
    };
  };
  autoCmd = [
    {
      event = "FileType";
      pattern = "helm";
      command = "LspRestart";
    }
  ];
}
