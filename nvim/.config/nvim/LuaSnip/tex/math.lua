-- Place this in ${HOME}/.config/nvim/LuaSnip/all.lua
require("luasnip-helpers")
return {
  -- Examples of Greek letter snippets, autotriggered for efficiency
  s({ trig = ";a", snippetType = "autosnippet" }, {
    t("\\alpha"),
  }),
  s({ trig = ";b", snippetType = "autosnippet" }, {
    t("\\beta"),
  }),
  s({ trig = ";g", snippetType = "autosnippet" }, {
    t("\\gamma"),
  }),
  s({ trig = ";o", snippetType = "autosnippet" }, {
    t("\\omega"),
  }),
  s({ trig = ";d", snippetType = "autosnippet" }, {
    t("\\delta"),
  }),
  s({ trig = ";e", snippetType = "autosnippet" }, {
    t("\\epsilon"),
  }),
  s({ trig = ";t", snippetType = "autosnippet" }, {
    t("\\tau"),
  }),
  s({ trig = ";p", snippetType = "autosnippet" }, {
    t("\\pi"),
  }),
  s({ trig = ";l", snippetType = "autosnippet" }, {
    t("\\lambda"),
  }),
  s({ trig = ";ra", snippetType = "autosnippet" }, {
    t("\\rightarrow"),
  }),
  s({ trig = ";la", snippetType = "autosnippet" }, {
    t("\\leftarrow"),
  }),
  s({ trig = ";re", snippetType = "autosnippet" }, {
    t("\\mathbb{R}"),
  }),
  s({ trig = ";ci", snippetType = "autosnippet" }, {
    t("\\circ"),
  }),
}
