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
  ];
  coreModules =
    baseModules
    ++ [
      self.nixiePlugins.firenvim
      self.nixiePlugins.ai
      self.nixiePlugins.blink-cmp
      self.nixiePlugins.telescope
      self.nixiePlugins.lsp
      self.nixiePlugins.lang
      self.nixiePlugins.dashboard
    ];
in {
  packages = {
    default = self'.packages.core;
    base = mkNixvim baseModules;
    core = mkNixvim coreModules;
  };
}
