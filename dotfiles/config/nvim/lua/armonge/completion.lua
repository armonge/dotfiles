local lspconfig = require("lspconfig")

-- Add additional capabilities supported by nvim-cmp
local capabilities = require("cmp_nvim_lsp").default_capabilities()

require("mason-lspconfig").setup_handlers({
	-- The first entry (without a key) will be the default handler
	-- and will be called for each installed server that doesn't have
	-- a dedicated handler.
	function(server_name) -- default handler (optional)
		lspconfig[server_name].setup({
			-- on_attach = my_custom_on_attach,
			capabilities = capabilities,
		})
	end,
	-- -- Next, you can provide a dedicated handler for specific servers.
	-- -- For example, a handler override for the `rust_analyzer`:
	-- ["rust_analyzer"] = function()
	--   require("rust-tools").setup {}
	-- end
})

local lspkind = require("lspkind")
lspkind.init({
	symbol_map = {
		Copilot = "",
	},
})

vim.api.nvim_set_hl(0, "CmpItemKindCopilot", { fg = "#6CC644" })
-- luasnip setup
local luasnip = require("luasnip") -- nvim-cmp setup

local check_backspace = function()
	local col = vim.fn.col(".") - 1
	return col == 0 or vim.fn.getline("."):sub(col, col):match("%s")
end

local types = require("cmp.types")

-- nvim-cmp setup
local cmp = require("cmp")

cmp.setup({
	snippet = {
		expand = function(args)
			luasnip.lsp_expand(args.body) -- For `luasnip` users.
		end,
	},
	mapping = cmp.mapping.preset.insert({
		["<C-k>"] = cmp.mapping(
			cmp.mapping.select_prev_item({ behavior = types.cmp.SelectBehavior.Select }),
			{ "i", "c" }
		),
		["<C-j>"] = cmp.mapping(
			cmp.mapping.select_next_item({ behavior = types.cmp.SelectBehavior.Select }),
			{ "i", "c" }
		),
		["<C-h>"] = function()
			if cmp.visible_docs() then
				cmp.close_docs()
			else
				cmp.open_docs()
			end
		end,
		["<C-b>"] = cmp.mapping(cmp.mapping.scroll_docs(-1), { "i", "c" }),
		["<C-f>"] = cmp.mapping(cmp.mapping.scroll_docs(1), { "i", "c" }),
		["<C-Space>"] = cmp.mapping(cmp.mapping.complete(), { "i", "c" }),
		["<C-e>"] = cmp.mapping({
			i = cmp.mapping.abort(),
			c = cmp.mapping.close(),
		}),
		-- Accept currently selected item. If none selected, `select` first item.
		-- Set `select` to `false` to only confirm explicitly selected items.
		["<C-CR>"] = cmp.mapping.confirm({ select = true }),
		["<Tab>"] = cmp.mapping(function(fallback)
			if cmp.visible() then
				cmp.select_next_item()
			elseif luasnip.expandable() then
				luasnip.expand()
			elseif luasnip.expand_or_jumpable() then
				luasnip.expand_or_jump()
			elseif check_backspace() then
				-- fallback()
				require("neotab").tabout()
			else
				require("neotab").tabout()
				-- fallback()
			end
		end, {
			"i",
			"s",
		}),
		["<S-Tab>"] = cmp.mapping(function(fallback)
			if cmp.visible() then
				cmp.select_prev_item()
			elseif luasnip.jumpable(-1) then
				luasnip.jump(-1)
			else
				fallback()
			end
		end, {
			"i",
			"s",
		}),
	}),
	sources = {
		{ name = "copilot" },
		{
			name = "nvim_lsp",
			entry_filter = function(entry, ctx)
				local kind = require("cmp.types.lsp").CompletionItemKind[entry:get_kind()]
				if kind == "Snippet" and ctx.prev_context.filetype == "java" then
					return false
				end

				if ctx.prev_context.filetype == "markdown" then
					return true
				end

				if kind == "Text" then
					return false
				end

				return true
			end,
		},
		{ name = "luasnip" },
		{ name = "nvim_lua" },
		{ name = "buffer" },
		{ name = "path" },
		-- { name = "treesitter" },
	},
	confirm_opts = {
		behavior = cmp.ConfirmBehavior.Replace,
		select = false,
	},
	view = {
		entries = {
			name = "custom",
			selection_order = "top_down",
		},
		docs = {
			auto_open = true,
		},
	},
	window = {
		completion = {
			border = "rounded",
			winhighlight = "Normal:Pmenu,CursorLine:PmenuSel,FloatBorder:FloatBorder,Search:None",
			col_offset = -3,
			side_padding = 1,
			scrollbar = false,
			scrolloff = 8,
		},
		documentation = {
			border = "rounded",
			winhighlight = "Normal:Pmenu,FloatBorder:FloatBorder,Search:None",
		},
	},
	experimental = {
		ghost_text = false,
	},
})

-- Set configuration for specific filetype.
cmp.setup.filetype("gitcommit", {
	sources = cmp.config.sources({
		{ name = "git" }, -- You can specify the `git` source if [you were installed it](https://github.com/petertriho/cmp-git).
		{ name = "buffer" },
		{ name = "gitmoji" },
	}),
})

-- Use buffer source for `/` and `?` (if you enabled `native_menu`, this won't work anymore).
cmp.setup.cmdline({ "/", "?" }, {
	mapping = cmp.mapping.preset.cmdline(),
	sources = {
		{ name = "buffer" },
	},
})
-- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
cmp.setup.cmdline(":", {
	mapping = cmp.mapping.preset.cmdline(),
	sources = cmp.config.sources({
		{ name = "path" },
	}, {
		{ name = "cmdline" },
	}),
})
