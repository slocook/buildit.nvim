# Buildit

A simple Neovim plugin written in Lua that provides a basic interface to build systems. Detects your
build system automatically and exposes user commands to configure and build.

## 🚀 Features
  - Auto-detects build system
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

## TODO
  - [ ] Improve automatic build system and project root detection
  - [ ] Add configurability for build settings
