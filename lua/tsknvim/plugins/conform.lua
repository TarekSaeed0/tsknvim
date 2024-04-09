return {
	{
		"stevearc/conform.nvim",
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
			},
			format_on_save = {
				lsp_fallback = true,
				timeout_ms = 1000,
			},
		},
		config = function(_, opts)
			if opts and opts.formatters_by_ft then
				local mason_registery = require("mason-registry")

				local function install_formatters()
					local formatters_packages = {}

					local function get_formatter_package(formatter)
						local formatter_package
						if formatters_packages[formatter] then
							formatter_package = formatters_packages[formatter]
						else
							if mason_registery.has_package(formatter) then
								formatter_package = mason_registery.get_package(formatter)
							else
								local ok, config = pcall(require, "conform.formatters." .. formatter)
								local formatter_binary = config.command
								if ok then
									local packages = mason_registery.get_all_packages()
									for _, package in ipairs(packages) do
										if package.spec.bin then
											local contains_formatter = false
											for binary in pairs(package.spec.bin) do
												if binary == formatter_binary then
													contains_formatter = true
												end
											end

											if contains_formatter then
												formatter_package = package
											end
										end
									end
								end
							end

							formatters_packages[formatter] = formatter_package
						end

						return formatter_package
					end

					local function is_formatter_installed(formatter)
						local formatter_package = get_formatter_package(formatter)
						if not formatter_package then
							return false
						end

						if formatter_package:is_installed() then
							return true
						end

						if formatter_package.spec.bin then
							local all_binaries_installed = true
							for binary in pairs(formatter_package.spec.bin) do
								if vim.fn.executable(binary) ~= 1 then
									all_binaries_installed = false
									break
								end
							end

							if all_binaries_installed then
								return true
							end
						end

						return false
					end

					local function install_formatter(formatter)
						local formatter_package = get_formatter_package(formatter)
						if not formatter_package then
							return false
						end

						formatter_package:install({})

						return true
					end

					for _, file_type_formatter in pairs(opts.formatters_by_ft) do
						for _, formatter_unit in ipairs(file_type_formatter) do
							if vim.tbl_islist(formatter_unit) then
								local any_formatter_installed = false
								for _, formatter in ipairs(formatter_unit) do
									if is_formatter_installed(formatter) then
										any_formatter_installed = true
										break
									else
										vim.notify(formatter .. " isn't installed")
									end
								end

								if not any_formatter_installed then
									for _, formatter in ipairs(formatter_unit) do
										if install_formatter(formatter) then
											break
										else
											vim.notify("Failed to install " .. formatter, vim.log.levels.ERROR)
										end
									end
								end
							else
								local formatter = formatter_unit
								if not is_formatter_installed(formatter) then
									vim.notify(formatter .. " isn't installed")
									if not install_formatter(formatter) then
										vim.notify("Failed to install " .. formatter, vim.log.levels.ERROR)
									end
								end
							end
						end
					end
				end

				mason_registery.refresh(vim.schedule_wrap(install_formatters))
			end

			require("conform").setup(opts)
		end,
		event = { "BufReadPre", "BufNewFile" },
		cmd = "ConformInfo",
	},
}
