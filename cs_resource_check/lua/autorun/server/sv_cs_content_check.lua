-- Made by Luk
-- http://steamcommunity.com/id/doctorluk/
-- Version: 1.0
-- https://github.com/doctorluk/ULX-CSS-Checker

if SERVER then

util.AddNetworkString( "cscontentcheck_check" )
util.AddNetworkString( "cscontentcheck_response" )


net.Receive( "cscontentcheck_response", function( len )
	
	local steamid = net.ReadString()
	local ply = player.GetBySteamID( steamid )
	local type = net.ReadString()
	local response = net.ReadBool()
	
	if response then response = 1 else response = 0 end
	-- print(os.date("%X") .. " Result for type " .. type .. " is " .. response)
	
	if response == 0 and type == "mount" then
		cs_content_check( ply, "file" )
	elseif response == 0 then
		local players = player.GetAll()
		for _, player in ipairs( players ) do
				ULib.tsayColor( player, true,
				Color( 100, 100, 255, 255 ), "[CS:S CHECK] ",
				Color( 255, 255, 0, 0	), ply:Nick(), 
				Color( 255, 0, 0, 255	), " is missing CS:S!")
		end
		game.KickID( ply:SteamID(), CS_CHECK_KICK_REASON )
	end
	
end)

function cs_content_check( ply, checktype )
	
	local checktype = checktype or "mount"
	
	timer.Simple( 1, function() 
		-- print(os.date("%X") ..  " Sending client check for '" .. checktype .. "'")
		net.Start( "cscontentcheck_check" )
		if checktype == "mount" then
			net.WriteString( checktype )
			net.WriteTable( {} )
			net.Send( ply )
		elseif CS_CONTENT_FILES then
			local table_sent = {}
			for i = 0, CS_CHECK_FILE_AMOUNT, 1 do
				table.insert( table_sent, CS_CONTENT_FILES[math.random(table.getn(CS_CONTENT_FILES))] )
			end
			net.WriteString( checktype )
			net.WriteTable( table_sent )
			net.Send( ply )
		end
	end )
end
hook.Add( "PlayerInitialSpawn", "cs_content_check_init", cs_content_check )

end