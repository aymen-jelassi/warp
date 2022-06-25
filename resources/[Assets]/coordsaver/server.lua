RegisterCommand("pos", function(source, args, rawCommand)
  local coords = GetEntityCoords(GetPlayerPed(source))
  local heading = GetEntityHeading(GetPlayerPed(source))
    file = io.open( './coords.txt', "a")
    if file then
    file:write("{ ['x'] = " .. coords.x .. ", ['y'] = ".. coords.y .. ", ['z'] = " .. coords.z .. ", ['h'] = ".. heading .. "},")
		--file:write("{" .. coords.x .. ",".. coords.y .. "," .. coords.z .. ", Heading".. heading .. "},")
		file:write("\n")
    end
    file:close()
end)

RegisterCommand("pos2", function(source, args, rawCommand)
  local coords = GetEntityCoords(GetPlayerPed(source))
  local heading = GetEntityHeading(GetPlayerPed(source))
    file = io.open( './coords.txt', "a")
    if file then
    --file:write("{ ['x'] = " .. coords.x .. ", ['y'] = ".. coords.y .. ", ['z'] = " .. coords.z .. ", ['h'] = ".. heading .. ",")
		file:write("{" .. coords.x .. ",".. coords.y .. "," .. coords.z .. "},")
		file:write("\n")
    end
    file:close()
end)