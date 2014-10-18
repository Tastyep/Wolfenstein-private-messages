function	getEpuredName(id)	-- remove spaces and color codes
	local	name = et.gentity_get(id, "pers.netname")

	if (name == nil) then return nil end
	name = string.gsub(name, "%^$", "^^ ")
	name = string.gsub(name, " ", "")
	name = string.gsub(name, "(^%w)", "")
	return	name
end

function	getName(id)	-- remove spaces and color codes
	local	name = et.gentity_get(id, "pers.netname")

	if (name == nil) then return nil end
	return	name
end

function	get_player_info(client)
	local	maxclients = tonumber((et.trap_Cvar_Get("sv_maxClients")) - 1)
	local	name = nil
	local	i = 0

	if (client == nil) then return -1, nil end
	if (string.find(client, "%a") == nil) then
		name = getName(client)
		return client, name
	end
	client = string.gsub(client, " ", "")
	client = string.gsub(client, "(^%w)", "")
	while (i < maxclients) do
		local	pl_name = getEpuredName(i)

		if (pl_name ~= nil) then
			if (pl_name ~= nil and string.find(pl_name, client) ~= nil) then
				return i, pl_name
			end
		end
		i = i + 1
	end
	return -1, nil
end

function	arrayToStr(array)
	local	str = ""
	
	for i, s in ipairs(array) do
		if (i > 1) then
			str = str .. " "
		end
		str = str .. s
	end
	return str
end

function	copyTableAt(array, at)
	local	newArray = {}
	
	for i, str in ipairs(array) do
		if (i >= at) then
			table.insert(newArray, str)
		end
	end
	return newArray
end

function	et_ClientCommand(clientNum, command)
	local	argc = et.trap_Argc()
	local	i = 0
	local	arg = {}

	while (i < argc) do
		arg[i + 1] = et.trap_Argv(i)
		i = i + 1
	end
	if (arg[1] == "m" and arg[2] ~= nil and arg[3] ~= nil) then
		local	id, name = get_player_info(arg[2])
		local	str
		local	array = copyTableAt(arg, 3)

		if (id == -1) then return 1 end
		str = arrayToStr(array)
		name = getName(clientNum)
		et.trap_SendServerCommand(clientNum, "chat \"("..name.." ^7-> "..getName(id).."^7): "..str.."\"")
		et.trap_SendServerCommand(id, "chat \""..name..": ^7"..str.."\"" )
	end
	return 0
end