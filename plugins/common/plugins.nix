{
  pkgs,
  config,
  ...
}: let
in {
  extraPlugins = with pkgs.vimPlugins; [stay-centered-nvim];
  plugins = {
    # Must have plugins to have a decent flow of work
    comment.enable = true;
    web-devicons.enable = true;
    nvim-surround.enable = true;
    nvim-autopairs.enable = true;
    tmux-navigator.enable = true;
    trim.enable = true;
    smart-splits.enable = true;
    lualine.enable = true;
    lz-n.enable = true;
    which-key = {
      enable = true;
      settings.spec = config.wKeyList;
      settings.preset = "modern";
    };
  };
  opts = {
    timeout = true;
    timeoutlen = 250;
  };
}
