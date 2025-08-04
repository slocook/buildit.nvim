local M = {}

local buf, win = nil, nil
local last_title = nil

function M.is_open()
    return win and vim.api.nvim_win_is_valid(win)
end

function M.close()
    if M.is_open() then
        vim.api.nvim_win_close(win, true)
        win = nil
    end
end

function M.toggle()
    if M.is_open() then
        M.close()
    else
        M.open(last_title)
    end
end

function M.open(title)
    if title then
        last_title = title
    end

    if M.is_open() then
        vim.api.nvim_set_current_win(win)
        return buf, win
    end

    buf = buf or vim.api.nvim_create_buf(false, true)
    local width = math.floor(vim.o.columns * 0.8)
    local height = math.floor(vim.o.lines * 0.8)
    local row = math.floor((vim.o.lines - height) / 2)
    local col = math.floor((vim.o.columns - width) / 2)

    win = vim.api.nvim_open_win(buf, true, {
        relative = 'editor',
        row = row,
        col = col,
        width = width,
        height = height,
        style = 'minimal',
        border = 'rounded',
        title = last_title
    })

    local opts = { noremap = true, silent = true, nowait = true }
    local close_cmd = ':close<CR>'

    vim.api.nvim_buf_set_keymap(buf, 'n', '<CR>', close_cmd, opts)
    vim.api.nvim_buf_set_keymap(buf, 'n', 'q', close_cmd, opts)
    vim.api.nvim_buf_set_keymap(buf, 'n', '<Esc>', close_cmd, opts)
    vim.api.nvim_buf_set_keymap(buf, 'n', '<C-c>', close_cmd, opts)

    return buf, win
end

local function project_root()
    -- TODO: needs to be improved
    local results = vim.fs.find({ 'CMakeLists.txt' }, { 
        upward = true, 
        type = 'file',
        limit = 5
    })

    if not results or #results == 0 then
        return nil
    end

    -- Horrible hack
    return vim.fs.dirname(results[5] or results[4] or results[3] or results[2] or results[1])
end

function M.run_cmd(cmd, subdir)
    buf = nil
    M.close()

    buf, win = M.open(cmd)
    local root = project_root() or vim.fn.getcwd()
    local dir = root .. '/' .. subdir

    vim.fn.termopen(cmd, {
        cwd = dir,
        on_exit = function()
            vim.api.nvim_set_current_win(win)
            vim.api.nvim_feedkeys(
                vim.api.nvim_replace_termcodes('<C-\\><C-n>', true, false, true),
                'n',
                false
            )
            -- vim.api.nvim_win_close(win, true)
        end
    })

    vim.cmd('startinsert')
end

return M
