---@type LazySpec[]
return {
	{
		"mfussenegger/nvim-lint",
		lazy = true,
		init = function(self)
			if self.opts and self.opts.linters_by_ft then
				vim.api.nvim_create_autocmd({ "BufWritePost", "BufReadPost", "InsertLeave" }, {
					callback = function()
						if
							self.opts.linters_by_ft[vim.opt.filetype:get()]
							or self.opts.linters_by_ft["*"]
							or self.opts.linters_by_ft["_"]
						then
							require("lazy.core.loader").load({ "nvim-lint" }, { ft = vim.opt.filetype:get() })
							vim.api.nvim_exec_autocmds(
								{ "BufWritePost", "BufReadPost", "InsertLeave" },
								{ group = "tsknvim_lint_on_write" }
							)
							return true
						end
					end,
				})
			end
		end,
		config = function(_, opts)
			if opts and opts.linters_by_ft then
				local registry = require("mason-registry")

				registry.refresh(vim.schedule_wrap(function()
					local packages = {}
					---@param name string
					---@return Package
					local function get_package(name)
						if not packages[name] then
							if registry.has_package(name) then
								packages[name] = registry.get_package(name)
							else
								local linter = require("lint").linters[name]
								if linter then
									packages[name] = vim.iter(registry.get_all_packages()):find(function(package)
										return package.spec.bin and package.spec.bin[linter.cmd]
									end)
								end
							end
						end

						return packages[name]
					end

					---@param name string
					---@return boolean
					local function is_installed(name)
						local linter = require("lint").linters[name]
						if linter then
							return vim.fn.executable(linter.cmd) == 1
						end

						local package = get_package(name)
						return package and package:is_installed()
					end

					---@param name string
					---@return boolean
					local function install(name)
						local package = get_package(name)
						if not package then
							return false
						end

						package:install({})

						return true
					end

					for _, linters in pairs(opts.linters_by_ft) do
						for _, linter in ipairs(linters) do
							if not is_installed(linter) then
								vim.notify(linter .. " isn't installed")
								vim.notify("Installing " .. linter)
								if not install(linter) then
									vim.notify("Failed to install " .. linter, vim.log.levels.ERROR)
								end
							end
						end
					end
				end))
			end

			vim.api.nvim_create_autocmd({ "BufWritePost", "BufReadPost", "InsertLeave" }, {
				group = vim.api.nvim_create_augroup("tsknvim_lint_on_write", { clear = true }),
				callback = function()
					local names = vim.list_extend({}, require("lint")._resolve_linter_by_ft(vim.bo.filetype))

					if opts.linters_by_ft["_"] and #names == 0 then
						vim.list_extend(names, opts.linters_by_ft["_"])
					end

					if opts.linters_by_ft["*"] then
						vim.list_extend(names, opts.linters_by_ft["*"])
					end

					require("lint").try_lint(names)
				end,
			})

			local lint = require("lint")
			for key, value in pairs(opts) do
				lint[key] = value
			end
		end,
	},
}
