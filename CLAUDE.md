# Neovim Config — Architecture Notes

## Neovim version
0.12.0 — uses the **built-in `vim.pack` package manager** (no lazy.nvim/packer).

## Entry point
`init.lua` — loads modules in order:
1. `tools`     — installs helpers on `vim.my` (see below)
2. `modules`   — installs the `vim.my.module` system
3. `settings`  — loads `lua/config/settings.lua` and watches it for live-reload
4. `plugins`   — declares and configures all plugins
5. `start`     — applies settings (colorscheme, indentation, etc.)
6. `nim`       — custom Nim filetype support (runtime files, not a plugin)

## `vim.my` helpers (`lua/tools.lua`)
| Helper | Purpose |
|---|---|
| `vim.my.on_file_change(cb)` | Autocmd wrapper; fires `cb(file, event)` on save |
| `vim.my.print(val)` | Floating Lua-highlighted inspect window |
| `vim.my.require_load(mod)` | `require()` that bypasses the module cache |

## Module system (`lua/modules.lua`)
`vim.my.module "Name" { load = fn, unload = fn? }` registers a named module.
Modules are reloaded via `User ModuleReload_<Name>` autocmds.
`ModuleReload <Name>` / `ModuleReloadAll` user commands are available.

## Plugin system (`lua/plugins.lua`)
Plugins are declared as `{ "owner/repo" }` entries in `lua/config/settings.lua`
under `plugin_list` or `theme_list`, then passed to `vim.pack.add()`.

Each plugin **config file** lives at `lua/plugins/<stem>.lua` (stem matches
the require-able module name, e.g. `telescope`, `mini.files`, `which-key`).

A config file returns a table with up to two keys:
```lua
return {
    -- passed as positional args to require(stem).setup(...)
    opts = { { ... } },

    -- called after setup; receives the plugin module (or nil if require failed)
    setup = function(mod) ... end,
}
```
The loader (`plugins.lua`) uses `plenary.scandir` to find all files under
`lua/plugins/`, `dofile()`s each one, calls `mod.setup(unpack(cfg.opts))` if
applicable, then calls `cfg.setup(mod)`.

## Settings (`lua/config/settings.lua`)
Single source of truth for:
- `indentation` — global tab width + per-language overrides
- `colorscheme` — active colour scheme name
- `mapleader` — leader key (default `,`)
- `bindings` — **all** keymaps; plugin configs read from here so keys are centralised
- `plugin_list` / `theme_list` — plugins to install via `vim.pack.add()`

## Runtime files (non-plugin)
| Directory | Purpose |
|---|---|
| `ftdetect/` | `au BufRead,BufNewFile` rules (`.owl`, `.nim`/`.nimble`) |
| `ftplugin/` | Per-filetype options (commentstring, indentation) |
| `syntax/`   | Full VimScript syntax definitions |

## Key conventions
- All keymaps use `vim.my.settings.bindings.<name>` — never hardcoded strings.
- `vim.my.module` blocks are the unit of live-reload; touching `config/settings.lua` triggers `ModuleReloadAll`.
