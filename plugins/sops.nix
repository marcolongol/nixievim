{
  lib,
  pkgs,
  ...
}: {
  imports = [
    (lib.nixvim.plugins.mkNeovimPlugin {
      name = "nvim-sops";
      moduleName = "nvim_sops";
      url = "https://github.com/prismatic-koi/nvim-sops";
      maintainers = [];
      extraPackages = [pkgs.sops];
      settingsExample = {
        enabled = true;
        debug = false;
        binPath = "sops";
        defaults = {
          ageKeyFile = "$SOPS_AGE_KEY_FILE";
        };
      };
    })
  ];

  plugins.nvim-sops = {
    enable = true;
    package = pkgs.vimUtils.buildVimPlugin {
      pname = "nvim-sops";
      version = "2026-01-29";
      src = pkgs.fetchFromGitHub {
        owner = "prismatic-koi";
        repo = "nvim-sops";
        rev = "1791eec21e78c9736ae504f02712a2f509c69b2c";
        hash = "sha256-PkCZZuigHAAlGNcVD/bBTkGyZs9e3tgmnaDuPpKrBKM=";
      };
    };
  };

  # Transparent decrypt on open, re-encrypt on save.
  # SopsEncrypt/SopsDecrypt call `edit` internally, re-triggering BufReadPost
  # and causing a re-entrant cycle that leaves the file unencrypted.
  # Instead we call sops directly via vim.fn.system, using the plugin's
  # configured binPath. The plugin still provides manual :SopsEncrypt /
  # :SopsDecrypt commands and handles env var configuration.
  #
  # Strategy: file on disk stays encrypted at all times.
  # BufReadPost: decrypt via sops stdout -> buffer (file untouched on disk).
  # BufWriteCmd: write decrypted buffer to file, sops --encrypt --in-place.
  #   sops walks the directory tree to find .sops.yaml creation rules naturally.
  # BufWriteCmd is registered per-buffer only when sops is detected.
  extraConfigLua =
    # lua
    ''
      local sops_group = vim.api.nvim_create_augroup("NvimSopsAuto", { clear = true })

      local function sops_bin()
        local ok, m = pcall(require, "nvim_sops")
        return (ok and m.config and m.config.binPath) or "sops"
      end

      vim.api.nvim_create_autocmd("BufReadPost", {
        group = sops_group,
        callback = function(ev)
          local lines = vim.api.nvim_buf_get_lines(ev.buf, 0, 30, false)
          if not table.concat(lines, "\n"):find("ENC%[") then return end

          local path = vim.api.nvim_buf_get_name(ev.buf)
          local decrypted = vim.fn.system({ sops_bin(), "--decrypt", path })
          if vim.v.shell_error ~= 0 then
            vim.notify("sops: failed to decrypt " .. vim.fn.fnamemodify(path, ":t"), vim.log.levels.ERROR)
            return
          end

          local dec_lines = vim.split(decrypted, "\n", { plain = true })
          if dec_lines[#dec_lines] == "" then table.remove(dec_lines) end

          -- Clear undo history so the user can't undo back to encrypted content
          local ul = vim.bo[ev.buf].undolevels
          vim.bo[ev.buf].undolevels = -1
          vim.api.nvim_buf_set_lines(ev.buf, 0, -1, false, dec_lines)
          vim.bo[ev.buf].undolevels = ul
          vim.bo[ev.buf].modified = false

          -- Register a buffer-local write handler so normal files are unaffected
          vim.api.nvim_create_autocmd("BufWriteCmd", {
            group = sops_group,
            buffer = ev.buf,
            callback = function()
              local buf_lines = vim.api.nvim_buf_get_lines(ev.buf, 0, -1, false)

              -- Write decrypted content to disk so sops --encrypt --in-place
              -- can find .sops.yaml by walking up the directory tree naturally
              local f = io.open(path, "w")
              if not f then
                vim.notify("sops: failed to write " .. vim.fn.fnamemodify(path, ":t"), vim.log.levels.ERROR)
                return
              end
              f:write(table.concat(buf_lines, "\n"))
              f:close()

              local out = vim.fn.system({ sops_bin(), "--encrypt", "--in-place", path })
              if vim.v.shell_error ~= 0 then
                vim.notify("sops: failed to encrypt " .. vim.fn.fnamemodify(path, ":t") .. ": " .. out, vim.log.levels.ERROR)
                return
              end

              vim.bo[ev.buf].modified = false
              vim.notify('"' .. vim.fn.fnamemodify(path, ":t") .. '" [sops] written', vim.log.levels.INFO)
            end,
          })
        end,
      })
    '';
}
