
return {
	{ "Olical/conjure", ft = { "clojure", "fennel" }, -- etc lazy = true,
		init = function()
			-- Set configuration options here
			-- Uncomment this to get verbose logging to help diagnose internal Conjure issues
			-- This is VERY helpful when reporting an issue with the project
			-- vim.g["conjure#debug"] = true
		end,
	},
	{
		"PaterJason/cmp-conjure",
		lazy = true,
		ft = { "clojure", "fennel" },
	},
	{
		"PaterJason/nvim-treesitter-sexp",
		ft = { "clojure", "fennel" },
	}
}
