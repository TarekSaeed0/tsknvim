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

				local function is_installed(formatter)
					if mason_registery.has_package(formatter) then
						local package = mason_registery.get_package(formatter)

						if package:is_installed() then
							return true
						end

						if package.spec.bin then
							local all_binaries_installed = true
							for binary in pairs(package.spec.bin) do
								if vim.fn.executable(binary) ~= 1 then
									all_binaries_installed = false
									break
								end
							end

							if all_binaries_installed then
								return true
							end
						end
					else
						local ok, config = pcall(require, "conform.formatters." .. formatter)
						local formatter_binary = config.command
						if ok then
							local packages = mason_registery.get_all_packages()
							for _, package in ipairs(packages) do
								if package.spec.bin then
									local contains_formatter = false
									local all_binaries_installed = true
									for binary in pairs(package.spec.bin) do
										if binary == formatter_binary then
											contains_formatter = true
										end
										if vim.fn.executable(binary) ~= 1 then
											all_binaries_installed = false
										end
									end

									if contains_formatter then
										return package:is_installed() or all_binaries_installed
									end
								end
							end
						end
					end

					return false
				end

				local function install(formatter)
					if mason_registery.has_package(formatter) then
						local package = mason_registery.get_package(formatter)

						local install_successed = false
						package:install({}):once("install:success", function()
							install_successed = true
						end)

						return install_successed
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
										local install_successed = false
										package:install({}):once("install:success", function()
											install_successed = true
										end)

										return install_successed
									end
								end
							end
						end
					end

					return false
				end

				for _, file_type_formatter in pairs(opts.formatters_by_ft) do
					for _, formatter_unit in ipairs(file_type_formatter) do
						if vim.tbl_islist(formatter_unit) then
							local any_formatter_installed = false
							for _, formatter in ipairs(formatter_unit) do
								if is_installed(formatter) then
									any_formatter_installed = true
									break
								else
									vim.notify(formatter .. " isn't installed")
								end
							end

							if not any_formatter_installed then
								for _, formatter in ipairs(formatter_unit) do
									if install(formatter) then
										vim.notify("Installed " .. formatter)
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
								if install(formatter) then
									vim.notify("Installed " .. formatter)
								else
									vim.notify("Failed to install " .. formatter, vim.log.levels.ERROR)
								end
							end
						end
					end
				end
			end

			require("conform").setup(opts)
		end,
		event = { "BufReadPre", "BufNewFile" },
		cmd = "ConformInfo",
	},
}
