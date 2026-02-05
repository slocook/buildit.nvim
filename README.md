# Buildit

A simple Neovim plugin written in Lua that provides a basic interface to build systems. Detects your
build system automatically and exposes user commands to configure and build.

## 🚀 Features
  - Auto-detects build system (searches parent directories)
  - Toggleable output window
  - Easily extensible

## Installation

Lazy.nvim:
```
use {
    'slocook/buildit.nvim',
    config = function()
        require('buildit').setup()

        -- Optional keymaps:
        vim.keymap.set('n', '<leader>bg', ':BuilditConfigure<CR>')
        vim.keymap.set('n', '<leader>bb', ':BuilditBuild<CR>')
        vim.keymap.set('n', '<leader>bc', ':BuilditClean<CR>')
        vim.keymap.set('n', '<leader>bt', ':BuilditTest<CR>')
        vim.keymap.set('n', '<leader>bf', ':BuilditToggleOutput<CR>')
    end
}
```

## Usage

The following commands are provided:

| Command | Description |
|---------|-------------|
| `:BuilditConfigure` | Configures the project for building |
| `:BuilditBuild` | Builds the project |
| `:BuilditClean` | Cleans the project build |
| `:BuilditTest` | Runs tests |
| `:BuilditToggleOutput` | Show/hide the output window |

## Configuration

Pass options to `setup()` to customize build system settings:

```lua
require('buildit').setup({
    cmake = {
        build_dir = 'build',    -- Build directory (default: 'build')
        build_type = 'Debug',   -- Build type (default: 'Debug')
        threads = 4             -- Parallel jobs (default: 4)
    },
    ninja = {
        build_dir = 'build',    -- Build directory (default: 'build')
        threads = 4             -- Parallel jobs (default: 4)
    },
    autotools = {
        threads = 4             -- Parallel jobs for make (default: 4)
    }
})
```

## TODO
  - [ ] Additional build systems / languages
