-- Made by Luk
-- http://steamcommunity.com/id/doctorluk/
-- Version: 1.0
-- https://github.com/doctorluk/ULX-CSS-Checker

HAS_CSS_INSTALLED = true

function checkFile( filelist )

	for _, filename in pairs(filelist) do
		local exists = file.Exists( filename, "GAME" )
		if exists then
			print("[CS:S CHECK] File " .. filename .. " exists!")
		else
			HAS_CSS_INSTALLED = false
			print("[CS:S CHECK][ERROR] File " .. filename .. " MISSING!")
		end
	end
	
end

net.Receive( "cscontentcheck_check", function()

	local checktype = net.ReadString()
	local filelist = net.ReadTable()
	local result = false
	
	if checktype == "mount" then
		result = IsMounted( 'cstrike' )
		-- result = false
	elseif checktype == "file" then
		checkFile(filelist)
		result = HAS_CSS_INSTALLED
		-- result = false
	end
	
	net.Start( "cscontentcheck_response" )
	net.WriteString( LocalPlayer():SteamID() )
	net.WriteString( checktype )
	net.WriteBool( result )
	net.SendToServer()
end)