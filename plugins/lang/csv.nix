{
  pkgs,
  config,
  ...
}: let
  inherit (config.nixievim.mkKey) mkKeymap wKeyObj;
in {
  extraPlugins = [pkgs.vimPlugins.rainbow_csv];

  keymaps = [
    (mkKeymap "n" "<leader>ra" "<cmd>RainbowAlign<cr>" "Align columns")
    (mkKeymap "n" "<leader>rs" "<cmd>RainbowShrink<cr>" "Shrink columns")
    (mkKeymap "n" "<leader>rq" ":Select " "RBQL query")
  ];

  wKeyList = [
    (wKeyObj ["<leader>r" "󰹢" "rainbow csv"])
  ];
}
