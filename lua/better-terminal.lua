local M = {}

local window_marker = "dotpluto-toggleterm-window"
local buffer_marker = "dotpluto-toggleterm-buffer"

local function create_win(buf_id)
	local width = math.floor(vim.o.columns / 2)
	local height = math.floor(vim.o.lines / 4)
	local offX = math.floor((vim.o.columns - width) / 2)
	local offY = math.floor(vim.o.lines - height - 6)
	local win = vim.api.nvim_open_win(buf_id, true,
	    { relative = "editor", row = offY, col = offX, width = width, height = height, border = "single" })
	vim.w[window_marker] = true
	return win
end

local function toggle_terminal()
    if vim.w[0][window_marker] == true then
	vim.api.nvim_win_close(0, false)
	return
    end
    for _, win_id in pairs(vim.api.nvim_list_wins()) do
	if vim.w[win_id][window_marker] == true then
	    vim.api.nvim_set_current_win(win_id)
	    vim.cmd.startinsert()
	    return
	end
    end

    for _, buf_id in pairs(vim.api.nvim_list_bufs()) do
	if vim.b[buf_id][buffer_marker] == true then
	    create_win(buf_id)
	    vim.cmd.startinsert()
	    return
	end
    end

    local win = create_win(0)
    vim.cmd.terminal()
    vim.cmd.startinsert()
    local buf = vim.api.nvim_win_get_buf(win)
    vim.b[buf][buffer_marker] = true
    vim.keymap.set("t", "<C-;>", function ()
	vim.cmd.stopinsert()
	vim.api.nvim_win_close(0, false)
    end, { buffer = buf })
end

function M.setup(_)
    vim.keymap.set("n", "<C-;>", toggle_terminal, { desc = "Better Terminal" })
    vim.keymap.set("n", "<leader>t", toggle_terminal, { desc = "Better Terminal" })
end

return M;
