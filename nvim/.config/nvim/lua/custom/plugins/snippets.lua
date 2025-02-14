return {
  "L3MON4D3/LuaSnip",
  -- follow latest release.
  version = "v2.*", -- Replace <CurrentMajor> by the latest released major (first number of latest release)
  -- install jsregexp (optional!).
  build = "make install_jsregexp",
  dependencies = { "rafamadriz/friendly-snippets" },
  config = function()
    require("luasnip.loaders.from_vscode").lazy_load()
    require("luasnip.loaders.from_lua").lazy_load({ paths = "~/.config/nvim/LuaSnip/" })
    local ls = require("luasnip")
    ls.setup({ store_selection_keys = "<Tab>" })
    ls.setup({ enable_autosnippets = true })

    vim.keymap.set({ "i", "s" }, "<C-L>", function()
      ls.jump(1)
    end, { silent = true, desc = "Jump foward in the snippet" })
    vim.keymap.set({ "i", "s" }, "<C-K>", function()
      ls.jump(-1)
    end, { silent = true, desc = "Jump back in the snippet" })

    vim.keymap.set({ "i", "s" }, "<C-E>", function()
      if ls.choice_active() then
        ls.change_choice(1)
      end
    end, { silent = true })
  end,
}
