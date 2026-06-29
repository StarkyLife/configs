# Neovim Modernization Plan

This file is the source of truth for this project. The AI agent should read it at the start of every session and align suggestions with the current phase below.

**Last reviewed:** 2026-06-29  
**Neovim baseline:** 0.11.3+ (tested on 0.12.3)  
**Config path:** `nvim-new/` (launch with `NVIM_APPNAME=nvim-new nvim`)

## Progress

| Phase | Status |
|-------|--------|
| 1 — Minimal Working Config | done |
| 2 — Core UI | done |
| 3 — Navigation | done |
| 4 — Syntax And Editing | done |
| 5 — LSP | done |
| 6 — Completion | done |
| 7 — Formatting And Linting | **current** |
| 8 — Git | pending |
| 9 — AI Coding Tools In Terminal | pending |
| 10 — Polish | pending |

## Goal

Create a modern Neovim configuration in a new `nvim-new` folder without modifying the existing `nvim` config.

The old `nvim` config uses `lsp-zero.nvim` and legacy patterns (`require('lspconfig')`, old server names like `tsserver`). The new config should use Neovim 0.11+ native LSP APIs and current plugin APIs.

## Environment Prerequisites

Install these before LSP/Treesitter phases:

| Tool | Why |
|------|-----|
| Neovim ≥ 0.11.3 | Required for `vim.lsp.config` / `vim.lsp.enable` and current `nvim-lspconfig` |
| `tree-sitter` CLI ≥ 0.26.1 | Required by `nvim-treesitter` on the `main` branch (install via Homebrew, not npm) |
| C compiler | Treesitter parser compilation |
| `ripgrep` | Telescope live grep |
| `fd` or `find` | Telescope file search (Telescope picks up `fd` if available) |

Check versions:

```sh
nvim --version | head -1
tree-sitter --version
rg --version
```

## Keeping This Plan Current

Re-read this section when something feels outdated. You should not need to ask the AI to “actualize” every time.

### What to check periodically

1. **Neovim release notes** — [neovim.io/news](https://neovim.io/news) for LSP/Treesitter API changes.
2. **`nvim-new/lazy-lock.json`** — pinned plugin commits after `:Lazy update`.
3. **Breaking-change trackers:**
   - [nvim-lspconfig #3693](https://github.com/neovim/nvim-lspconfig/issues/3693) — `require('lspconfig')` removal
   - [mason-lspconfig v2.0.0](https://github.com/mason-org/mason-lspconfig.nvim/releases/tag/v2.0.0) — no `setup_handlers`
   - [nvim-treesitter `main` README](https://github.com/neovim-treesitter/nvim-treesitter) — parser install API rewrite
4. **Health commands after changes:**
   - `:checkhealth lazy`
   - `:checkhealth vim.treesitter`
   - `:checkhealth vim.lsp`
   - `:TSStatus` — parser versions vs registry

### Update cadence

| Trigger | Action |
|---------|--------|
| After `:Lazy update` | Run `:TSUpdate`, reopen Neovim, run validation checklist |
| Neovim minor/major upgrade | Re-read `:help news` and LSP migration notes |
| LSP broken after Mason update | `:checkhealth vim.lsp`, check Mason package name vs `vim.lsp.enable()` name |
| Treesitter highlighting gone | Confirm `FileType` autocmd still calls `vim.treesitter.start()` |

### Installed plugins (snapshot 2026-06-28)

Tracked in `nvim-new/lazy-lock.json`:

- lazy.nvim, gruvbox.nvim, lualine.nvim, nvim-web-devicons, which-key.nvim
- telescope.nvim, plenary.nvim, oil.nvim
- nvim-treesitter (`main`), treesitter-parser-registry
- Comment.nvim, nvim-surround, nvim-autopairs

Not yet installed (upcoming phases): mason.nvim, mason-lspconfig.nvim, nvim-lspconfig, blink.cmp, conform.nvim, gitsigns.nvim, toggleterm.nvim (optional).

## Target Structure

```text
nvim-new/
  init.lua
  lazy-lock.json
  lua/
    config/
      options.lua
      keymaps.lua
      autocmds.lua      # includes vim.treesitter.start() on FileType
      lazy.lua
    plugins/
      ui.lua
      editor.lua
      treesitter.lua
      telescope.lua
      oil.lua
      lsp.lua           # Phase 5
      completion.lua    # Phase 6
      formatting.lua    # Phase 7
      git.lua           # Phase 8
      terminal.lua      # Phase 9
```

Optional (Phase 5+): per-server overrides in `lsp/<server>.lua` or `after/lsp/<server>.lua` — Neovim merges these with `nvim-lspconfig` defaults automatically.

## Phase 1: Minimal Working Config ✅

Create the basic config skeleton:

- `init.lua`
- `lua/config/options.lua`
- `lua/config/keymaps.lua`
- `lua/config/autocmds.lua`
- `lua/config/lazy.lua`

Initial behavior:

- Use space as the leader key.
- Keep practical defaults from the old config.
- Enable line numbers, smart indentation, search improvements, true color, and sensible split behavior.
- Bootstrap `lazy.nvim` from the `stable` branch.
- Confirm Neovim opens without errors.

## Phase 2: Core UI ✅

Add a small UI layer:

- Colorscheme: `gruvbox.nvim`
- Statusline: `lualine.nvim`
- File icons: `nvim-web-devicons`
- Keybinding discoverability: `which-key.nvim`

Keep the UI useful but not overloaded.

## Phase 3: Navigation ✅

Add navigation tools:

- `telescope.nvim` for file search, live grep, buffers, and help tags.
- `oil.nvim` for editing directories like normal buffers.

Recommended learning path: start with Telescope first, then add `oil.nvim` as the directory editor.

Use `oil.nvim` instead of a traditional file tree. This keeps file operations close to normal Vim editing:

- Open parent directory.
- Rename files by editing text.
- Create files and folders directly in the directory buffer.
- Move files by changing paths.
- Delete files from the directory buffer.

Useful starting keymaps:

- `<leader>e` to open Oil.
- `-` to open the parent directory.
- `<leader>ff` for Telescope file search.
- `<leader>fg` for Telescope live grep.

## Phase 4: Syntax And Editing ✅

### nvim-treesitter is a rewrite on `main`

Use the **`main` branch**, not `master`. The old `setup { ensure_installed, highlight = { enable = true } }` API is gone.

Required pieces:

- Plugin: `nvim-treesitter/nvim-treesitter` with `branch = "main"`, `build = ":TSUpdate"`
- Dependency: `neovim-treesitter/treesitter-parser-registry`
- Install parsers explicitly: `require("nvim-treesitter").install({ ... })`
- **Enable highlighting yourself** — the plugin no longer auto-attaches. Add a `FileType` autocmd in `autocmds.lua`:

```lua
vim.api.nvim_create_autocmd("FileType", {
  pattern = "*",
  callback = function()
    pcall(vim.treesitter.start)
  end,
})
```

Optional: `vim.cmd("syntax off")` once at startup if you rely entirely on Treesitter highlighting.

### Other editing plugins

- `Comment.nvim` for commenting.
- `nvim-surround` for surrounding text objects.
- `nvim-autopairs` for automatic brackets and quotes (`check_ts = true`; disable in `oil` and Telescope prompt filetypes).

### Parser list

Keep parsers close to languages actually used:

- lua, vim, vimdoc, bash, json, yaml
- markdown, markdown_inline
- html, css, javascript, typescript, tsx, dockerfile

Verify with `:TSStatus` and `:checkhealth vim.treesitter`.

## Phase 5: LSP

Replace `lsp-zero.nvim` with an explicit, native LSP setup.

### Core stack (2026 best practice)

| Plugin | Role |
|--------|------|
| `mason-org/mason.nvim` | Install LSP servers and formatters |
| `mason-org/mason-lspconfig.nvim` v2+ | `ensure_installed` list; optional `automatic_enable` |
| `neovim/nvim-lspconfig` | Server default configs in `lsp/` (data only — **do not** call `require('lspconfig')`) |

Neovim 0.11+ APIs:

- Configure: `vim.lsp.config('server_name', { ... })`
- Enable: `vim.lsp.enable('server_name')` or `vim.lsp.enable({ 'lua_ls', 'ts_ls', ... })`
- Global defaults for all servers: `vim.lsp.config('*', { ... })`

**Do not use** (deprecated/removed):

- `require('lspconfig').*.setup {}`
- `mason-lspconfig.setup_handlers()` or `handlers = { ... }` (removed in v2.0.0)
- `lsp-zero.nvim`

### Mason PATH

Mason binaries must be on `$PATH` inside Neovim (typically in `lsp.lua` config):

```lua
local mason_bin = vim.fn.stdpath("data") .. "/mason/bin"
vim.env.PATH = vim.env.PATH .. ":" .. mason_bin
```

### Recommended `lsp.lua` shape

1. Add Mason to PATH.
2. `require("mason").setup()`.
3. `require("mason-lspconfig").setup { ensure_installed = { ... } }` — `automatic_enable = true` by default in v2+.
4. Set shared options once:

```lua
vim.lsp.config("*", {
  -- on_attach, capabilities, flags, etc.
})
```

5. Override specific servers where needed:

```lua
vim.lsp.config("lua_ls", {
  settings = {
    Lua = {
      diagnostics = { globals = { "vim" } },
    },
  },
})
```

6. If `automatic_enable` is off, call `vim.lsp.enable({ ... })` for each server.

Use `:checkhealth vim.lsp` to verify configs, roots, and errors.

### Mason package name vs LSP config name

Mason installs by **package name**; Neovim enables by **config name**:

| `vim.lsp.enable(...)` | Mason `:MasonInstall` package |
|-----------------------|----------------------------------|
| `lua_ls` | `lua-language-server` |
| `ts_ls` | `typescript-language-server` |
| `html` | `html-lsp` |
| `cssls` | `css-lsp` |
| `eslint` | `eslint-lsp` |
| `dockerls` | `dockerfile-language-server` |

Old names to avoid: `tsserver`, `sumneko_lua`, `ruff_lsp`, `bufls`.

### Initial servers

- `lua_ls`
- `ts_ls` (not `tsserver`)
- `html`
- `cssls`
- `eslint`
- `dockerls`

### Keymaps and diagnostics

Configure in `on_attach` inside `vim.lsp.config('*', ...)` or per-server:

- Go to definition, references, hover, rename, code actions
- Diagnostic navigation (`]d`, `[d`, float)
- Buffer-local mappings only (`vim.bo[bufnr].maplocalleader` if needed)

Capabilities for completion come in Phase 6 (`blink.cmp.get_lsp_capabilities()`).

## Phase 6: Completion ✅

**Default choice: `blink.cmp`** — batteries-included (LSP, buffer, path, snippets), used by kickstart.nvim and LazyVim as of 2025–2026.

Alternative: `nvim-cmp` only if you need a legacy cmp source ecosystem not covered by `blink.compat`.

Do not keep both stacks.

### blink.cmp setup sketch

In `completion.lua`:

- Plugin: `saghen/blink.cmp`
- Optional snippet engine: `LuaSnip` or blink’s built-in snippet preset
- Wire LSP capabilities in Phase 5:

```lua
vim.lsp.config("*", {
  capabilities = require("blink.cmp").get_lsp_capabilities(),
})
```

Completion should support:

- LSP suggestions
- Buffer words
- File paths
- Snippets

Verify in insert mode in a `.lua` and `.ts` buffer after LSP attaches.

## Phase 7: Formatting And Linting

Add formatting with:

- `stevearc/conform.nvim`

Optional linting:

- `mfussenegger/nvim-lint`

Install formatters via Mason where possible (`stylua`, `prettier`).

Start with manual format keymap; enable format-on-save only after manual formatting works:

- Lua: `stylua`
- JavaScript/TypeScript: `prettier`
- JSON/YAML/Markdown: `prettier`

ESLint diagnostics come from the `eslint` LSP server (Phase 5), not necessarily from `nvim-lint`.

## Phase 8: Git

Add Git workflow plugins:

- `lewis6991/gitsigns.nvim` for inline Git changes
- Keep `tpope/vim-fugitive` for powerful Git commands

Useful keymaps:

- Preview hunk
- Stage hunk
- Reset hunk
- Blame current line
- Open Fugitive status

## Phase 9: AI Coding Tools In Terminal

Add AI coding tool integration only after the editor basics are stable.

Goal: learn how to use AI coding TUIs from inside Neovim, without adding a large AI plugin layer to the config.

Recommended direction:

- Use Neovim terminal buffers or a terminal-management plugin.
- Start with `opencode` TUI as the open-source/default option.
- Optionally support Claude Code the same way if it is installed and authenticated.
- Keep terminal-related configuration isolated in `lua/plugins/terminal.lua`.
- Avoid configuring Neovim-specific AI plugins until the terminal workflow feels limiting.

Possible terminal approaches:

- Built-in terminal with `:terminal`.
- `akinsho/toggleterm.nvim` for named floating or split terminals.
- A project-root terminal opened from a keymap.

Useful workflows to learn:

- Open `opencode` in a floating terminal.
- Open Claude Code in a floating terminal.
- Send copied file paths, diagnostics, or selected snippets manually.
- Keep the AI TUI in the project root.
- Move between editor windows and the AI terminal quickly.

Start conservatively:

- First learn `:terminal` and terminal-mode navigation.
- Then add one keymap for an `opencode` terminal.
- Then add one optional keymap for Claude Code.
- Only add helper commands after the workflow is clear.

This keeps model/tool choice outside the Neovim config. Neovim only provides a clean place to run the TUI tools.

## Phase 10: Polish

After the base setup works, add polish slowly:

- Better diagnostics display (e.g. `folke/trouble.nvim` or native `:lua vim.diagnostic.open_float()`)
- Project-local config if needed
- More Telescope extensions
- Better terminal integration
- Session management only if actually needed
- More terminal shortcuts for `opencode` or Claude Code once the basic workflow is useful

Avoid adding large plugin bundles before understanding the basics.

## Deprecations Quick Reference

| Old pattern | Current replacement |
|-------------|---------------------|
| `lsp-zero.nvim` | mason + native `vim.lsp.*` |
| `require('lspconfig').x.setup {}` | `vim.lsp.config('x', {})` + `vim.lsp.enable('x')` |
| `mason-lspconfig.setup_handlers` | `vim.lsp.config('*', {})` and per-server overrides |
| `tsserver` | `ts_ls` |
| `sumneko_lua` | `lua_ls` |
| nvim-treesitter `master` + `ensure_installed` | `main` branch + `.install()` + manual `vim.treesitter.start()` |
| nvim-cmp + 4 source plugins | `blink.cmp` (default) |

## Validation Checklist

Before replacing the old config, verify:

- `NVIM_APPNAME=nvim-new nvim` opens without startup errors (`:messages`)
- `:Lazy` shows all plugins loaded; `:checkhealth lazy` is OK
- `:TSStatus` shows installed parsers; highlighting works in sample files
- `:checkhealth vim.treesitter` is OK
- `:Mason` opens; required servers install successfully
- `:checkhealth vim.lsp` shows enabled servers without errors
- LSP attaches in Lua and TypeScript files (`:lua vim.lsp.get_clients()`)
- Telescope finds files and greps text
- Oil opens, renames, creates, and deletes files safely
- Completion works in insert mode (Phase 6+)
- Formatting works manually before enabling format on save (Phase 7+)
- Git signs appear in changed files (Phase 8+)
- `opencode` can be launched from inside Neovim (Phase 9+, if implemented)
- Claude Code can be launched from inside Neovim (Phase 9+, if installed)

## Migration Strategy

Do not delete the old `nvim` config.

Use the new config explicitly while testing:

```sh
NVIM_APPNAME=nvim-new nvim
```

Once the new setup is comfortable, decide whether to:

- Keep both configs.
- Rename `nvim-new` to `nvim`.
- Symlink the new config into the active Neovim config location.
