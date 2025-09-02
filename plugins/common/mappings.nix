{ config
, lib
, ...
}:
let
  inherit (config.nixievim.mkKey) mkKeymap mkKeymapWithOpts wKeyObj;
  inherit (lib.nixvim) mkRaw;

  v = [
    (mkKeymap "v" "<a-j>" ":m '>+1<cr>gv-gv" "Move Selected Line Down")
    (mkKeymap "v" "<a-k>" ":m '<lt>-2<CR>gv-gv" "Move Selected Line Up")

    (mkKeymap "v" "<" "<gv" "Indent out")
    (mkKeymap "v" ">" ">gv" "Indent in")
  ];

  xv = [ ];

  insert = [
    (mkKeymap "i" "<a-j>" "<esc>:m .+1<cr>==gi" "Move Line Down")
    (mkKeymap "i" "<a-k>" "<esc>:m .-2<cr>==gi" "Move Line Up")
  ];

  normal = [
    (mkKeymap "n" "<c-a-h>" ":lua require('smart-splits').resize_left()<cr>" "Resize Left")
    (mkKeymap "n" "<c-a-j>" ":lua require('smart-splits').resize_down()<cr>" "Resize Down")
    (mkKeymap "n" "<c-a-k>" ":lua require('smart-splits').resize_up()<cr>" "Resize Up")
    (mkKeymap "n" "<c-a-l>" ":lua require('smart-splits').resize_right()<cr>" "Resize Right")
    (mkKeymap "n" "<c-h>" ":lua require('smart-splits').move_cursor_left()<cr>" "Move Cursor Left")
    (mkKeymap "n" "<c-j>" ":lua require('smart-splits').move_cursor_down()<cr>" "Move Cursor Down")
    (mkKeymap "n" "<c-k>" ":lua require('smart-splits').move_cursor_up()<cr>" "Move Cursor Up")
    (mkKeymap "n" "<c-l>" ":lua require('smart-splits').move_cursor_right()<cr>" "Move Cursor Right")

    (mkKeymap "n" "<c-a>" "ggVG" "select All")

    (mkKeymap "n" "<leader>sv" "<cmd>vsplit<cr>" "vertical split")
    (mkKeymap "n" "<leader>sh" "<cmd>split<cr>" "horizontal split")

    (mkKeymap "n" "<leader>h" "<cmd>nohlsearch<cr>" "clear search highlights")

    (mkKeymap "n" "<leader>c" "<cmd>bdelete<cr>" "close buffer")
    (mkKeymap "n" "<leader>q" "<cmd>q<cr>" "quit")
  ];
in
{
  keymaps = insert ++ normal ++ v ++ xv;

  wKeyList = [
    (wKeyObj [ "<leader>A" "" "true" ])
    (wKeyObj [ "<leader><leader>" "" "true" ])
    (wKeyObj [ "<leader>s" "󰒺" "split" ])
  ];
}
