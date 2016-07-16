-- Made by Luk
-- http://steamcommunity.com/id/doctorluk/
-- Version: 1.0
-- https://github.com/doctorluk/ULX-CSS-Checker

-- Global client vars
CS_CONTENT_CHECK_HAS_CSS_INSTALLED = true
CS_CONTENT_CHECK_FILE_MISSING = ""

-- Checks given filelist for existance
function checkFile( filelist )

	for _, filename in pairs(filelist) do
		local exists = file.Exists( filename, "GAME" )
		if exists then
			print("[CS:S CHECK] File " .. filename .. " exists!")
		else
			CS_CONTENT_CHECK_HAS_CSS_INSTALLED = false
			CS_CONTENT_CHECK_FILE_MISSING = filename
			print("[CS:S CHECK][ERROR] File " .. filename .. " MISSING!")
		end
	end
	
end

-- Hook that runs upon receival of the server's check
net.Receive( "cscontentcheck_check", function()

	local checktype = net.ReadString()
	local filelist = net.ReadTable()
	local result = false
	
	if checktype == "mount" then
		result = IsMounted( 'cstrike' )
	elseif checktype == "file" then
		checkFile(filelist)
		result = CS_CONTENT_CHECK_HAS_CSS_INSTALLED
	end
	
	net.Start( "cscontentcheck_response" )
	net.WriteString( checktype )
	net.WriteBool( result )
	net.WriteString( CS_CONTENT_CHECK_FILE_MISSING )
	net.SendToServer()
	
end)