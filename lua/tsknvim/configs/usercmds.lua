local function get_templates()
	local path = vim.env.XDG_CONFIG_HOME .. "/templates"

	local templates = {}

	local directory = vim.uv.fs_scandir(path)
	if not directory then
		return templates
	end

	while true do
		local template = vim.uv.fs_scandir_next(directory)
		if not template then
			break
		end

		table.insert(templates, template)
	end

	return templates
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
	local template = args.template

	if not vim.uv.fs_stat(name) then
		print(('Creating a project named "%s" from %s project template'):format(name, template))
	end
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
			if key == "template" then
				return vim.iter(get_templates())
					:filter(function(item)
						return string.sub(item, 1, #value) == value
					end)
					:totable()
			end
		else
			return vim.iter({ "template=" })
				:filter(function(item)
					return string.sub(item, 1, #arg_lead) == arg_lead
				end)
				:filter(function(item)
					key = string.match(item, "([^=]*)=(.*)")
					return key and args[key] == nil
				end)
				:totable()
		end
	end,
})
