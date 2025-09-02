{
  description = "Nixievim, a Nix-based Neovim configuration using nixvim";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";

    nixvim.url = "github:nix-community/nixvim";

    flake-parts.url = "github:hercules-ci/flake-parts";
  };

  outputs = {
    self,
    systems,
    flake-parts,
    ...
  } @ inputs: let
    inherit (self) outputs;
  in
    flake-parts.lib.mkFlake {inherit inputs;} {
      systems = import systems;
      _module.args = {inherit inputs;};
      imports = [
        ./modules/flake
        ./overlays
        ./plugins
      ];
      flake = {
        inherit outputs;
      };
    };
}
