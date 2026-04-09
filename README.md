# Javelin

Javelin is a small Go + Neovim helper that calculates cyclomatic complexity for
functions in the currently open Go file and displays each score as virtual text
at the end of the function declaration line.

It is currently optimized for simple, on-demand use from Neovim (including
LazyVim setups).

## How it works

Javelin has two parts:

- A Go CLI (`javelin`) that parses a Go file and emits JSON with function
  complexity metrics.
- A Lua module (`lua/init.lua`) that runs the CLI for the current buffer and
  renders complexity values using Neovim extmarks.

Complexity starts at `1` and increases for:

- `if`
- `for`
- `range`
- `case` in `switch`
- logical `&&` and `||`

## Prerequisites

- Go `1.22+`
- Neovim `0.9+` (works well in LazyVim)
- `javelin` binary available on your `PATH`

## Install the CLI

From this repository root:

```bash
go install ./cmd
```

This installs `javelin` into your Go bin directory (usually
`$HOME/go/bin`). Make sure that directory is on your `PATH`:

```bash
echo $PATH
```

If needed:

```bash
export PATH="$HOME/go/bin:$PATH"
```

## Use with Neovim / LazyVim

Add this plugin in your LazyVim spec (example using a local path while
developing):

```lua
return {
  {
    dir = "~/path/to/javelin",
    config = function()
      local javelin = require("javelin")
      vim.keymap.set("n", "<leader>jc", javelin.show_complexity, { desc = "Javelin: show complexity" })
    end,
  },
}
```

If you publish the repo, switch `dir` to your GitHub plugin spec:

```lua
{ "anthonyanosov/javelin", config = function() ... end }
```

## Usage

1. Open a Go file in Neovim.
2. Run `<leader>jc`.
3. Javelin prints `⚡ <complexity>` at end-of-line for each function.

Run the keymap again after edits to refresh annotations.

## CLI usage directly

```bash
javelin -src ./path/to/file.go
```

Example output:

```json
[{"Name":"process","Complexity":4,"StartLine":10,"EndLine":37}]
```

## Troubleshooting

- `Javelin: failed to run analyzer command`
  - Ensure `javelin` is installed and on your `PATH` inside Neovim.
- `Javelin: failed to parse JSON output`
  - Usually means the CLI returned a non-JSON error; run
    `javelin -src <file.go>` in a terminal to inspect output.
- No virtual text appears
  - Confirm the file is valid Go and has function declarations.

## Current limitations

- Only analyzes one file at a time (the current buffer).
- No automatic refresh on save (manual keymap trigger for now).
- Complexity is function-level only (not package/project aggregation yet).