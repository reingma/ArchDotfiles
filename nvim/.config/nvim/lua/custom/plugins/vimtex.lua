return {
  "lervag/vimtex",
  lazy = false, -- we don't want to lazy load VimTeX
  -- tag = "v2.15", -- uncomment to pin to a specific release
  init = function()
    -- VimTeX configuration goes here, e.g.
    vim.g.vimtex_view_method = "zathura"
    vim.g.vimtex_imaps_enabled = 0
  end,
  config = function() end,
}

-- a few useful keybinds:
-- dse and cse: delete and change surrounding environment respectively
-- dsc and csc: deletes and change surrounding commands
-- dsd and csd: same as above but for delimiters
-- ds$ and cs$: same for math
-- all also have ts variants to toggle different variants of the same
-- tsf toogles fraction.
--
--
-- Navigation
-- % works
-- ]] for section navigation, [[ goes in reverse
-- ]m jumps enviroments, [m is reverse
-- ]n jumps math zones, [n is reverse
-- ]r for frames
--
--
-- Especial text objects
-- ad and id - delimiters
-- ac and ic - latex commands
-- ae and ie - enviroments
-- a$ and i$ - math
-- aP and iP - sessions
-- am and im - items in enumerate and itemize
