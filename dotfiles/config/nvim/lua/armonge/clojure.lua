return {
	{
		"Olical/conjure",
		ft = { "clojure", "fennel" },
		init = function()
			-- Flash the form that was just evaluated
			vim.g["conjure#highlight#enabled"] = true
			-- vim.g["conjure#debug"] = true  -- verbose logging when filing issues
		end,
	},
	{
		-- Structural editing (slurp/barf/wrap/raise). Maintained, treesitter-based.
		"julienvincent/nvim-paredit",
		ft = { "clojure", "fennel" },
		opts = {},
	},
	{
		-- Rainbow-colored matching parens — the one nicety no lisper skips
		"HiPhish/rainbow-delimiters.nvim",
		ft = { "clojure", "fennel" },
	},
}
