# Neovim Modernization Plan

This file is the source of truth for this project. The AI agent should read it at the start of every session and align suggestions with the current phase below.

## Goal

Create a modern Neovim configuration in a new `nvim-new` folder without modifying the existing `nvim` config.

The current config is already Lua-based and uses `lazy.nvim`, but several parts are outdated, especially the LSP/completion setup around `lsp-zero.nvim` and old server names like `tsserver`.

## Target Structure

```text
nvim-new/
  init.lua
  lua/
    config/
      options.lua
      keymaps.lua
      autocmds.lua
      lazy.lua
    plugins/
      ui.lua
      editor.lua
      treesitter.lua
      telescope.lua
      oil.lua
      lsp.lua
      completion.lua
      formatting.lua
      git.lua
      terminal.lua
```

This structure keeps the config small, modular, and easy to learn from.

## Phase 1: Minimal Working Config

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
- Bootstrap `lazy.nvim`.
- Confirm Neovim opens without errors.

## Phase 2: Core UI

Add a small UI layer:

- Colorscheme, possibly keeping `gruvbox.nvim`.
- Statusline with `lualine.nvim`.
- File icons with `nvim-web-devicons`.
- Keybinding discoverability with `which-key.nvim`.

Keep the UI useful but not overloaded.

## Phase 3: Navigation

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

## Phase 4: Syntax And Editing

Add modern syntax and editing tools:

- `nvim-treesitter` for syntax highlighting and parsing.
- `Comment.nvim` for commenting.
- `nvim-surround` for surrounding text objects.
- Optional: `nvim-autopairs` for automatic brackets and quotes.

Keep Treesitter languages close to the languages actually used:

- Lua
- Vimdoc
- Bash
- JSON
- YAML
- Markdown
- HTML
- CSS
- JavaScript
- TypeScript
- TSX
- Dockerfile
- Rust

## Phase 5: LSP

Replace `lsp-zero.nvim` with an explicit LSP setup.

Use:

- `mason.nvim`
- `mason-lspconfig.nvim`
- `nvim-lspconfig`

Configure LSP intentionally so it is clear how the pieces work:

- Server installation.
- Server setup.
- `on_attach` keymaps.
- Diagnostics.
- Capabilities for completion.

Initial servers:

- `lua_ls`
- `ts_ls`
- `html`
- `cssls`
- `eslint`
- `dockerls`
- `rust_analyzer`

If using Neovim 0.11 or newer, prefer the newer native LSP configuration style where practical.

## Phase 6: Completion

Choose one completion stack.

Recommended options:

- `blink.cmp` for a modern, fast setup.
- `nvim-cmp` if you want the more traditional and widely documented ecosystem.

For learning, use one stack only. Do not keep both.

Completion should support:

- LSP suggestions.
- Buffer words.
- File paths.
- Snippets.

## Phase 7: Formatting And Linting

Add formatting with:

- `conform.nvim`

Optional linting:

- `nvim-lint`

Start with formatting on save for safe languages and tools:

- Lua: `stylua`
- JavaScript/TypeScript: `prettier`
- JSON/YAML/Markdown: `prettier`
- Rust: `rustfmt`

Avoid too much automation until the rest of the config feels stable.

## Phase 8: Git

Add Git workflow plugins:

- `gitsigns.nvim` for inline Git changes.
- Keep `vim-fugitive` for powerful Git commands.

Useful keymaps:

- Preview hunk.
- Stage hunk.
- Reset hunk.
- Blame current line.
- Open Fugitive status.

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
- `toggleterm.nvim` for named floating or split terminals.
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

- Better diagnostics display.
- Project-local config if needed.
- More Telescope extensions.
- Better terminal integration.
- Session management only if actually needed.
- More terminal shortcuts for `opencode` or Claude Code once the basic workflow is useful.

Avoid adding large plugin bundles before understanding the basics.

## Validation Checklist

Before replacing the old config, verify:

- `nvim-new` opens without startup errors.
- `:Lazy` works.
- `:Mason` works.
- Telescope can find files and grep text.
- Oil can open, rename, create, and delete files safely.
- Treesitter highlighting works.
- LSP attaches in Lua and TypeScript files.
- Completion works in insert mode.
- Formatting works manually before enabling format on save.
- Git signs appear in changed files.
- `opencode` can be launched from inside Neovim if the terminal phase has been implemented.
- Claude Code can be launched from inside Neovim if it is installed and configured.

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

