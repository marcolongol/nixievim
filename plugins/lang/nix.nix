{
  lib,
  pkgs,
  inputs,
  self,
  ...
}: let
  inherit (lib.nixvim) mkRaw;
  inherit (pkgs.stdenv.hostPlatform) system;
  # Going through nixievim's own flake keeps its `follows` overrides, which a
  # bare `getFlake "${inputs.nixvim}"` would lose.
  nixievim = ''(builtins.getFlake "${self}")'';
in {
  plugins = {
    lint = {
      lintersByFt.nix = ["statix" "deadnix"];
      linters = {
        statix.cmd = lib.getExe pkgs.statix;
        deadnix.cmd = lib.getExe pkgs.deadnix;
      };
    };
    conform-nvim.settings = {
      formatters_by_ft.nix = ["alejandra"];
      formatters.alejandra.command = lib.getExe pkgs.alejandra;
    };
    lsp.servers.nixd = {
      enable = true;
      settings = {
        nixpkgs.expr = "import ${inputs.nixpkgs} {}";
        options = {
          nixvim.expr = "${nixievim}.inputs.nixvim.legacyPackages.${system}.nixvimConfiguration.options";
          flake-parts.expr = "(${nixievim}.inputs.flake-parts.lib.evalFlakeModule {inputs.self = {};} {}).options";
        };
      };
      # When the project root is a flake, use its nixpkgs and, if it defines
      # nixosConfigurations, the first host's NixOS + home-manager options.
      extraOptions.before_init = mkRaw ''
        function(_, config)
          local root = config.root_dir
          if not root or vim.fn.filereadable(root .. "/flake.nix") == 0 then
            return
          end
          local flake = ("(builtins.getFlake %s)"):format(vim.json.encode(root))
          local nixos = ("(let hosts = builtins.attrValues (%s.nixosConfigurations or {}); in if hosts == [] then {} else (builtins.head hosts).options)")
            :format(flake)
          -- Mutate in place: the client keeps a reference to this table.
          local s = config.settings.nixd
          s.nixpkgs.expr = ("import (%s.inputs.nixpkgs or <nixpkgs>) {}"):format(flake)
          s.options.nixos = { expr = nixos }
          s.options.home_manager = {
            expr = ("((%s.home-manager.users.type.getSubOptions or (_: {})) [])"):format(nixos),
          }
        end
      '';
    };
  };
}
