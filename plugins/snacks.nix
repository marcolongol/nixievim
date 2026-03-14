{
  config,
  lib,
  ...
}: let
  inherit (lib.nixvim) mkRaw;
  inherit (config.nixievim.mkKey) mkKeymap wKeyObj;
in {
  extraConfigLua = ''
    vim.api.nvim_set_hl(0, "SnacksDashboardHeader", { fg = "#7aa2f7" })
    vim.api.nvim_create_autocmd("ColorScheme", {
      callback = function()
        vim.api.nvim_set_hl(0, "SnacksDashboardHeader", { fg = "#7aa2f7" })
      end,
    })
  '';

  plugins.snacks = {
    enable = true;
    settings = {
      # Always-on visual enhancements
      indent = {
        enabled = true;
        animate.enabled = true;
      };
      scroll.enabled = true;
      statuscolumn.enabled = true;
      words.enabled = true;

      # Interactive features
      dim.enabled = true;
      zen.enabled = true;
      rename.enabled = true;
      gitbrowse.enabled = true;

      # Notifications handled by noice
      notifier.enabled = false;

      terminal.enabled = true;
      lazygit.enabled = true;

      picker = {
        enabled = true;
        sources.buffers.win.input.keys = mkRaw ''
          {
            ["<c-d>"] = { "bufdelete", mode = { "i", "n" } },
          }
        '';
      };

      dashboard = {
        enabled = true;
        sections = [
          {section = "header";}
          {
            text = mkRaw ''
              (function()
                local h = tonumber(vim.fn.strftime("%H"))
                local greet = h < 5  and "  Good night"
                           or h < 12 and "  Good morning"
                           or h < 18 and "  Good afternoon"
                           or            "  Good evening"
                local user = (os.getenv("USER") or ""):gsub("^%l", string.upper)
                return {
                  { greet .. ", " .. user .. "  —  " .. os.date("%A, %B %d"),
                    hl = "SnacksDashboardHeader", align = "center" },
                }
              end)()
            '';
            padding = 1;
          }
          {
            section = "keys";
            gap = 1;
            padding = 1;
          }
          {
            icon = " ";
            title = "Recent Files";
            section = "recent_files";
            indent = 2;
            cwd = true;
            limit = 5;
            padding = 1;
          }
          {
            icon = " ";
            title = "Projects";
            section = "projects";
            indent = 2;
            limit = 5;
            padding = 1;
          }
        ];
        preset.keys = [
          {
            icon = " ";
            key = "f";
            desc = "Find File";
            action = mkRaw ''function() Snacks.picker.files() end'';
          }
          {
            icon = " ";
            key = "g";
            desc = "Find Text";
            action = mkRaw ''function() Snacks.picker.grep() end'';
          }
          {
            icon = " ";
            key = "r";
            desc = "Recent Files";
            action = mkRaw ''function() Snacks.picker.recent() end'';
          }
          {
            icon = " ";
            key = "n";
            desc = "New File";
            action = ":ene | startinsert";
          }
          {
            icon = "";
            key = "o";
            desc = "Random XKCD";
            action = mkRaw ''
              function()
                local url = "https://c.xkcd.com/random/comic/"
                local open_cmd
                if vim.fn.has("macunix") == 1 then open_cmd = "open"
                elseif vim.fn.has("unix") == 1 then open_cmd = "xdg-open"
                elseif vim.fn.has("win32") == 1 or vim.fn.has("win64") == 1 then open_cmd = "start"
                else vim.notify("Unsupported OS for opening URLs", vim.log.levels.ERROR) return end
                vim.fn.jobstart({ open_cmd, url }, { detach = true })
              end
            '';
          }
          {
            icon = "󰅙 ";
            key = "q";
            desc = "Quit";
            action = ":quitall!";
          }
        ];
      };
    };
  };

  wKeyList = [
    (wKeyObj ["<leader>l" "󰅩" "LSP"])
    (wKeyObj ["<leader>gg" "" "lazygit"])
    (wKeyObj ["<leader>f" "" "Find"])
    (wKeyObj ["<leader>D" "󰕮" "Dashboard"])
  ];

  keymaps = [
    (mkKeymap "n" "<leader>gg" "<cmd>lua Snacks.lazygit()<cr>" "LazyGit")

    # LSP navigation
    (mkKeymap "n" "gd" "<cmd>lua Snacks.picker.lsp_definitions()<cr>" "Go to Definition")
    (mkKeymap "n" "gr" "<cmd>lua Snacks.picker.lsp_references()<cr>" "Go to References")
    (mkKeymap "n" "gi" "<cmd>lua Snacks.picker.lsp_implementations()<cr>" "Go to Implementation")
    (mkKeymap "n" "gt" "<cmd>lua Snacks.picker.lsp_type_definitions()<cr>" "Go to Type Definition")
    (mkKeymap "n" "<leader>ls" "<cmd>lua Snacks.picker.lsp_symbols()<cr>" "Document Symbols")
    (mkKeymap "n" "<leader>lS" "<cmd>lua Snacks.picker.lsp_workspace_symbols()<cr>" "Workspace Symbols")

    # Find
    (mkKeymap "n" "<leader>ff" "<cmd>lua Snacks.picker.files()<cr>" "Find files")
    (mkKeymap "n" "<leader>fg" "<cmd>lua Snacks.picker.grep()<cr>" "Live grep")
    (mkKeymap "n" "<leader>fb" "<cmd>lua Snacks.picker.buffers()<cr>" "Find buffers")
    (mkKeymap "n" "<leader>fh" "<cmd>lua Snacks.picker.help()<cr>" "Find help")
    (mkKeymap "n" "<leader>fr" "<cmd>lua Snacks.picker.recent()<cr>" "Recent files")
    (mkKeymap "n" "<leader>fd" "<cmd>lua Snacks.picker.diagnostics()<cr>" "Diagnostics")

    # Git
    (mkKeymap "n" "<leader>go" "<cmd>lua Snacks.gitbrowse()<cr>" "Open in browser")

    # UI toggles
    (mkKeymap "n" "<leader>D" "<cmd>lua Snacks.dashboard()<cr>" "Open Dashboard")
    (mkKeymap "n" "<leader>z" "<cmd>lua Snacks.zen()<cr>" "Zen mode")
    (mkKeymap "n" "<leader>ud" "<cmd>lua Snacks.dim.toggle()<cr>" "Toggle dim")
    (mkKeymap "n" "<leader>N" "<cmd>lua Snacks.notifier.show_history()<cr>" "Notification history")

    # File rename
    (mkKeymap "n" "<leader>tr" "<cmd>lua Snacks.rename.rename_file()<cr>" "Rename file")

    # Word jumps
    (mkKeymap "n" "]]" "<cmd>lua Snacks.words.jump(1)<cr>" "Next word occurrence")
    (mkKeymap "n" "[[" "<cmd>lua Snacks.words.jump(-1)<cr>" "Prev word occurrence")
  ];
}
