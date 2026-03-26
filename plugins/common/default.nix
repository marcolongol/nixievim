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

    -- Diagnostic signs (new API, replaces deprecated sign_define)
    vim.diagnostic.config({
      signs = {
        text = {
          [vim.diagnostic.severity.ERROR] = "\xef\x80\x97", -- nf-fa-times_circle
          [vim.diagnostic.severity.WARN]  = "\xef\x81\xb1", -- nf-fa-exclamation_triangle
          [vim.diagnostic.severity.INFO]  = "\xef\x81\x9a", -- nf-fa-info_circle
          [vim.diagnostic.severity.HINT]  = "\xef\x83\xab", -- nf-fa-lightbulb_o
        },
      },
    })
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
    whichwrap = "b,s,<,>,[,],h,l";

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
    listchars = {
      tab = "→ ";
      eol = "↓";
      trail = "·";
      nbsp = "␣";
      extends = "»";
      precedes = "«";
      space = "·";
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
