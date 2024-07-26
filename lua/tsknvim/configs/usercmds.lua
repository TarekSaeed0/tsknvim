local templates_path = vim.fn.stdpath("config") .. "/lua/tsknvim/templates"

---@return table<integer, string>
local function get_templates()
	local templates = {}

	local handle = vim.uv.fs_scandir(templates_path)
	if not handle then
		return templates
	end

	while true do
		local template = vim.uv.fs_scandir_next(handle)
		if not template then
			break
		end

		table.insert(templates, template)
	end

	return templates
end

local function entries_coroutine(directory)
	local handle = vim.uv.fs_scandir(directory)
	if not handle then
		return
	end

	while true do
		local name, type = vim.uv.fs_scandir_next(handle)
		if not name or not type then
			break
		end

		local path = directory .. "/" .. name

		coroutine.yield(path, type)

		if type == "directory" then
			entries_coroutine(path)
		end
	end
end
local function entries(directory)
	return coroutine.wrap(function()
		entries_coroutine(directory)
	end)
end

---@param source string
---@param destination string
local function copy_directory(source, destination)
	if not vim.uv.fs_mkdir(destination, 438) then
		return
	end

	for source_path, type in entries(source) do
		local destination_path = destination .. source_path:sub(source:len() + 1)

		if type == "directory" then
			if not vim.uv.fs_mkdir(destination_path, 438) then
				return
			end
		else
			vim.uv.fs_copyfile(source_path, destination_path)
		end
	end
end

---@param path string
---@return boolean
local function is_text_file(path)
	local output = io.popen("file --brief --mime-type '" .. path:gsub("'", "'\"'\"'") .. "'")
	if not output then
		return false
	end

	local mime_type = output:read("*a")
	output:close()
	if not mime_type then
		return false
	end

	local type, subtype = mime_type:match("^(.*)/(.*)\n$")
	return type == "text" or subtype == "json" or subtype == "javascript"
end

---@param template string
---@return table<integer, string>
local function get_template_paremeters(template)
	local parameters = {}

	local template_path = templates_path .. "/" .. template

	for path, type in entries(template_path) do
		for match in (path:sub(template_path:len() + 1)):gmatch("#{([^}]*)}") do
			parameters[match] = match
		end
		if type ~= "directory" and is_text_file(path) then
			local file = io.open(path)
			if not file then
				break
			end

			---@type string
			local content = file:read("*a")

			for match in content:gmatch("#{([^}]*)}") do
				parameters[match] = match
			end

			file:close()
		end
	end

	return parameters
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
	if not template then
		vim.notify("Project template was not provided", vim.log.levels.ERROR, { title = opts.name })
		return
	end

	if vim.uv.fs_stat(name) then
		vim.notify(('A project named "%s" already exists'):format(name), vim.log.levels.ERROR, { title = opts.name })
		return
	end

	print(('Creating a project named "%s" from %s project template'):format(name, template))

	-- copy(templates_path .. "/" .. template, name)

	local parameters = get_template_paremeters(template)

	vim.notify(vim.inspect(parameters))
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
