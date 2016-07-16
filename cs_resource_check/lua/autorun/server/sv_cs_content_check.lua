-- Made by Luk
-- http://steamcommunity.com/id/doctorluk/
-- Version: 1.0
-- https://github.com/doctorluk/ULX-CSS-Checker

if SERVER then

	util.AddNetworkString( "cscontentcheck_check" )
	util.AddNetworkString( "cscontentcheck_response" )

	-- Receival of the player's result
	net.Receive( "cscontentcheck_response", function( len, ply )
		
		local type = net.ReadString()
		local response = net.ReadBool()
		local filename = net.ReadString()
		
		-- First check is to know whether the player has mounted CS:S, this is the fastest way to get a positive response
		-- If he hasn't, we check some randomly chosen files
		if not response and type == "mount" then
			cs_content_check( ply, "file" )
		elseif not response then
			local players = player.GetAll()
			
			-- Remove ULib requirement
			-- If ULib is installed we print a kick message
			if ULib then
				for _, player in ipairs( players ) do
						ULib.tsayColor( player, true,
						Color( 100, 100, 255, 255 ), "[CS:S CHECK] ",
						Color( 255, 255, 0, 0 ), ply:Nick(), 
						Color( 255, 0, 0, 255 ), " is missing file ",
						Color( 200, 120, 0, 255 ), filename,
						Color( 255, 0, 0, 255 ), "!")
				end
			end
			-- The player gets kicked if CS:S is not found
			game.KickID( ply:SteamID(), CS_CHECK_KICK_REASON )
		end
		
	end)

	-- Main function that starts upon a player's connection
	function cs_content_check( ply, checktype )
		
		-- By default (on first call) we check whether the player has mounted CS:S
		local checktype = checktype or "mount"
		
		timer.Simple( 1, function()
			-- print(os.date("%X") ..  " Sending client check for '" .. checktype .. "'")
			net.Start( "cscontentcheck_check" )
			
			-- First check is via mount, therefore the filetable is empty
			if checktype == "mount" then
				net.WriteString( checktype )
				net.WriteTable( {} )
				net.Send( ply )
			-- If mount fails we send a randomly constructed filetable to the client
			elseif CS_CONTENT_FILES then
				local filetable = {}
				
				for i = 0, CS_CHECK_FILE_AMOUNT, 1 do
					table.insert( filetable, CS_CONTENT_FILES[math.random(table.getn(CS_CONTENT_FILES))] )
				end
				
				net.WriteString( checktype )
				net.WriteTable( filetable )
				net.Send( ply )
			end
		end )
	end
	hook.Add( "PlayerInitialSpawn", "cs_content_check_init", cs_content_check )

end