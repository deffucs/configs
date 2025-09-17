vim.o.number = true
vim.o.relativenumber = true
vim.o.signcolumn = "yes"
vim.o.wrap = true
vim.o.tabstop = 2
vim.o.swapfile = false
vim.g.mapleader = " "
vim.o.winborder = "rounded"
vim.o.cursorcolumn = false
vim.o.ignorecase = true
vim.o.smartindent = true
vim.o.termguicolors = true
vim.o.undofile = true
vim.o.incsearch = true
vim.o.shiftwidth = 2
vim.o.completeopt = "fuzzy,menuone,noinsert,nosort,popup"

vim.g.go_code_completion_enabled = 0
vim.g.go_code_completion_enabled = 0


vim.keymap.set('n', '<leader>o', ':update<CR>:source<CR>')
-- vim.keymap.set('n', '<leader>w', ':write<CR>')
vim.keymap.set('n', '<leader>w', ':wa<CR>')
vim.keymap.set('n', '<leader>q', ':quit<CR>')

vim.keymap.set({ 'n', 'v', 'x' }, '<leader>y', '"+y<CR>')
vim.keymap.set({ 'n', 'v', 'x' }, '<leader>d', '"+d<CR>')
vim.keymap.set({ 'n', 'v', 'x' }, '<leader>v', ':e $MYVIMRC<CR>')
vim.keymap.set({ 'n', 'v', 'x' }, '<leader>s', ':e #<CR>')
vim.keymap.set({ 'n', 'v', 'x' }, '<leader>S', ':sf #<CR>')

vim.keymap.set({ 'n', 'v', 'x' }, '<C-j>', '<C-w>j')
vim.keymap.set({ 'n', 'v', 'x' }, '<C-k>', '<C-w>k')
vim.keymap.set({ 'n', 'v', 'x' }, '<C-h>', '<C-w>h')
vim.keymap.set({ 'n', 'v', 'x' }, '<C-l>', '<C-w>l')

vim.keymap.set('i', '<C-j>', '<C-n>')
vim.keymap.set('i', '<C-k>', '<C-p>')
vim.keymap.set('i', '<CR>', "pumvisible()? '<C-y>' : '<CR>'", { noremap = true, silent = true, expr = true })

vim.pack.add({
	-- colorscheme
	{ src = "https://github.com/morhetz/gruvbox.git" },
	-- oil - file explorer
	{ src = "https://github.com/stevearc/oil.nvim" },
	-- mini.pick - fuzzy finder
	{ src = "https://github.com/echasnovski/mini.pick" },
	-- collection of language server configurations
	{ src = "https://github.com/neovim/nvim-lspconfig" },
	{
		src = "https://github.com/saghen/blink.cmp",
		version = 'v1.7.0',
		opts = {
			keymap = {
				preset = 'enter',
			},
			completion = { documentation = { auto_show = true } },
		},
	},

	-- Mason would be for installing LSPs
	-- nvim-treesitter for fixing niche highlighting issues in some cases
})

-- Uncomment if a package update is needed
-- vim.pack.del({ 'blink.cmp' })
-- vim.pack.update({ 'blink.cmp' })

vim.api.nvim_create_autocmd('LspAttach', {
	callback = function(ev)
		local client = vim.lsp.get_client_by_id(ev.data.client_id)
		if client:supports_method('textDocument/completion') then
			vim.lsp.completion.enable(true, client.id, ev.buf, { autotrigger = true })
		end
	end,
})
vim.cmd("set completeopt+=noselect")


-- Autoformat on save
--vim.api.nvim_create_autocmd("BufWritePre", {
--	pattern = "*",
--	callback = function()
--		vim.lsp.buf.format({ async = false })
--	end,
--})

-- This chunk to fix imports and format on save came from neovim section on go.dev
vim.api.nvim_create_autocmd("BufWritePre", {
	pattern = "*.go",
	callback = function()
		local params = vim.lsp.util.make_range_params()
		params.context = { only = { "source.organizeImports" } }
		-- buf_request_sync defaults to a 1000ms timeout. Depending on your
		-- machine and codebase, you may want longer. Add an additional
		-- argument after params if you find that you have to write the file
		-- twice for changes to be saved.
		-- E.g., vim.lsp.buf_request_sync(0, "textDocument/codeAction", params, 3000)
		local result = vim.lsp.buf_request_sync(0, "textDocument/codeAction", params)
		for cid, res in pairs(result or {}) do
			for _, r in pairs(res.result or {}) do
				if r.edit then
					local enc = (vim.lsp.get_client_by_id(cid) or {}).offset_encoding or "utf-16"
					vim.lsp.util.apply_workspace_edit(r.edit, enc)
				end
			end
		end
		vim.lsp.buf.format({ async = false })
	end
})

require "mini.pick".setup()
require "oil".setup()

vim.keymap.set('n', '<leader>ff', ':Pick files<CR>')
vim.keymap.set('n', '<leader>fg', ':Pick grep_live<CR>')
vim.keymap.set('n', '<leader>h', ':Pick help<CR>')
vim.keymap.set('n', '<leader>-', ':Oil<CR>')

vim.lsp.enable({ "lua_ls", "gopls" })

-- Find global define for vim variable for working with this config file
vim.lsp.config("lua_ls", {
	settings = {
		Lua = {
			workspace = {
				library = vim.api.nvim_get_runtime_file("", true),
			}
		}
	}
})

-- LSP Keymaps
vim.keymap.set('n', '<leader>fm', vim.lsp.buf.format)
vim.keymap.set('n', '<leader>r', vim.lsp.buf.rename)
vim.keymap.set('n', '<leader>ca', vim.lsp.buf.code_action)
vim.keymap.set('n', 'gl', vim.diagnostic.open_float)

vim.keymap.set('n', 'gd', vim.lsp.buf.definition)
vim.keymap.set('n', 'gD', vim.lsp.buf.declaration)
vim.keymap.set('n', 'gr', vim.lsp.buf.references)
vim.keymap.set('n', 'gi', vim.lsp.buf.implementation)
vim.keymap.set('n', 'gt', vim.lsp.buf.type_definition)

vim.keymap.set('n', 'K', vim.lsp.buf.signature_help)
vim.keymap.set('n', '<C-k>', vim.lsp.buf.hover)

-- Or a dedicated key for clearing search highlights in normal mode
vim.keymap.set('n', '<leader>n', ':nohlsearch<CR>', { silent = true })

vim.cmd("colorscheme gruvbox")
vim.cmd(":hi statusline guibg=NONE")