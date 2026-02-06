local M = {}

local notify = require('buildit.notify')
local util = require('buildit.util')
local detect = require('buildit.detect')
local state = require('buildit.state')
local config = require('buildit.config')
local output = require('buildit.output')

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

local function try_custom_project(method)
    local _, root = detect.detect()
    root = root or vim.fn.getcwd()
    local project_name = vim.fn.fnamemodify(root, ':t')
    local project = config.options.projects[project_name]

    if not project then
        return false
    end

    local cmd = project[method]
    if not cmd then
        notify.error("No custom '" .. method .. "' command defined for project " .. project_name)
        return true
    end

    state.set_running(project_name)
    output.run_cmd(cmd, root)
    return true
end

local function run_backend(method)
    if try_custom_project(method) then
        return
    end

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
        state.set_running(system_name)
        backend[method](root)
    end
end

function M.configure() run_backend('configure') end
function M.build() run_backend('build') end
function M.clean() run_backend('clean') end
function M.test() run_backend('test') end

return M
