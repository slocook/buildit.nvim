local M = {}

local notify = require('buildit.notify')
local util = require('buildit.util')
local detect = require('buildit.detect')

local tools = {
    cmake = 'cmake',
    ninja = 'ninja',
    autotools = 'make',
}

local function get_backend(system_name)
    if system_name then
        return require('buildit.systems.' .. system_name)
    end
    return nil
end

local function run_backend(method)
    local system_name, root = detect.detect()

    if not system_name then
        notify.error('No build system detected')
        return
    end

    local tool = tools[system_name]
    if not util.executable(tool) then
        notify.error(tool .. ' is not installed or not in PATH')
        return
    end

    local backend = get_backend(system_name)
    if backend and backend[method] then
        backend[method](root)
    end
end

function M.configure() run_backend('configure') end
function M.build() run_backend('build') end
function M.clean() run_backend('clean') end
function M.test() run_backend('test') end

return M
