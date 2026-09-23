-- Neovim 0.12+ has built-in treesitter highlighting — no nvim-treesitter needed.
-- Bundled parsers: c, lua, vim, vimdoc, query, markdown, markdown_inline
-- This plugin handles installation of everything else.
return {
  {
    "romus204/tree-sitter-manager.nvim",
    build = ":TSMUpdate",
    config = function()
      require("tree-sitter-manager").setup({
        -- only list parsers NOT bundled in 0.12
        ensure_installed = { "cpp", "rust", "json", "yaml", "bash" },
        auto_install = false,
        highlight = false, -- 0.12 enables this automatically
      })

      -- disable treesitter in floating windows (hover, etc.) and large files
      vim.api.nvim_create_autocmd("BufWinEnter", {
        group = vim.api.nvim_create_augroup("ts-disable", { clear = true }),
        callback = function(args)
          local buf = args.buf
          for _, win in ipairs(vim.fn.win_findbuf(buf)) do
            if vim.api.nvim_win_get_config(win).relative ~= "" then
              pcall(vim.treesitter.stop, buf)
              return
            end
          end
          local ok, stats = pcall(vim.uv.fs_stat, vim.api.nvim_buf_get_name(buf))
          if ok and stats and stats.size > 100 * 1024 then
            pcall(vim.treesitter.stop, buf)
          end
        end,
      })
    end,
  },
}
