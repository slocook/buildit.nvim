local M = {}

local system = require('buildit.systems')
local config = require('buildit.config')
local state = require('buildit.state')

function M.setup(user_config)
    config.setup(user_config)

    vim.api.nvim_create_user_command('BuilditConfigure', system.configure, {})
    vim.api.nvim_create_user_command('BuilditBuild', system.build, {})
    vim.api.nvim_create_user_command('BuilditClean', system.clean, {})
    vim.api.nvim_create_user_command('BuilditToggleOutput',
        function()
            require('buildit.output').toggle()
        end, {})
    vim.api.nvim_create_user_command('BuilditTest', system.test, {})
end

function M.status()
    return state.format()
end

return M
