local module = ...
return {
	{
		"stevearc/conform.nvim",
		init = function()
			local opts = require(module)[1].opts
			vim.api.nvim_create_autocmd("BufWritePre", {
				callback = function()
					if opts.formatters_by_ft[vim.opt.filetype:get()] then
						require("lazy.core.loader").load({ "conform.nvim" }, { ft = vim.opt.filetype:get() })
						vim.api.nvim_exec_autocmds("BufWritePre", { group = "Conform" })
						return true
					end
				end,
			})
		end,
		opts = {
			formatters_by_ft = {
				c = { "clang-format" },
				cmake = { "cmake_format" },
				cpp = { "clang-format" },
				css = { { "prettierd", "prettier" } },
				html = { { "prettierd", "prettier" } },
				lua = { "stylua" },
				python = { "isort", "black" },
				rust = { "rustfmt" },
				sh = { "shfmt" },
				xml = { "xmlformat" },
			},
			format_on_save = {
				lsp_fallback = true,
				timeout_ms = 5000,
			},
			formatters = {
				xmlformat = {
					prepend_args = { "--indent", "1", "--indent-char", "\t" },
				},
			},
		},
		config = function(_, opts)
			if opts and opts.formatters_by_ft then
				local registery = require("mason-registry")

				registery.refresh(vim.schedule_wrap(function()
					local packages = {}
					local function get_package(name)
						if not packages[name] then
							if registery.has_package(name) then
								packages[name] = registery.get_package(name)
							else
								local ok, config = pcall(require, "conform.formatters." .. name)
								if ok then
									packages[name] = vim.iter(registery.get_all_packages()):find(function(package)
										return package.spec.bin and package.spec.bin[config.command]
									end)
								end
							end
						end

						return packages[name]
					end

					local function is_installed(name)
						local package = get_package(name)
						if not package then
							return false
						end

						if package:is_installed() then
							return true
						end

						if package.spec.bin then
							return vim.iter(vim.tbl_keys(package.spec.bin)):all(function(binary)
								return vim.fn.executable(binary) == 1
							end)
						end

						return false
					end

					local function install(name)
						local package = get_package(name)
						if not package then
							return false
						end

						package:install({})

						return true
					end

					for _, file_type_formatter in pairs(opts.formatters_by_ft) do
						for _, formatter_unit in ipairs(file_type_formatter) do
							if vim.islist(formatter_unit) then
								if not vim.iter(formatter_unit):any(is_installed) then
									vim.notify(("None of %s are installed"):format(vim.iter(formatter_unit):join(", ")))
									for _, formatter in ipairs(formatter_unit) do
										vim.notify("Installing " .. formatter)
										if install(formatter) then
											break
										else
											vim.notify("Failed to install " .. formatter, vim.log.levels.ERROR)
										end
									end
								end
							else
								local formatter = formatter_unit
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
