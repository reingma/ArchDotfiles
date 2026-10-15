# Neovim config

lazy.nvim directly, no distribution. Every file in `lua/custom/plugins/` is a plugin
spec and is imported automatically. Leader and localleader are both `Space`.

Two ways to find a key without this file: pause after `Space` and which-key lists the
groups, or press `<leader>?` for the built-in cheatsheet (`plugin/cheatsheet.lua`),
which changes with the filetype.

## Required software

`rg`, `fd`, `npm` / `node`, `go`, `unzip`, a C compiler (`clang`), `sqlite3`, a Nerd
Font, plus `git`, `gh` and `git-delta` for the git plugins. Mason installs language
servers, formatters and linters on first launch.

## Layout

| Path                      | What lives there                                   |
| ------------------------- | -------------------------------------------------- |
| `init.lua`                | leader keys, loads lazy                            |
| `lua/config/lazy.lua`     | lazy.nvim bootstrap                                |
| `lua/custom/plugins/`     | one file per plugin (or group of related plugins)  |
| `lua/custom/autoformat.lua` | conform.nvim setup (format on save)              |
| `plugin/`                 | keymaps, options, float terminal, cheatsheet, menu |
| `after/ftplugin/`         | per-filetype overrides                             |
| `LuaSnip/`                | my snippets, by filetype                           |

Managing plugins: `:Lazy` (install, update, profile), `:Mason` (LSP servers and
tools). `<leader>en` searches this config, `<leader>ep` searches plugin sources.

## Plugins

### Finding and moving around

| Plugin | Use |
| ------ | --- |
| **telescope** | `<leader>sf` files, `<leader>sb` buffers, `<leader>sh` help, `<leader>st` git files next to the current file, `<leader>/` fuzzy-find in buffer |
| **multigrep** (custom telescope picker) | `<leader>sg` live grep. Type the pattern, two spaces, then a glob or shortcut: `foo  *.rs`, `foo  l` (`l` = `*.lua`) |
| **oil** | `-` opens the parent directory as an editable buffer; rename/delete by editing lines and `:w`. `<leader>-` opens it floating |
| **harpoon** | `<leader>ha` pin file, `<leader>hl` list, `<leader>h1`..`h4` jump to pin |
| **undotree** | `<leader>uu` toggle the undo history tree |
| **trouble** | `<leader>xl` all diagnostics, `<leader>xL` current buffer only |
| **quicker** | makes the quickfix list editable. `<leader>qt` toggle, `<leader>qj` / `<leader>qk` next / previous |

Window moves are `<C-h/j/k/l>`. `,st` toggles a floating terminal (`<esc><esc>`
leaves terminal mode).

### Editing

| Plugin | Use |
| ------ | --- |
| **blink.cmp** | completion from LSP, paths, snippets and dadbod. `<C-n>` / `<C-p>` select, `<C-y>` accept, `<C-space>` open, `<C-e>` close. Signature help shows while typing arguments |
| **LuaSnip** + friendly-snippets | `<C-L>` / `<C-K>` jump forward / back, `<C-E>` cycle choices. Own snippets in `LuaSnip/` (`tex/`, `py/`, `all.lua`); autosnippets are on |
| **mini.ai** | extra text objects: `via` argument, `vif` function call, `viq` quotes, `vib` brackets |
| **mini.surround** | `sa` add, `sd` delete, `sr` replace: `saiw)`, `sd"`, `sr)]` |
| **mini.comment** | `gcc` line, `gc` + motion or selection |
| **mini.statusline** | the status line |
| **nvim-autopairs** | closes brackets and quotes in insert mode |
| **todo-comments** | highlights `TODO`, `FIX`, `NOTE`...; `:TodoTelescope` / `:TodoQuickFix` list them |
| **nvim-colorizer** | shows CSS colours inline |

### Code intelligence

| Plugin | Use |
| ------ | --- |
| **nvim-lspconfig** + mason + mason-tool-installer | servers are declared in `lua/custom/plugins/lsp.lua` and installed automatically |
| **fidget** | LSP progress in the corner |
| **lazydev** | Neovim API completion in Lua files |
| **SchemaStore** | JSON / YAML schemas for `jsonls` and `yamlls` |
| **conform** | formats on save; `<leader>f` formats now. Formatters per filetype in `lua/custom/autoformat.lua` |
| **nvim-lint** | lints on save: markdownlint, shellcheck, golangci-lint, hadolint |
| **tree-sitter-manager** | installs parsers Neovim does not bundle and starts highlighting |

LSP keys (active once a server attaches):

| Key | Action |
| --- | ------ |
| `gd` / `gD` / `gT` | definition / declaration / type definition |
| `gr` | references |
| `K` | hover |
| `<leader>cr` | rename |
| `<leader>ca` | code action |
| `<leader>cl` | run code lens |
| `<leader>wd` | document symbols |
| `<leader>th` or `<leader>tt` | toggle inlay hints |
| `<leader>er` | diagnostic under cursor in a float |

### Debugging and testing

| Plugin | Use |
| ------ | --- |
| **nvim-dap** + dap-ui + virtual-text + dap-go | `<F5>` start / continue, `<F10>` over, `<F11>` into, `<F12>` out, `<leader>db` breakpoint, `<leader>dB` conditional, `<leader>du` UI, `<leader>dr` REPL, `<leader>dl` run last. Adapters: codelldb (C, C++, Rust, Odin — "Build package & launch" runs `odin build . -debug`), delve (Go), js-debug (Node/TS: launch file, attach, Chrome; `.vscode/launch.json` works) |
| **neotest** (Rust, Go) | `<leader>tn` nearest, `<leader>tf` file, `<leader>ts` suite, `<leader>tl` last, `<leader>td` debug nearest, `<leader>tS` summary, `<leader>to` output, `<leader>tx` stop |

### Git and GitHub

| Plugin | Use |
| ------ | --- |
| **gitsigns** | change marks in the sign column. `]c` / `[c` next / previous hunk, `<leader>hs` stage, `<leader>hr` reset, `<leader>hS` / `<leader>hR` whole buffer, `<leader>hp` preview, `<leader>hb` blame line, `<leader>hd` diff against index, `<leader>hD` against last commit, `<leader>tb` toggle inline blame |
| **diffview** | full-tab diffs. `<leader>gd` working tree, `<leader>gm` branch against `origin/HEAD` (what a PR would show), `<leader>gh` file history (visual: history of the selection), `<leader>gH` repo history, `<leader>gq` close. Also opens as a 3-way view during merge conflicts |
| **octo** | GitHub PRs and issues as buffers. `<leader>oo` every action, `<leader>op` PRs here, `<leader>oP` PRs awaiting my review, `<leader>ob` PR of this branch, `<leader>oc` create PR, `<leader>or` start / resume review, `<leader>oi` issues, `<leader>os` search |

Typical review with octo: `<leader>oP`, pick a PR, `<leader>or` to start the review,
move through files and comment on lines, then `:Octo review submit`. Inside octo
buffers its own `<localleader>` maps apply (they are listed by which-key after
`Space`). Octo needs `gh auth login` to have been run. If `<leader>gm` errors, the
repo has no `origin/HEAD`: `git remote set-head origin -a`.

### Language specific

| Plugin | Use |
| ------ | --- |
| **rustaceanvim** | `<leader>rr` runnables, `<leader>rd` debuggables, `<leader>re` expand macro, `<leader>rc` open Cargo.toml, `<leader>rp` rebuild proc macros, `K` hover actions |
| **clangd_extensions** | clangd extras: `:ClangdSwitchSourceHeader`, `:ClangdAST`, `:ClangdTypeHierarchy` |
| **cmake-tools** | `:CMakeGenerate`, `:CMakeBuild`, `:CMakeRun`; Ninja, `build/` directory |
| **vimtex** | `<leader>ll` compile continuously, `<leader>lv` view in zathura. `dse` / `cse` delete / change environment, `tsf` toggle fraction, `]]` / `[[` sections, text objects `ie` `i$` `ic` `id`. More notes in `lua/custom/plugins/vimtex.lua` |
| **render-markdown** | renders Markdown in normal mode; `:RenderMarkdown toggle` |
| **vim-dadbod** + UI + completion | `:DBUI` opens the database browser; SQL buffers get completion |
| **leetcode** | start with `nvim leetcode.nvim`; language is Rust |

### Interface

| Plugin | Use |
| ------ | --- |
| **which-key** | key hints after a pause; groups are named in `which_key.lua` |
| **nvim-notify** | notifications as popups |
| **zen-mode** + twilight | `:ZenMode` centres the buffer, `:Twilight` dims everything but the current block |
| **tokyonight, eldritch, catppuccin, rose-pine** | colour schemes; `:Telescope themes` switches with a live preview |

## TODO

- set up copilot
