-- Made by Luk
-- http://steamcommunity.com/id/doctorluk/
-- Version: 1.0
-- https://github.com/doctorluk/ULX-CSS-Checker

-- Global client vars
CS_CONTENT_CHECK_HAS_CSS_INSTALLED = true
CS_CONTENT_CHECK_FILE_MISSING = ""

-- Checks given filelist for existance
function checkFile( filelist, isdebug )

	for _, filename in pairs( filelist ) do
		local exists = file.Exists( filename, "GAME" )
		if exists and isdebug then
			chat.AddText( Color( 255, 255, 200, 255 ), "[CS:S CHECK] ",
			Color( 160, 160, 160, 255 ), filename,
			Color( 100, 255, 100, 255 ), " exists!" )
		else
			CS_CONTENT_CHECK_HAS_CSS_INSTALLED = false
			CS_CONTENT_CHECK_FILE_MISSING = filename
			if isdebug then 
				chat.AddText( Color( 255, 255, 200, 255 ), "[CS:S CHECK] ",
				Color( 160, 160, 160, 255 ), filename,
				Color( 255, 50, 50, 255 ), " MISSING!" )
			end
			print("You are missing file " .. filename .. "! Please validate your CS:S installation!")
		end
	end
	
end

-- Hook that runs upon receival of the server's check
net.Receive( "cscontentcheck_check", function()

	local checktype = net.ReadString()
	local filelist = net.ReadTable()
	local isdebug = net.ReadBool()
	local result = false
	
	if checktype == "mount" then
		result = IsMounted( 'cstrike' )
		if isdebug and result then
			chat.AddText( Color( 255, 255, 200, 255 ), "[CS:S CHECK] ",
			Color( 100, 255, 100, 255 ), "CS:S is mounted!" )
		end
	elseif checktype == "file" then
		checkFile( filelist, isdebug )
		result = CS_CONTENT_CHECK_HAS_CSS_INSTALLED
	end
	
	net.Start( "cscontentcheck_response" )
	net.WriteString( checktype )
	net.WriteBool( result )
	net.WriteString( CS_CONTENT_CHECK_FILE_MISSING )
	net.SendToServer()
	
end)