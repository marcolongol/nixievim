{self, ...}: {
  flake.homeManagerModules.default = {
    config,
    lib,
    pkgs,
    ...
  }: let
    cfg = config.programs.nixievim;
    packages = self.packages.${pkgs.stdenv.hostPlatform.system};
  in {
    options.programs.nixievim = {
      enable = lib.mkEnableOption "nixievim";
      package = lib.mkOption {
        type = lib.types.package;
        default = packages.default;
        defaultText = lib.literalExpression "nixievim.packages.\${system}.default";
        description = "Nixievim package to install.";
      };
      defaultEditor = lib.mkEnableOption "nixievim as $EDITOR";
      neovide = {
        enable = lib.mkEnableOption "neovide frontend for nixievim";
        package = lib.mkOption {
          type = lib.types.package;
          default = packages.neovide;
          defaultText = lib.literalExpression "nixievim.packages.\${system}.neovide";
          description = "Neovide wrapper package to install.";
        };
      };
    };

    config = lib.mkIf cfg.enable {
      home.packages = [cfg.package] ++ lib.optional cfg.neovide.enable cfg.neovide.package;
      home.sessionVariables = lib.mkIf cfg.defaultEditor {EDITOR = "nvim";};
    };
  };
}
