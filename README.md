# ULX-CS:S-Checker
## What it is for
If your server has content installed that requires CS:S to be installed, you can automatically kick people who don't have CS:S.

## What it does
1. Check whether a player has mounted CS:S (bought and installed via Steam). If they don't, proceed to 2.
2. The server randomly sends 15 (by default) file names (from all files that exist in a CS:S installation) to be checked. If any of the files do not exist, the client is kicked

## How to install
1. Upload the folder cs_resource_check into your addons folder (usually located at garrysmod\addons)

## How to configure
All configuration options can be found at cs_resource_check\lua\autorun\server\sv_cs_config.lua and every line is documented.