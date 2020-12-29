script_name("SexMachine/DateMachine")
script_author("Mumifag Lalolanda")
script_version("1.0")
script_description("GTA SA mod to play an Ero Sim Date R18 +18 NSFW!!")
require "lib.moonloader"

local sex = require "lib.sex-machine.sex"
local mission = require "lib.sex-machine.mission"

function main()
	--printHelpString(string.format("Running %s~s~.", "~r~Sex~y~Machine~s~.~b~lua" ))
	
	while true do
	wait (0)
	
		if not mission.onMission() then
			if testCheat("ero") then
				sex.run(sex.poses.SEX_FUCKING, sex.places.PL_TABLE, 40, 'female', 'male')
			end
		end
		
		if testCheat("miss") then
			mission.setOnMission( mission.onMission() and 0 or 1 )
			printHelpString(string.format("$~y~ONMISSION~s~: %s", mission.onMission() and "~b~on" or "~r~off" ))
		end
		
		-- write "stats" to toggle the sex hud view
	end
end