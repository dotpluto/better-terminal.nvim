local M = {}

local window_marker = "dotpluto-toggleterm-window"
local buffer_marker = "dotpluto-toggleterm-buffer"

---@type string
local global_keybind = "<C-;>"
---@type string
local terminal_keybind = "<C-;>"

local function create_win(buf_id)
    local gap_vertical = 3
    local gap_horizontal = 6
    local width = vim.o.columns - gap_horizontal * 2 - 2 --subtracting two because of the border
    local height = vim.o.lines - gap_vertical * 2 - 2
    local offX = math.floor(gap_horizontal)
    local offY = math.floor(gap_vertical)
    local win = vim.api.nvim_open_win(buf_id, true,
        { relative = "editor", row = offY, col = offX, width = width, height = height, border = "single" })

    vim.w[window_marker] = true
    return win
end

local function toggle_terminal()
    -- If the current window is the proper owned floating window it is closed.
    if vim.w[0][window_marker] == true then
        vim.api.nvim_win_close(0, false)
        return
    end
    -- If the buffer is the right one but the window is the wrong one insert mode is started.
    if vim.b[0][buffer_marker] == true then
	vim.cmd.startinsert()
	return
    end
    --If the window is open but not focused it is set as focused.
    for _, win_id in pairs(vim.api.nvim_list_wins()) do
        if vim.w[win_id][window_marker] == true then
            vim.api.nvim_set_current_win(win_id)
            vim.cmd.startinsert()
            return
        end
    end
    -- The window is not open so the existing buffers are searched for the terminal buffer.
    for _, buf_id in pairs(vim.api.nvim_list_bufs()) do
        if vim.b[buf_id][buffer_marker] == true then
            create_win(buf_id)
            vim.cmd.startinsert()
            return
        end
    end

    -- The buffer does not exist yet so we need to create it and open a new window.
    local win = create_win(0)
    vim.cmd.terminal()
    vim.cmd.startinsert()
    local buf = vim.api.nvim_win_get_buf(win)
    vim.b[buf][buffer_marker] = true
    vim.keymap.set("t", terminal_keybind, function()
        vim.cmd.stopinsert()
	if vim.w[0][window_marker] == true then
	    vim.api.nvim_win_close(0, false)
	end
    end, { buffer = buf })
end

---@param opts { keymap: { normal: string|nil, terminal: string|nil } }
function M.setup(opts)
    if opts.keymap == nil then
	opts.keymap = {}
    end
    if type(opts.keymap.normal) == "string" then
	global_keybind = opts.keymap.normal;
    end
    if type(opts.keymap.terminal) == "string" then
	terminal_keybind = opts.keymap.terminal;
    end
    vim.keymap.set("n", assert(global_keybind), toggle_terminal, { desc = "Better Terminal" })
    vim.keymap.set("n", assert(terminal_keybind), toggle_terminal, { desc = "Better Terminal" })
end

return M;
