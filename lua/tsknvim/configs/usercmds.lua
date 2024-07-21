local function get_languages()
	local path = vim.env.XDG_CONFIG_HOME .. "/templates"

	local directory = vim.uv.fs_opendir(path, nil, 100)
	if not directory then
		return {}
	end

	local entries = vim.uv.fs_readdir(directory)
	if not entries then
		return {}
	end

	return vim.iter(entries)
		:map(function(entry)
			return entry.name
		end)
		:totable()
end
local function get_templates(language)
	local path = vim.env.XDG_CONFIG_HOME .. "/templates/" .. language

	local directory = vim.uv.fs_opendir(path, nil, 100)
	if not directory then
		return {}
	end

	local entries = vim.uv.fs_readdir(directory)
	if not entries then
		return {}
	end

	return vim.iter(entries)
		:map(function(entry)
			return entry.name
		end)
		:totable()
end

vim.api.nvim_create_user_command("CreateProject", function(opts)
	local args = {}

	for _, arg in ipairs(opts.fargs) do
		local key, value = string.match(arg, "([^=]*)=(.*)")
		if key and value then
			args[key] = value
		else
			table.insert(args, arg)
		end
	end

	local name = args[1]
	if not name then
		vim.notify("Project name was not provided", vim.log.levels.ERROR, { title = opts.name })
		return
	end

	local language = args.language
	if not language then
		vim.notify("Project language was not provided", vim.log.levels.ERROR, { title = opts.name })
		return
	end

	local template = args.template or "default"

	print(('Creating a project named "%s" in language %s using %s template'):format(name, language, template))
end, {
	nargs = "+",
	complete = function(arg_lead, cmd_line, cursor_pos)
		local args = {}

		for arg in cmd_line:sub(1, cursor_pos):gmatch("(%S+)") do
			local key, value = string.match(arg, "([^=]*)=(.*)")
			if key and value then
				args[key] = value
			else
				table.insert(args, arg)
			end
		end

		local key, value = string.match(arg_lead, "([^=]*)=(.*)")
		if key and value then
			if key == "language" then
				return vim.iter(get_languages())
					:filter(function(item)
						return string.sub(item, 1, #value) == value
					end)
					:totable()
			elseif key == "template" and args.language then
				return vim.iter(get_templates(args.language))
					:filter(function(item)
						return string.sub(item, 1, #value) == value
					end)
					:totable()
			end
		else
			return vim.iter({ "language=", "template=" })
				:filter(function(item)
					return string.sub(item, 1, #arg_lead) == arg_lead
				end)
				:totable()
		end
	end,
})
