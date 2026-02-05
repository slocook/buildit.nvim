local M = {}

-- Build system markers in priority order
local markers = {
    { files = { 'CMakeLists.txt' }, system = 'cmake' },
    { files = { 'configure.ac', 'configure.in' }, system = 'autotools' },
    { files = { 'build.ninja' }, system = 'ninja' },
    { files = { 'Makefile', 'makefile', 'GNUmakefile' }, system = 'autotools' },
}

-- Root markers for fallback project root detection
local root_markers = { '.git', '.hg', '.svn' }

local function find_upward(filenames, start_path)
    local results = vim.fs.find(filenames, {
        upward = true,
        type = 'file',
        path = start_path,
        limit = 1
    })
    if results and #results > 0 then
        return vim.fs.dirname(results[1])
    end
    return nil
end

local function find_root_marker(start_path)
    local results = vim.fs.find(root_markers, {
        upward = true,
        path = start_path,
        limit = 1
    })
    if results and #results > 0 then
        return vim.fs.dirname(results[1])
    end
    return nil
end

function M.detect(start_path)
    start_path = start_path or vim.fn.getcwd()

    -- Try each marker in priority order
    for _, marker in ipairs(markers) do
        local root = find_upward(marker.files, start_path)
        if root then
            return marker.system, root
        end
    end

    -- No build system found, try to find project root via VCS markers
    local root = find_root_marker(start_path)
    return nil, root
end

function M.project_root(start_path)
    local _, root = M.detect(start_path)
    return root or vim.fn.getcwd()
end

return M
