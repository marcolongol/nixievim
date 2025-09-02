{
  self,
  inputs,
  ...
}: {
  imports = [./devshell.nix];
  perSystem = {
    lib,
    system,
    pkgs,
    ...
  }: {
    _module.args = {
      flake = {inherit inputs self;};
      pkgs = import inputs.nixpkgs {
        inherit system;
        overlays = lib.attrValues self.overlays;
        config.allowUnfree = true;
      };
    };

    formatter = pkgs.alejandra;

    imports = [
      (self + /packages)
    ];
  };
}
