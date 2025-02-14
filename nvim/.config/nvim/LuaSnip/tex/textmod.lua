local help = require("luasnip-helpers")
return {
  -- Example: italic font implementing visual selection
  s(
    { trig = "tii", dscr = "Expands 'tii' into LaTeX's textit{} command." },
    fmta("\\textit{<>}", {
      d(1, help.get_visual),
    })
  ),
  s(
    { trig = "tbf", dscr = "Expands 'tbf' into LaTeX's textit{} command." },
    fmta("\\textbf{<>}", {
      d(1, help.get_visual),
    })
  ),
  s(
    { trig = "tul", dscr = "Expands 'tul' into LaTeX's underline{} command." },
    fmta("\\underline{<>}", {
      d(1, help.get_visual),
    })
  ),
  s(
    { trig = "can", dscr = "adds cancel command" },
    fmta("\\cancel{<>}", {
      d(1, help.get_visual),
    })
  ),
}
