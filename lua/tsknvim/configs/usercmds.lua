local expression_utilities = {}

---@param identifier string
---@return string?
function expression_utilities.get_case(identifier)
	if identifier:match("^%l") and identifier:match("_") then
		return "snake_case"
	elseif identifier:match("^%u") and identifier:match("_") then
		return "screaming_snake_case"
	elseif identifier:match("-") then
		return "kebab_case"
	elseif identifier:match("^%u") and not identifier:match("_") then
		return "pascal_case"
	elseif identifier:match("^%l") and not identifier:match("_") then
		return "camel_case"
	end
end

---@param identifier string
---@return string
function expression_utilities.in_snake_case(identifier)
	local result = identifier:gsub("(%l)(%u)", "%1_%2")
	result = result:gsub("[- ]", "_")
	result = result:lower()
	return result
end

---@param identifier string
---@return string
function expression_utilities.in_screaming_snake_case(identifier)
	local result = expression_utilities.in_snake_case(identifier)
	result = result:upper()
	return result
end

---@param identifier string
---@return string
function expression_utilities.in_kebab_case(identifier)
	local result = identifier:gsub("(%l)(%u)", "%1-%2")
	result = result:gsub("[_ ]", "-")
	result = result:lower()
	return result
end

---@param identifier string
---@return string
function expression_utilities.in_pascal_case(identifier)
	local result = identifier:gsub("[-_]", " "):gsub("(%l)(%u)", "%1 %2"):gsub("(%w)(%w*)", function(a, b)
		return a:upper() .. b:lower()
	end)
	result = result:gsub(" ", "")
	return result
end

---@param identifier string
---@return string
function expression_utilities.in_camel_case(identifier)
	local result = expression_utilities.in_pascal_case(identifier)
	result = result:gsub("^%u", string.lower)
	return result
end

---@param expression string
---@param environment table<string, any>
---@return string?
local function evalute_expression(expression, environment)
	local function_, error_message = loadstring("return " .. expression)
	if not function_ then
		vim.notify("Failed to compile:\n" .. error_message, vim.log.levels.ERROR, { title = "evalute_expression" })
		return
	end

	function_ = setfenv(function_, environment)
	local success, result = pcall(function_)
	if not success or result == nil then
		vim.notify("Failed to execute:\n " .. result, vim.log.levels.ERROR, { title = "evalute_expression" })
		return
	end

	return tostring(result)
end

local templates_path = vim.fn.stdpath("config") .. "/lua/tsknvim/templates"

---@return table<integer, string>
local function get_templates()
	local templates = {}

	local handle = vim.uv.fs_scandir(templates_path)
	if not handle then
		return templates
	end

	while true do
		local name, type = vim.uv.fs_scandir_next(handle)
		if not name or not type then
			break
		end

		if type == "directory" then
			table.insert(templates, name)
		end
	end

	return templates
end

---@param directory string
---@param traversal? "preorder" | "postorder"
local function entries_coroutine(directory, traversal)
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

		if traversal == "postorder" then
			if type == "directory" then
				entries_coroutine(path, traversal)
			end
			coroutine.yield(path, type)
		else
			coroutine.yield(path, type)
			if type == "directory" then
				entries_coroutine(path, traversal)
			end
		end
	end
end
---@param directory string
---@param traversal? "preorder" | "postorder"
---@return fun(...): string, string
local function entries(directory, traversal)
	return coroutine.wrap(function()
		entries_coroutine(directory, traversal)
	end)
end

---@param directory string
---@return boolean
local function remove_directory(directory)
	for path, type in entries(directory, "postorder") do
		if type == "directory" then
			local success, error_message = vim.uv.fs_rmdir(path)
			if not success then
				vim.notify(
					("Failed to remove directory: %s"):format(error_message),
					vim.log.levels.ERROR,
					{ title = "create_project" }
				)
				return false
			end
		else
			local success, error_message = vim.uv.fs_unlink(path)
			if not success then
				vim.notify(
					("Failed to remove file: %s"):format(error_message),
					vim.log.levels.ERROR,
					{ title = "create_project" }
				)
				return false
			end
		end
	end

	local success, error_message = vim.uv.fs_rmdir(directory)
	if not success then
		vim.notify(
			("Failed to remove directory: %s"):format(error_message),
			vim.log.levels.ERROR,
			{ title = "create_project" }
		)
		return false
	end

	return true
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

---@param project_path string
---@param template_path string
---@param arguments table<string, string>
---@return boolean
local function create_project(project_path, template_path, arguments)
	local expression_cache = {}
	local expression_pattern = "#{%s*(.-)%s*}#"
	local expression_environment =
		setmetatable(vim.tbl_extend("force", expression_utilities, arguments), { __index = _G })

	if not vim.uv.fs_mkdir(project_path, 511) then
		vim.notify(
			('Failed to create directory "%s"'):format(project_path),
			vim.log.levels.ERROR,
			{ title = "create_project" }
		)
		return false
	end

	for path, type in entries(template_path) do
		for expression in (path:sub(template_path:len() + 1)):gmatch(expression_pattern) do
			if not expression_cache[expression] then
				expression_cache[expression] = evalute_expression(expression, expression_environment)
				if not expression_cache[expression] then
					return false
				end
			end
		end
		local new_path = project_path .. path:sub(template_path:len() + 1):gsub(expression_pattern, expression_cache)
		if type == "directory" then
			if not vim.uv.fs_mkdir(new_path, 511) then
				vim.notify(
					('Failed to create directory "%s"'):format(project_path),
					vim.log.levels.ERROR,
					{ title = "create_project" }
				)
				return false
			end
		elseif is_text_file(path) then
			local file = io.open(path)
			if not file then
				vim.notify(
					('Failed to open file "%s"'):format(path),
					vim.log.levels.ERROR,
					{ title = "create_project" }
				)
				return false
			end

			local content = file:read("*a")
			file:close()
			if not content then
				vim.notify(
					('Failed to read file "%s"'):format(path),
					vim.log.levels.ERROR,
					{ title = "create_project" }
				)
				return false
			end

			for expression in content:gmatch(expression_pattern) do
				if not expression_cache[expression] then
					expression_cache[expression] = evalute_expression(expression, expression_environment)
					if not expression_cache[expression] then
						return false
					end
				end
			end
			content = content:gsub(expression_pattern, expression_cache)

			local new_file = io.open(new_path, "w")
			if not new_file then
				vim.notify(
					('Failed to open file "%s"'):format(new_path),
					vim.log.levels.ERROR,
					{ title = "create_project" }
				)
				return false
			end

			if not new_file:write(content) then
				vim.notify(
					('Failed to write file "%s"'):format(new_path),
					vim.log.levels.ERROR,
					{ title = "create_project" }
				)
				return false
			end
			new_file:close()
		elseif type == "link" then
			local target, error_message = vim.uv.fs_readlink(path)
			if not target then
				vim.notify(
					("Failed to read link: %s"):format(error_message),
					vim.log.levels.ERROR,
					{ title = "create_project" }
				)
				return false
			end

			---@diagnostic disable-next-line: redefined-local
			local success, error_message = vim.uv.fs_symlink(target, new_path)
			if not success then
				vim.notify(
					("Failed to copy file: %s"):format(error_message),
					vim.log.levels.ERROR,
					{ title = "create_project" }
				)
				return false
			end
		else
			local success, error_message = vim.uv.fs_copyfile(path, new_path)
			if not success then
				vim.notify(
					("Failed to copy file: %s"):format(error_message),
					vim.log.levels.ERROR,
					{ title = "create_project" }
				)
				return false
			end
		end
	end

	return true
end

vim.api.nvim_create_user_command("CreateProject", function(opts)
	local arguments = {}

	for _, argument in ipairs(opts.fargs) do
		local key, value = string.match(argument, "([^=]*)=(.*)")
		if key and value then
			if arguments[key] then
				vim.notify("Duplicate keys are not allowed", vim.log.levels.ERROR, { title = opts.name })
				return
			end
			arguments[key] = value
		else
			if arguments.name then
				vim.notify("Only a single positional argument is allowed", vim.log.levels.ERROR, { title = opts.name })
				return
			end
			arguments.name = argument
		end
	end

	local name = arguments.name
	if not name then
		vim.notify("Name argument is required", vim.log.levels.ERROR, { title = opts.name })
		return
	end

	local template = arguments.template
	if not template then
		vim.notify("Template argument is required", vim.log.levels.ERROR, { title = opts.name })
		return
	end

	if vim.uv.fs_stat(name) then
		vim.notify(('A project named "%s" already exists'):format(name), vim.log.levels.ERROR, { title = opts.name })
		return
	end

	print(('Creating a project named "%s" from %s project template'):format(name, template))

	local project_path = arguments.name
	local template_path = templates_path .. "/" .. arguments.template
	if not create_project(project_path, template_path, arguments) then
		vim.notify("Failed to create project", vim.log.levels.ERROR, { title = opts.name })
		remove_directory(arguments.name)
	end
end, {
	nargs = "+",
	complete = function(arg_lead, cmd_line, cursor_pos)
		local arguments = {}

		for argument in cmd_line:sub(1, cursor_pos):gmatch("(%S+)") do
			local key, value = string.match(argument, "([^=]*)=(.*)")
			if key and value then
				arguments[key] = value
			else
				table.insert(arguments, argument)
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
					return key and not arguments[key]
				end)
				:totable()
		end
	end,
})
