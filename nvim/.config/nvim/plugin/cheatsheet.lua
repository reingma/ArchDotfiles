local state = { buf = -1, win = -1 }

local function make_window(nlines)
  local width  = math.min(math.floor(vim.o.columns * 0.88), 110)
  local height = math.min(math.floor(vim.o.lines   * 0.88), nlines + 2)
  return {
    relative = "editor",
    width    = width,
    height   = height,
    col      = math.floor((vim.o.columns - width)  / 2),
    row      = math.floor((vim.o.lines   - height) / 2),
    style    = "minimal",
    border   = "rounded",
    title    = " Cheatsheet ",
    title_pos = "center",
  }
end

-- stylua: ignore
local sheets = {
  -- ── LaTeX ──────────────────────────────────────────────────────────────
  tex = {
    "# LaTeX Cheatsheet",
    "",
    "## Greek Letters  (;prefix — autosnippet, tex only)",
    "  ;a α   ;b β   ;g γ   ;d δ   ;e ε   ;z ζ   ;h η   ;k κ   ;l λ",
    "  ;m μ   ;n ν   ;x ξ   ;p π   ;rh ρ  ;s σ   ;t τ   ;f φ   ;ch χ  ;o ω",
    "  theta → \\theta  psi → \\psi  phi → \\phi  vep → \\varepsilon  (math mode only)",
    "",
    "## Uppercase Greek  (;prefix)",
    "  ;Ga Γ  ;De Δ  ;Th Θ  ;La Λ  ;Xi Ξ  ;Pi Π  ;Si Σ  ;Ph Φ  ;Ps Ψ  ;Om Ω",
    "",
    "## Arrows & Symbols  (;prefix)",
    "  ;ra →   ;Ra ⇒   ;Lft ←   ;Lra ⟺   ;iff ⟺   ;mt ↦   ;inf ∞",
    "  ;ci ∘",
    "",
    "## Blackboard Bold  (;prefix)",
    "  ;re ℝ  ;N ℕ  ;Z ℤ  ;Q ℚ  ;C ℂ  ;E 𝔼  ;Pr ℙ",
    "",
    "## Math Structures  (math mode autosnippet)",
    "  //        →  \\frac{}{}            mk   →  $...$",
    "  sq        →  \\sqrt{}              dm   →  \\[...\\]  (line start)",
    "  sum       →  \\sum_{i=1}^{n}       prod →  \\prod_{}^{}",
    "  int       →  \\int_{}^{} ...\\,dx   oint →  \\oint",
    "  lim       →  \\lim_{n→∞}           limsup/liminf",
    "  par       →  ∂f/∂x                exp  →  e^{}",
    "  dd        →  \\,\\mathrm{d}x",
    "",
    "## Calculus & Physics",
    "  grad → ∇    lap → ∇²    divv → ∇·    curl → ∇×",
    "  bra  → ⟨·|   ket  → |·⟩   braket → ⟨·|·⟩",
    "  comm → [·,·]   acomm → {·,·}   hbar → ℏ   dag → †",
    "",
    "## Delimiters  (math mode)",
    "  lr(   →  \\left(…\\right)      lr[  →  \\left[…\\right]",
    "  lr{   →  \\left\\{…\\right\\}    lr|  →  \\left|…\\right|",
    "  lrang →  ⟨…⟩                  norm →  ‖…‖",
    "  abs   →  |…| (visual)         inner → ⟨·,·⟩",
    "",
    "## Set Theory & Relations  (math mode)",
    "  inn notin  nnn(∩)  uuu(∪)  subs(⊆) sups(⊇)  empty  forall  exists",
    "  leq  geq  neq  approx  equiv  sim",
    "",
    "## Math Fonts  (math mode)",
    "  mcal → \\mathcal{}    mbb → \\mathbb{}    mfk → \\mathfrak{}",
    "  mbf  → \\mathbf{}     mrm → \\mathrm{}",
    "",
    "## Probability Theory  (math mode)",
    "  EE      →  𝔼[…]                PP    →  ℙ(…)",
    "  Var     →  Var(…)               Cov   →  Cov(…,…)",
    "  Ent     →  Ent(…)               ind   →  𝟏_{…}",
    "  filt    →  ℱ_{…}                cond  →  X | Y",
    "  sigalg  →  σ(…)                 law   →  ℒ(…)",
    "  iid     →  ∼^{i.i.d.}           asto  →  →^{a.s.}",
    "  dto     →  →^d                  pto   →  →^P     lpto  →  →^{Lp}",
    "",
    "## Theorem Environments  (line start)",
    "  thm  lem  prop  cor  defn  prf  rem  exa  notn  conj  assm",
    "  beg  →  generic \\begin{X}…\\end{X}",
    "",
    "## Display Math Environments  (line start)",
    "  eq   →  equation (with \\label)    eq*  →  equation*",
    "  ali  →  align                      ali* →  align*",
    "  gat  →  gather*                    cas  →  cases  (math mode)",
    "  pmat →  pmatrix  (math mode)       bmat →  bmatrix    vmat → vmatrix",
    "  enum →  enumerate                  items → itemize",
    "",
    "## Text Formatting",
    "  tii → \\textit{}   tbf → \\textbf{}   tul → \\underline{}   can → \\cancel{}",
    "  href → \\href{}{}",
    "",
    "## Snippet Navigation",
    "  <C-L>  jump forward    <C-K>  jump backward    <Tab>  store visual selection",
    "",
    "## VimTeX Motions",
    "  ]]  next section   [[  prev section   ]m  next env   [m  prev env",
    "  ]n  next math      [n  prev math",
    "",
    "## VimTeX Text Objects  (d/c/y/v prefix)",
    "  ae/ie  environment    a$/i$  math zone      ac/ic  command",
    "  ad/id  delimiter      am/im  list item      aP/iP  section",
    "",
    "## VimTeX Commands",
    "  dse  delete env    cse  change env    tse  toggle env starred",
    "  dsc  delete cmd    csc  change cmd    ds$  delete math    tsf  toggle frac",
  },

  -- ── Default (all other filetypes) ──────────────────────────────────────
  default = {
    "# Neovim Cheatsheet",
    "",
    "## Window Navigation",
    "  <C-h/j/k/l>  move between splits",
    "  <C-d>/<C-u>  scroll down/up (centered)",
    "",
    "## LSP",
    "  gd        go to definition      gr  references",
    "  gD        declaration           gT  type definition",
    "  K         hover info",
    "  <leader>cr  rename              <leader>ca  code action",
    "  <leader>wd  document symbols    <leader>er  error float",
    "  <leader>tt  toggle inlay hints",
    "",
    "## Telescope",
    "  <leader>sf  find files          <leader>sg  live grep",
    "  <leader>sh  help tags           <leader>sw  grep word",
    "  <leader>sd  diagnostics         <leader>sr  resume",
    "",
    "## Quickfix",
    "  <leader>qj  next    <leader>qk  prev    <leader>qt  toggle",
    "",
    "## Git (gitsigns)",
    "  <leader>hs  stage hunk     <leader>hr  reset hunk",
    "  <leader>hS  stage buffer   <leader>hR  reset buffer",
    "  <leader>hp  preview hunk   <leader>hb  blame line",
    "  <leader>hd  diff this",
    "",
    "## Editor",
    "  <leader>u   undotree        ,st  toggle float terminal",
    "  <leader>?   this cheatsheet",
    "",
    "## Visual Mode",
    "  J / K       move selection down / up",
    "",
    "## Snippet Navigation  (LuaSnip)",
    "  <C-L>  jump forward    <C-K>  jump backward",
  },
}

local function open(ft)
  local lines = sheets[ft] or sheets.default
  if not vim.api.nvim_buf_is_valid(state.buf) then
    state.buf = vim.api.nvim_create_buf(false, true)
  end
  vim.bo[state.buf].modifiable = true
  vim.api.nvim_buf_set_lines(state.buf, 0, -1, false, lines)
  vim.bo[state.buf].modifiable = false
  vim.bo[state.buf].filetype   = "markdown"

  state.win = vim.api.nvim_open_win(state.buf, true, make_window(#lines))
  vim.wo[state.win].conceallevel = 2
  vim.wo[state.win].wrap = true

  vim.keymap.set("n", "q", function()
    if vim.api.nvim_win_is_valid(state.win) then
      vim.api.nvim_win_close(state.win, true)
    end
  end, { buffer = state.buf, silent = true })
end

local function toggle()
  if vim.api.nvim_win_is_valid(state.win) then
    vim.api.nvim_win_hide(state.win)
    return
  end
  open(vim.bo.filetype)
end

vim.keymap.set("n", "<leader>?", toggle, { desc = "Contextual cheatsheet" })
