{
  flake,
  pkgs,
  inputs',
  self',
  ...
}: let
  mkNixvim = module:
    inputs'.nixvim.legacyPackages.makeNixvimWithModule {
      extraSpecialArgs = {inherit inputs self;};
      inherit module pkgs;
    };
  inherit (flake) inputs self;
  baseModules = [
    self.nixiePlugins.common
    self.nixiePlugins.neo-tree
    self.nixiePlugins.bufferline
    self.nixiePlugins.treesitter
    self.nixiePlugins.git
    self.nixiePlugins.ux
    self.nixiePlugins.snacks
  ];
  coreModules =
    baseModules
    ++ [
      self.nixiePlugins.firenvim
      self.nixiePlugins.ai
      self.nixiePlugins.blink-cmp
      self.nixiePlugins.lsp
      self.nixiePlugins.lang
      self.nixiePlugins.sops
    ];
  neovideModules = coreModules ++ [self.nixiePlugins.neovide];
in {
  packages = {
    default = self'.packages.core;
    base = mkNixvim baseModules;
    core = mkNixvim coreModules;
    neovide = pkgs.writeShellScriptBin "neovide" ''
      exec ${pkgs.neovide}/bin/neovide --neovim-bin ${mkNixvim neovideModules}/bin/nvim "$@"
    '';
  };
}
