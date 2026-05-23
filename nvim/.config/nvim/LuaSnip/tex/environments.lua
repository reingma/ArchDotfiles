local conds_expand = require("luasnip.extras.conditions.expand")
local in_mathzone = function()
  return vim.fn["vimtex#syntax#in_mathzone"]() == 1
end

return {
  -- ── Generic environment ──────────────────────────────────────────────────
  s({ trig = "beg", snippetType = "autosnippet" },
    fmta("\\begin{<>}\n\t<>\n\\end{<>}", { i(1, "env"), i(2), extras.rep(1) }),
    { condition = conds_expand.line_begin }
  ),

  -- ── Theorem-like environments ────────────────────────────────────────────
  s({ trig = "thm", snippetType = "autosnippet" },
    fmta("\\begin{theorem}[<>]\n\t<>\n\\end{theorem}", { i(1, "label"), i(2) }),
    { condition = conds_expand.line_begin }
  ),
  s({ trig = "lem", snippetType = "autosnippet" },
    fmta("\\begin{lemma}[<>]\n\t<>\n\\end{lemma}", { i(1, "label"), i(2) }),
    { condition = conds_expand.line_begin }
  ),
  s({ trig = "prop", snippetType = "autosnippet" },
    fmta("\\begin{proposition}[<>]\n\t<>\n\\end{proposition}", { i(1, "label"), i(2) }),
    { condition = conds_expand.line_begin }
  ),
  s({ trig = "cor", snippetType = "autosnippet" },
    fmta("\\begin{corollary}[<>]\n\t<>\n\\end{corollary}", { i(1, "label"), i(2) }),
    { condition = conds_expand.line_begin }
  ),
  s({ trig = "defn", snippetType = "autosnippet" },
    fmta("\\begin{definition}[<>]\n\t<>\n\\end{definition}", { i(1, "label"), i(2) }),
    { condition = conds_expand.line_begin }
  ),
  s({ trig = "prf", snippetType = "autosnippet" },
    fmta("\\begin{proof}\n\t<>\n\\end{proof}", { i(1) }),
    { condition = conds_expand.line_begin }
  ),
  s({ trig = "rem", snippetType = "autosnippet" },
    fmta("\\begin{remark}\n\t<>\n\\end{remark}", { i(1) }),
    { condition = conds_expand.line_begin }
  ),
  s({ trig = "exa", snippetType = "autosnippet" },
    fmta("\\begin{example}\n\t<>\n\\end{example}", { i(1) }),
    { condition = conds_expand.line_begin }
  ),
  s({ trig = "notn", snippetType = "autosnippet" },
    fmta("\\begin{notation}\n\t<>\n\\end{notation}", { i(1) }),
    { condition = conds_expand.line_begin }
  ),
  s({ trig = "conj", snippetType = "autosnippet" },
    fmta("\\begin{conjecture}[<>]\n\t<>\n\\end{conjecture}", { i(1, "label"), i(2) }),
    { condition = conds_expand.line_begin }
  ),
  s({ trig = "assm", snippetType = "autosnippet" },
    fmta("\\begin{assumption}[<>]\n\t<>\n\\end{assumption}", { i(1, "label"), i(2) }),
    { condition = conds_expand.line_begin }
  ),

  -- ── Display math environments ────────────────────────────────────────────
  s({ trig = "eq", snippetType = "autosnippet" },
    fmta("\\begin{equation}\\label{eq:<>}\n\t<>\n\\end{equation}", { i(1, "label"), i(2) }),
    { condition = conds_expand.line_begin }
  ),
  s({ trig = "eq*", snippetType = "autosnippet" },
    fmta("\\begin{equation*}\n\t<>\n\\end{equation*}", { i(1) }),
    { condition = conds_expand.line_begin }
  ),
  s({ trig = "ali", snippetType = "autosnippet" },
    fmta("\\begin{align}\n\t<> &= <> \\\\\\\\\n\\end{align}", { i(1), i(2) }),
    { condition = conds_expand.line_begin }
  ),
  s({ trig = "ali*", snippetType = "autosnippet" },
    fmta("\\begin{align*}\n\t<> &= <> \\\\\\\\\n\\end{align*}", { i(1), i(2) }),
    { condition = conds_expand.line_begin }
  ),
  s({ trig = "gat", snippetType = "autosnippet" },
    fmta("\\begin{gather*}\n\t<>\n\\end{gather*}", { i(1) }),
    { condition = conds_expand.line_begin }
  ),
  s({ trig = "cas", snippetType = "autosnippet" },
    fmta("\\begin{cases}\n\t<> & \\text{if } <> \\\\\\\\\n\t<> & \\text{otherwise}\n\\end{cases}", { i(1), i(2), i(3) }),
    { condition = in_mathzone }
  ),

  -- ── Matrix environments (math mode) ──────────────────────────────────────
  s({ trig = "pmat", snippetType = "autosnippet" },
    fmta("\\begin{pmatrix}\n\t<>\n\\end{pmatrix}", { i(1) }),
    { condition = in_mathzone }
  ),
  s({ trig = "bmat", snippetType = "autosnippet" },
    fmta("\\begin{bmatrix}\n\t<>\n\\end{bmatrix}", { i(1) }),
    { condition = in_mathzone }
  ),
  s({ trig = "vmat", snippetType = "autosnippet" },
    fmta("\\begin{vmatrix}\n\t<>\n\\end{vmatrix}", { i(1) }),
    { condition = in_mathzone }
  ),

  -- ── Lists ────────────────────────────────────────────────────────────────
  s({ trig = "enum", snippetType = "autosnippet" },
    fmta("\\begin{enumerate}\n\t\\item <>\n\\end{enumerate}", { i(1) }),
    { condition = conds_expand.line_begin }
  ),
  s({ trig = "items", snippetType = "autosnippet" },
    fmta("\\begin{itemize}\n\t\\item <>\n\\end{itemize}", { i(1) }),
    { condition = conds_expand.line_begin }
  ),
}
