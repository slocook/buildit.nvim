local M = {}

local output = require('buildit.output')

function M.configure()
    output.run_cmd('./configure')
end

function M.build()
    output.run_cmd('make')
end

function M.clean()
    output.run_cmd('make clean')
end

return M
