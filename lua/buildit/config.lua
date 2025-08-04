local M = {}

M.options = {
    cmake = {
        build_dir = 'build',
        build_type = 'Debug'
    }
}

function M.setup(user_opts)
    user_opts = user_opts or {}
    M.options.cmake = vim.tbl_deep_extend('force', M.options.cmake, user_opts.cmake or {})
end

return M
