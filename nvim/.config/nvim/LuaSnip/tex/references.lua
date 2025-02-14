local s = require("luasnip").snippet
local sn = require("luasnip").snippet_node
return {
  s(
    { trig = "href", dscr = "Hyperlink package href command (urls)" },
    fmta([[\href{<>}{<>}]], { i(1, "url"), i(2, "display name") })
  ),
}
