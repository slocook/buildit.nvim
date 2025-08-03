local M = {}

local system = require('buildit.systems')

function M.setup()
    vim.api.nvim_create_user_command('BuilditConfigure', system.configure, {})
    vim.api.nvim_create_user_command('BuilditBuild', system.build, {})
    vim.api.nvim_create_user_command('BuilditClean', system.clean, {})
    vim.api.nvim_create_user_command('BuilditToggleOutput', 
        function()
            require('buildit.output').toggle()
        end, {})
end

return M
