{inputs, ...}: {
  perSystem = {
    config,
    pkgs,
    ...
  }: {
    devShells.default = pkgs.mkShell rec {
      name = "nixievim";
      meta.description = "Dev environment for nixievim";
      inputsFrom = [];
      packages = with pkgs; [
        nixd
        nix-output-monitor
        alejandra
        statix
        deadnix
      ];
      shellHook = ''
        echo 1>&2 "🐼: $(id -un) | 🧬: $(nix eval --raw --impure --expr 'builtins.currentSystem') | 🐧: $(uname -r) "
        echo 1>&2 "Ready to work on ${name}!"
      '';
    };
  };
}
