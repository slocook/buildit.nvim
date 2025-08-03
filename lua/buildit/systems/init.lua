local M = {}

local function detect_system()
    if vim.fn.filereadable('CMakeLists.txt') == 1 then
        return 'cmake'
    elseif vim.fn.filereadable('configure.ac') == 1 then
        return 'autotools'
    elseif vim.fn.filereadable('build.ninja') == 1 then
        return 'ninja'
    end
end

local system_name = detect_system()
local backend = system_name and require('buildit.systems.' .. system_name)

function M.configure() return backend and backend.configure() end
function M.build() return backend and backend.build() end
function M.clean() return backend and backend.clean() end
function M.test() return backend and backend.test() end

return M
