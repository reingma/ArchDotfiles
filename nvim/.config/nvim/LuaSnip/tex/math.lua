require("luasnip-helpers")

local in_mathzone = function()
  return vim.fn["vimtex#syntax#in_mathzone"]() == 1
end
local conds_expand = require("luasnip.extras.conditions.expand")

return {
  -- ── Greek letters (;prefix, tex-only autosnippets) ──────────────────────
  -- Lowercase
  -- Note: ;th=θ blocked by ;t=τ → use `theta` trigger in math mode instead
  --       ;ps=ψ blocked by ;p=π → use `psi` trigger in math mode instead
  s({ trig = ";a",   snippetType = "autosnippet" }, { t("\\alpha") }),
  s({ trig = ";b",   snippetType = "autosnippet" }, { t("\\beta") }),
  s({ trig = ";g",   snippetType = "autosnippet" }, { t("\\gamma") }),
  s({ trig = ";d",   snippetType = "autosnippet" }, { t("\\delta") }),
  s({ trig = ";e",   snippetType = "autosnippet" }, { t("\\epsilon") }),
  s({ trig = ";z",   snippetType = "autosnippet" }, { t("\\zeta") }),
  s({ trig = ";h",   snippetType = "autosnippet" }, { t("\\eta") }),
  s({ trig = ";k",   snippetType = "autosnippet" }, { t("\\kappa") }),
  s({ trig = ";l",   snippetType = "autosnippet" }, { t("\\lambda") }),
  s({ trig = ";m",   snippetType = "autosnippet" }, { t("\\mu") }),
  s({ trig = ";n",   snippetType = "autosnippet" }, { t("\\nu") }),
  s({ trig = ";x",   snippetType = "autosnippet" }, { t("\\xi") }),
  s({ trig = ";p",   snippetType = "autosnippet" }, { t("\\pi") }),
  s({ trig = ";rh",  snippetType = "autosnippet" }, { t("\\rho") }),
  s({ trig = ";s",   snippetType = "autosnippet" }, { t("\\sigma") }),
  s({ trig = ";t",   snippetType = "autosnippet" }, { t("\\tau") }),
  s({ trig = ";f",   snippetType = "autosnippet" }, { t("\\varphi") }),
  s({ trig = ";ch",  snippetType = "autosnippet" }, { t("\\chi") }),
  s({ trig = ";o",   snippetType = "autosnippet" }, { t("\\omega") }),
  -- Uppercase (capital second char avoids all lowercase conflicts)
  s({ trig = ";Ga",  snippetType = "autosnippet" }, { t("\\Gamma") }),
  s({ trig = ";De",  snippetType = "autosnippet" }, { t("\\Delta") }),
  s({ trig = ";Th",  snippetType = "autosnippet" }, { t("\\Theta") }),
  s({ trig = ";La",  snippetType = "autosnippet" }, { t("\\Lambda") }),
  s({ trig = ";Xi",  snippetType = "autosnippet" }, { t("\\Xi") }),
  s({ trig = ";Pi",  snippetType = "autosnippet" }, { t("\\Pi") }),
  s({ trig = ";Si",  snippetType = "autosnippet" }, { t("\\Sigma") }),
  s({ trig = ";Ph",  snippetType = "autosnippet" }, { t("\\Phi") }),
  s({ trig = ";Ps",  snippetType = "autosnippet" }, { t("\\Psi") }),
  s({ trig = ";Om",  snippetType = "autosnippet" }, { t("\\Omega") }),
  s({ trig = ";Up",  snippetType = "autosnippet" }, { t("\\Upsilon") }),

  -- Arrows (;la removed — ;l=λ fires first; use ;Lft instead)
  s({ trig = ";ra",  snippetType = "autosnippet" }, { t("\\rightarrow") }),
  s({ trig = ";Ra",  snippetType = "autosnippet" }, { t("\\Rightarrow") }),
  s({ trig = ";Lft", snippetType = "autosnippet" }, { t("\\leftarrow") }),
  s({ trig = ";Lra", snippetType = "autosnippet" }, { t("\\Leftrightarrow") }),
  s({ trig = ";iff", snippetType = "autosnippet" }, { t("\\iff") }),
  s({ trig = ";mt",  snippetType = "autosnippet" }, { t("\\mapsto") }),

  -- Blackboard bold
  s({ trig = ";re",  snippetType = "autosnippet" }, { t("\\mathbb{R}") }),
  s({ trig = ";N",   snippetType = "autosnippet" }, { t("\\mathbb{N}") }),
  s({ trig = ";Z",   snippetType = "autosnippet" }, { t("\\mathbb{Z}") }),
  s({ trig = ";Q",   snippetType = "autosnippet" }, { t("\\mathbb{Q}") }),
  s({ trig = ";C",   snippetType = "autosnippet" }, { t("\\mathbb{C}") }),
  s({ trig = ";E",   snippetType = "autosnippet" }, { t("\\mathbb{E}") }),
  s({ trig = ";Pr",  snippetType = "autosnippet" }, { t("\\mathbb{P}") }),

  -- Other symbols
  s({ trig = ";ci",  snippetType = "autosnippet" }, { t("\\circ") }),
  s({ trig = ";inf", snippetType = "autosnippet" }, { t("\\infty") }),

  -- ── Math mode: inline / display ─────────────────────────────────────────
  s({ trig = "mk", snippetType = "autosnippet", wordTrig = false },
    fmta("$<>$", { i(1) })
  ),
  s({ trig = "dm", snippetType = "autosnippet" },
    fmta("\\[\n\t<>\n\\]", { i(1) }),
    { condition = conds_expand.line_begin }
  ),

  -- ── Structures (math mode) ───────────────────────────────────────────────
  s({ trig = "//", snippetType = "autosnippet", wordTrig = false },
    fmta("\\frac{<>}{<>}", { i(1), i(2) }),
    { condition = in_mathzone }
  ),
  s({ trig = "sq", snippetType = "autosnippet" },
    fmta("\\sqrt{<>}", { i(1) }),
    { condition = in_mathzone }
  ),
  s({ trig = "sum", snippetType = "autosnippet" },
    fmta("\\sum_{<>}^{<>}", { i(1, "i=1"), i(2, "n") }),
    { condition = in_mathzone }
  ),
  s({ trig = "prod", snippetType = "autosnippet" },
    fmta("\\prod_{<>}^{<>}", { i(1, "i=1"), i(2, "n") }),
    { condition = in_mathzone }
  ),
  s({ trig = "int", snippetType = "autosnippet" },
    fmta("\\int_{<>}^{<>} <> \\, \\mathrm{d}<>", { i(1, "0"), i(2, "\\infty"), i(3), i(4, "x") }),
    { condition = in_mathzone }
  ),
  s({ trig = "oint", snippetType = "autosnippet" },
    fmta("\\oint_{<>} <> \\, \\mathrm{d}<>", { i(1), i(2), i(3) }),
    { condition = in_mathzone }
  ),
  s({ trig = "lim", snippetType = "autosnippet" },
    fmta("\\lim_{<> \\to <>}", { i(1, "n"), i(2, "\\infty") }),
    { condition = in_mathzone }
  ),
  s({ trig = "limsup", snippetType = "autosnippet" },
    fmta("\\limsup_{<> \\to <>}", { i(1, "n"), i(2, "\\infty") }),
    { condition = in_mathzone }
  ),
  s({ trig = "liminf", snippetType = "autosnippet" },
    fmta("\\liminf_{<> \\to <>}", { i(1, "n"), i(2, "\\infty") }),
    { condition = in_mathzone }
  ),
  s({ trig = "exp", snippetType = "autosnippet" },
    fmta("e^{<>}", { i(1) }),
    { condition = in_mathzone }
  ),

  -- ── Differential calculus ────────────────────────────────────────────────
  s({ trig = "par", snippetType = "autosnippet" },
    fmta("\\frac{\\partial <>}{\\partial <>}", { i(1, "f"), i(2, "x") }),
    { condition = in_mathzone }
  ),
  s({ trig = "dd", snippetType = "autosnippet", wordTrig = false },
    fmta("\\, \\mathrm{d}<>", { i(1) }),
    { condition = in_mathzone }
  ),
  s({ trig = "grad", snippetType = "autosnippet" },
    t("\\nabla"),
    { condition = in_mathzone }
  ),
  s({ trig = "lap", snippetType = "autosnippet" },
    t("\\nabla^2"),
    { condition = in_mathzone }
  ),
  s({ trig = "divv", snippetType = "autosnippet" },
    t("\\nabla \\cdot"),
    { condition = in_mathzone }
  ),
  s({ trig = "curl", snippetType = "autosnippet" },
    t("\\nabla \\times"),
    { condition = in_mathzone }
  ),

  -- ── Delimiters (math mode) ───────────────────────────────────────────────
  s({ trig = "lr(", snippetType = "autosnippet", wordTrig = false },
    fmta("\\left( <> \\right)", { i(1) }),
    { condition = in_mathzone }
  ),
  s({ trig = "lr[", snippetType = "autosnippet", wordTrig = false },
    fmta("\\left[ <> \\right]", { i(1) }),
    { condition = in_mathzone }
  ),
  s({ trig = "lr{", snippetType = "autosnippet", wordTrig = false },
    fmta("\\left\\{ <> \\right\\}", { i(1) }),
    { condition = in_mathzone }
  ),
  s({ trig = "lr|", snippetType = "autosnippet", wordTrig = false },
    fmta("\\left| <> \\right|", { i(1) }),
    { condition = in_mathzone }
  ),
  s({ trig = "lrang", snippetType = "autosnippet", wordTrig = false },
    fmta("\\left\\langle <> \\right\\rangle", { i(1) }),
    { condition = in_mathzone }
  ),
  s({ trig = "norm", snippetType = "autosnippet" },
    fmta("\\left\\| <> \\right\\|", { i(1) }),
    { condition = in_mathzone }
  ),
  s({ trig = "abs", snippetType = "autosnippet" },
    fmta("\\left| <> \\right|", { d(1, helpers.get_visual) }),
    { condition = in_mathzone }
  ),
  s({ trig = "inner", snippetType = "autosnippet" },
    fmta("\\langle <>, <> \\rangle", { i(1), i(2) }),
    { condition = in_mathzone }
  ),

  -- ── Set theory and logic (math mode) ────────────────────────────────────
  s({ trig = "inn",    snippetType = "autosnippet" }, { t("\\in") },    { condition = in_mathzone }),
  s({ trig = "notin",  snippetType = "autosnippet" }, { t("\\notin") }, { condition = in_mathzone }),
  s({ trig = "nnn",    snippetType = "autosnippet" }, { t("\\cap") },   { condition = in_mathzone }),
  s({ trig = "uuu",    snippetType = "autosnippet" }, { t("\\cup") },   { condition = in_mathzone }),
  s({ trig = "subs",   snippetType = "autosnippet" }, { t("\\subseteq") }, { condition = in_mathzone }),
  s({ trig = "sups",   snippetType = "autosnippet" }, { t("\\supseteq") }, { condition = in_mathzone }),
  s({ trig = "empty",  snippetType = "autosnippet" }, { t("\\emptyset") }, { condition = in_mathzone }),
  s({ trig = "forall", snippetType = "autosnippet" }, { t("\\forall") }, { condition = in_mathzone }),
  s({ trig = "exists", snippetType = "autosnippet" }, { t("\\exists") }, { condition = in_mathzone }),

  -- ── Relations (math mode) ────────────────────────────────────────────────
  s({ trig = "leq",   snippetType = "autosnippet" }, { t("\\leq") },    { condition = in_mathzone }),
  s({ trig = "geq",   snippetType = "autosnippet" }, { t("\\geq") },    { condition = in_mathzone }),
  s({ trig = "neq",   snippetType = "autosnippet" }, { t("\\neq") },    { condition = in_mathzone }),
  s({ trig = "approx",snippetType = "autosnippet" }, { t("\\approx") }, { condition = in_mathzone }),
  s({ trig = "equiv", snippetType = "autosnippet" }, { t("\\equiv") },  { condition = in_mathzone }),
  s({ trig = "sim",   snippetType = "autosnippet" }, { t("\\sim") },    { condition = in_mathzone }),

  -- ── Math fonts (math mode) ───────────────────────────────────────────────
  s({ trig = "mcal", snippetType = "autosnippet" },
    fmta("\\mathcal{<>}", { i(1) }),
    { condition = in_mathzone }
  ),
  s({ trig = "mbb", snippetType = "autosnippet" },
    fmta("\\mathbb{<>}", { i(1) }),
    { condition = in_mathzone }
  ),
  s({ trig = "mfk", snippetType = "autosnippet" },
    fmta("\\mathfrak{<>}", { i(1) }),
    { condition = in_mathzone }
  ),
  s({ trig = "mbf", snippetType = "autosnippet" },
    fmta("\\mathbf{<>}", { i(1) }),
    { condition = in_mathzone }
  ),
  s({ trig = "mrm", snippetType = "autosnippet" },
    fmta("\\mathrm{<>}", { i(1) }),
    { condition = in_mathzone }
  ),

  -- ── Greek with blocked ;prefix — word triggers in math mode only ─────────
  -- (theta/psi/phi can't use ;th/;ps/;ph because ;t/;p fire first)
  s({ trig = "theta", snippetType = "autosnippet" }, { t("\\theta") }, { condition = in_mathzone }),
  s({ trig = "vthe",  snippetType = "autosnippet" }, { t("\\vartheta") }, { condition = in_mathzone }),
  s({ trig = "psi",   snippetType = "autosnippet" }, { t("\\psi") },   { condition = in_mathzone }),
  s({ trig = "phi",   snippetType = "autosnippet" }, { t("\\phi") },   { condition = in_mathzone }),
  s({ trig = "vep",   snippetType = "autosnippet" }, { t("\\varepsilon") }, { condition = in_mathzone }),

  -- ── Probability theory ───────────────────────────────────────────────────
  s({ trig = "EE", snippetType = "autosnippet" },
    fmta("\\mathbb{E}\\left[ <> \\right]", { i(1) }),
    { condition = in_mathzone }
  ),
  s({ trig = "PP", snippetType = "autosnippet" },
    fmta("\\mathbb{P}\\left( <> \\right)", { i(1) }),
    { condition = in_mathzone }
  ),
  s({ trig = "Var", snippetType = "autosnippet" },
    fmta("\\operatorname{Var}\\left( <> \\right)", { i(1) }),
    { condition = in_mathzone }
  ),
  s({ trig = "Cov", snippetType = "autosnippet" },
    fmta("\\operatorname{Cov}\\left( <>, <> \\right)", { i(1), i(2) }),
    { condition = in_mathzone }
  ),
  s({ trig = "Ent", snippetType = "autosnippet" },
    fmta("\\operatorname{Ent}\\left( <> \\right)", { i(1) }),
    { condition = in_mathzone }
  ),
  s({ trig = "ind", snippetType = "autosnippet" },
    fmta("\\mathbf{1}_{<>}", { i(1) }),
    { condition = in_mathzone }
  ),
  s({ trig = "filt", snippetType = "autosnippet" },
    fmta("\\mathcal{F}_{<>}", { i(1) }),
    { condition = in_mathzone }
  ),
  s({ trig = "iid", snippetType = "autosnippet" },
    t("\\overset{\\mathrm{i.i.d.}}{\\sim}"),
    { condition = in_mathzone }
  ),
  s({ trig = "asto", snippetType = "autosnippet" },
    t("\\xrightarrow{\\mathrm{a.s.}}"),
    { condition = in_mathzone }
  ),
  s({ trig = "dto",  snippetType = "autosnippet" },
    t("\\xrightarrow{d}"),
    { condition = in_mathzone }
  ),
  s({ trig = "pto",  snippetType = "autosnippet" },
    t("\\xrightarrow{P}"),
    { condition = in_mathzone }
  ),
  s({ trig = "lpto", snippetType = "autosnippet" },
    fmta("\\xrightarrow{L^{<>}}", { i(1, "2") }),
    { condition = in_mathzone }
  ),
  s({ trig = "cond", snippetType = "autosnippet" },
    fmta("<> \\mid <>", { i(1), i(2) }),
    { condition = in_mathzone }
  ),
  s({ trig = "sigalg", snippetType = "autosnippet" },
    fmta("\\sigma\\left( <> \\right)", { i(1) }),
    { condition = in_mathzone }
  ),
  s({ trig = "law", snippetType = "autosnippet" },
    fmta("\\mathcal{L}\\left( <> \\right)", { i(1) }),
    { condition = in_mathzone }
  ),

  -- ── Mathematical physics ─────────────────────────────────────────────────
  s({ trig = "bra", snippetType = "autosnippet" },
    fmta("\\langle <> \\rvert", { i(1) }),
    { condition = in_mathzone }
  ),
  s({ trig = "ket", snippetType = "autosnippet" },
    fmta("\\lvert <> \\rangle", { i(1) }),
    { condition = in_mathzone }
  ),
  s({ trig = "braket", snippetType = "autosnippet" },
    fmta("\\langle <> \\vert <> \\rangle", { i(1), i(2) }),
    { condition = in_mathzone }
  ),
  s({ trig = "comm", snippetType = "autosnippet" },
    fmta("[<>, <>]", { i(1), i(2) }),
    { condition = in_mathzone }
  ),
  s({ trig = "acomm", snippetType = "autosnippet" },
    fmta("\\{<>, <>\\}", { i(1), i(2) }),
    { condition = in_mathzone }
  ),
  s({ trig = "hbar",  snippetType = "autosnippet" }, { t("\\hbar") },  { condition = in_mathzone }),
  s({ trig = "dag",   snippetType = "autosnippet" }, { t("^{\\dag}") },{ condition = in_mathzone }),
  s({ trig = "ddag",  snippetType = "autosnippet" }, { t("^{\\ddag}") },{ condition = in_mathzone }),
}
