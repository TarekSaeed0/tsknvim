---@type LazySpec[]
return {
	{
		"stevearc/conform.nvim",
		init = function(self)
			if self.opts and self.opts.formatters_by_ft then
				vim.api.nvim_create_autocmd("BufWritePre", {
					callback = function()
						if
							self.opts.formatters_by_ft[vim.opt.filetype:get()]
							or self.opts.formatters_by_ft["*"]
							or self.opts.formatters_by_ft["_"]
						then
							require("lazy.core.loader").load({ "conform.nvim" }, { ft = vim.opt.filetype:get() })
							vim.api.nvim_exec_autocmds("BufWritePre", { group = "Conform" })
							return true
						end
					end,
				})
			end
		end,
		opts = {
			format_on_save = {
				lsp_fallback = true,
				timeout_ms = 1000,
			},
		},
		config = function(_, opts)
			if opts and opts.formatters_by_ft then
				local registry = require("mason-registry")

				registry.refresh(vim.schedule_wrap(function()
					local packages = {}
					local function get_package(name)
						if not packages[name] then
							if registry.has_package(name) then
								packages[name] = registry.get_package(name)
							else
								local info = require("conform").get_formatter_info(name)
								if info.available_msg ~= "No config found" then
									packages[name] = vim.iter(registry.get_all_packages()):find(function(package)
										return package.spec.bin and package.spec.bin[info.command]
									end)
								end
							end
						end

						return packages[name]
					end

					local function is_installed(name)
						local info = require("conform").get_formatter_info(name)
						if info.available_msg ~= "No config found" then
							return info.available
						end

						local package = get_package(name)
						return package and package:is_installed()
					end

					local function install(name)
						local package = get_package(name)
						if not package then
							return false
						end

						package:install({})

						return true
					end

					for _, formatters in pairs(opts.formatters_by_ft) do
						if formatters.stop_after_first then
							formatters.stop_after_first = nil
							if not vim.iter(formatters):any(is_installed) then
								vim.notify(("None of %s are installed"):format(vim.iter(formatters):join(", ")))
								for _, formatter in ipairs(formatters) do
									vim.notify("Installing " .. formatter)
									if install(formatter) then
										break
									else
										vim.notify("Failed to install " .. formatter, vim.log.levels.ERROR)
									end
								end
							end
							formatters.stop_after_first = true
						else
							for _, formatter in ipairs(formatters) do
								if not is_installed(formatter) then
									vim.notify(formatter .. " isn't installed")
									vim.notify("Installing " .. formatter)
									if not install(formatter) then
										vim.notify("Failed to install " .. formatter, vim.log.levels.ERROR)
									end
								end
							end
						end
					end
				end))
			end

			require("conform").setup(opts)
		end,
		cmd = "ConformInfo",
	},
}
