luasnip = require("luasnip")
Mapper = require("nvim-mapper")
local keyset = Mapper.map

local opts = { silent = true, noremap = true }
local group = "LuaSnip"

keyset({ "i" }, "<C-K>", function()
	luasnip.expand()
end, opts, group, "expand")
keyset({ "i", "s" }, "<C-L>", function()
	luasnip.jump(1)
end, opts, group, "jump")
keyset({ "i", "s" }, "<C-J>", function()
	luasnip.jump(-1)
end, opts, group, "jump_back")

keyset({ "i", "s" }, "<C-E>", function()
	if luasnip.choice_active() then
		luasnip.change_choice(1)
	end
end, opts, group, "change_choice")

-- be sure to load this first since it overwrites the snippets table.
luasnip.snippets = require("luasnip_snippets").load_snippets()
