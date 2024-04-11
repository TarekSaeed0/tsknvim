return {
	{
		"ahmedkhalf/project.nvim",
		config = function(_, opts)
			if require("tsknvim.utils").is_loaded("telescope.nvim") then
				require("telescope").setup({ extensions = { projects = { prompt_title = "Project History" } } })
				require("telescope").load_extension("projects")
			end

			require("project_nvim").setup(opts)
		end,
		event = { "BufReadPre", "BufNewFile" },
	},
}
