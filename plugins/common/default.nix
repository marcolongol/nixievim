{
  config,
  lib,
  ...
}: let
  inherit (lib.nixvim) mkRaw;
in {
  # SECTION: Imports
  imports = with builtins;
  with lib;
  # Import all .nix files in the current directory except this one and markdown files
    map (fn: ./${fn}) (
      filter (fn: (fn != "default.nix" && !hasSuffix ".md" "${fn}")) (attrNames (readDir ./.))
    );

  extraConfigLua = ''
    vim.opt.whichwrap:append("<>[]hl")
    vim.opt.listchars:append("space:·")

    -- below part set's the Diagnostic icons/colors
    local signs = {
      Hint = "💡";
      Error = "\u{ea87}",
      Warn = "\u{f071}",
      Info = "\u{f05a}",
    }

    for type, icon in pairs(signs) do
      local hl = "DiagnosticSign" .. type
      vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
    end
  '';

  # SECTION: Options
  enableMan = true;
  # enablePrintInit = true;
  luaLoader.enable = false;

  extraLuaPackages = lp: with lp; [luarocks];

  globals = {
    mapleader = " ";
    floating_window_border = "rounded";
  };

  clipboard = {
    providers.wl-copy.enable = true;
    register = "unnamedplus";
  };

  opts = {
    # MOUSE
    mouse = "a";

    # CURSOR & DISPLAY
    cursorline = true;
    cursorcolumn = false;
    termguicolors = true;
    conceallevel = 2;

    # POPUP MENU
    pumblend = 0;
    pumheight = 10;

    # INDENTATION & TABS
    expandtab = true;
    shiftwidth = 2;
    smartindent = true;
    tabstop = 2;
    softtabstop = 2;

    # SEARCH
    ignorecase = true;
    smartcase = true;

    # LINE NUMBERS & RULER
    number = true;
    relativenumber = true;
    numberwidth = 2;
    ruler = false;

    # WINDOW & SPLIT BEHAVIOR
    splitbelow = true;
    splitright = true;
    splitkeep = "screen";
    signcolumn = "yes";
    colorcolumn = "87";
    winminwidth = 5;

    # FILE HANDLING
    fileencoding = "utf-8";
    autoread = true;
    autowrite = true;
    swapfile = false;
    undofile = true;

    # TEXT DISPLAY & WRAPPING
    wrap = false;
    list = true;
    smoothscroll = true;
    virtualedit = "block";
    fillchars = {
      eob = " ";
    };
    foldcolumn = "1";
    foldlevel = 99;
    foldlevelstart = -1;
    foldenable = true;

    # INTERFACE
    cmdheight = 0;
    updatetime = 300;
  };

  # SECTION: Auto Commands
  autoCmd = [
    {
      desc = "Highlight on yank";
      event = ["TextYankPost"];
      callback =
        mkRaw
        ''
          function()
            vim.highlight.on_yank()
          end
        '';
    }
  ];
}
