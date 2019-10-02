local module = {}

module.genders = {FEM = 0, MALE = 1}

--[[===============================================================
===================================================================]]
module.ChangeSkin = function(gxt_entry, slot)
	loadSpecialCharacter(gxt_entry, slot)
	loadAllModelsNow()
	repeat
	wait (0)
	until hasModelLoaded(slot+289)
	setPlayerModel(playerchar, slot+289)
	unloadSpecialCharacter(slot)
end

--[[===============================================================
===================================================================]]
module.ChangeGenderSkin = function(female_gxt, male_gxt, gender_flag)
	gender_flag = gender_flag or 0 -- female by default
	module.ChangeSkin((gender_flag==0) and female_gxt or male_gxt, gender_flag+1)
end

--[[===============================================================
===================================================================]]
module.PlayerDissapear = function()
	module.ChangeSkin('VOID', 10)
end

--[[===============================================================
===================================================================]]
module.GenerateActors = function (pose, place, female_gxt, male_gxt) -- i suspect this function has been abandoned
	local model = require "lib.game.models"
	local pedtype = { CIVFEMALE = 5, CIVMALE = 4 }
	
	--GetActorsCoordinates()
	local femX, femY, femZ, femA, maleX, maleY, maleZ, maleA = 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0
	
	--AddOffsetTo3DCoord
	femX, femY, femZ, femA, maleX, maleY, maleZ, maleA = femX+0.0, femY+0.0, femZ+0.0, femA+0.0, maleX+0.0, maleY+0.0, maleZ+0.0, maleA+0.0
	
	loadSpecialCharacter(female_gxt, 1)
	loadSpecialCharacter(male_gxt, 2)
	loadAllModelsNow()
	repeat
	wait (0)
	until hasSpecialCharacterLoaded(1) and hasSpecialCharacterLoaded(2)
	
	female = createChar(pedtype.CIVFEMALE, model.SPECIAL01, femX, femY, femZ)
	setCharHeading(female, femA)
	setCharCollision(female, false)
	
	male = createChar(pedtype.CIVMALE, model.SPECIAL02, maleX, maleY, maleZ)
	setCharHeading(male, maleA)
	setCharCollision(male, false)
	
	unloadSpecialCharacter(1)
	unloadSpecialCharacter(2)
	
	return female, male
end

--[[===============================================================
RelocateActor(Ped actor, float offsX, float offsY, float offsZ, float offsA, int gender, int pose, int place)
===================================================================]]
module.RelocateActor = function (actor, offsX, offsY, offsZ, offsA, gender, pose, place) -- TODO: pose and place looks completely unnecessary
	local pos = {{},{}}
	pos[1].x, pos[1].y, pos[1].z, pos[1].a, pos[2].x, pos[2].y, pos[2].z, pos[2].a = 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0 --GetActorsCoordinates()
	pos[gender].x, pos[gender].y, pos[gender].z, pos[gender].a = pos[gender].x+offsX, pos[gender].y+offsY, pos[gender].z+offsZ, pos[gender].a+offsA
	setCharCoordinates(actor, pos[gender].x, pos[gender].y, pos[gender].z)
	setCharHeading(actor, pos[gender].a)
end

--[[===============================================================
RelocateActor_Alt(Ped actor, plyX, plyY, plyZ, offsX, offsY, offsZ, offsA)
===================================================================]]
module.RelocateActor_Alt = function (actor, plyX, plyY, plyZ, offsX, offsY, offsZ, offsA) -- TODO: gender, pose and place looks completely unnecessary
	local x, y, z, a = plyX+offsX, plyY+offsY, plyZ+offsZ, 0+offsA
	setCharCoordinates(actor, x, y, z)
	setCharHeading(actor, a)
end

module.CurrentAnimation = 0

--[[===============================================================
LoadSexualPose(Ped female, Ped male, int pose, int place, int speed_stat, int current_anim)
===================================================================]]
module.LoadSexualPose = function (female, male, pose, place, speed_stat, current_anim)
	local anim_fem, anim_male, ifp_file
	module.CurrentAnimation = current_anim or module.CurrentAnimation
	module.CurrentAnimation, anim_fem, anim_male, ifp_file = module.ReadSexPosesInfo(speed_stat, pose, place, module.CurrentAnimation)

	requestAnimation(ifp_file)
	repeat
	wait (0)
	until hasAnimationLoaded(ifp_file)
	
	taskPlayAnim(female, anim_fem, ifp_file, 4.0, true, false, false, false, -1)
	taskPlayAnim(male, anim_male, ifp_file, 4.0, true, false, false, false, -1)
	removeAnimation(ifp_file)
end

--[[===============================================================
int current_anim, string anim_fem, string anim_male, string ifp_file = ReadSexPosesInfo(int speed, int pose, int place, int current_anim)
===================================================================]]
module.ReadSexPosesInfo = function (speed, pose, place, current_anim)
	local speed_gxt, max_number_of_animarions = module.ReadSexPosesInfo_short(speed, pose, place)

	if current_anim > max_number_of_animarions then
		current_anim = max_number_of_animarions
	elseif current_anim < 1 then
		current_anim = 1
	end
	
	-- TODO: make sure 'speed_gxt' always has the values: 'idle', 'slow', 'normal', 'fast'
	local anim_fem = string.format("%s%d_f", speed_gxt, current_anim)
	local anim_male = string.format("%s%d_m", speed_gxt, current_anim)
	local ifp_file = string.format("%s%d", speed_gxt, current_anim)
	
	return current_anim, anim_fem, anim_male, ifp_file
end

--[[===============================================================
===================================================================]]
module.ReadSexPosesInfo_short = function (speed, pose, place)
	local str = require "lib.sex-machine.data".animations[pose][place]
	local pattern = "(%a+)%s+(%d+)%s+(%a+)%s+(%d+)%s+(%a+)%s+(%d+)%s+(%a+)%s+(%d+)"
	local arr = {{},{},{},{}}
	arr[1].s,arr[1].n, arr[2].s,arr[2].n,
	arr[3].s,arr[3].n, arr[4].s,arr[4].n = string.match(str, pattern)
	return arr[speed+1].s, tonumber(arr[speed+1].n)
end

--[[===============================================================
Ped ped = CreateActor(GxtString skin_gxt, int slot, float offsX, float offsY, float offsZ, int gender_flag, bool visibility)
===================================================================]]
module.CreateActor = function (skin_gxt, slot, offsX, offsY, offsZ, gender_flag, visibility)
	local model = require "lib.game.models"
	local pedtypes = { CIVFEMALE = 5, CIVMALE = 4 }
	local pedtype = {pedtypes.CIVMALE,pedtypes.CIVFEMALE}
	
	loadSpecialCharacter(skin_gxt, slot)
	loadAllModelsNow()
	repeat
	wait (0)
	until hasSpecialCharacterLoaded(slot)
	
	local x, y, z = getCharCoordinates(playerPed)
	ped = createChar(pedtype[gender_flag], slot+289, x+offsX, y+offsY, z+offsZ)
	setCharHeading(ped, 0.0)
	setCharCollision(ped, false)
	setCharVisible (ped, visibility)
	unloadSpecialCharacter(slot)
	return ped
end

--[[===============================================================
===================================================================]]
module.GenerateActors_Alt = function (female_gxt, male_gxt, plyX, plyY, plyZ, femOffsX, femOffsY, femOffsZ, femOffsA, maleOffsX, maleOffsY, maleOffsZ, maleOffsA)
	local model = require "lib.game.models"
	local pedtype = { CIVFEMALE = 5, CIVMALE = 4 }
	local femX, femY, femZ, femA = plyX+femOffsX, plyY+femOffsY, plyZ+femOffsZ, femOffsA
	local maleX, maleY, maleZ, maleA = plyX+maleOffsX, plyY+maleOffsY, plyZ+maleOffsZ, maleOffsA
	
	loadSpecialCharacter(female_gxt, 1)
	loadSpecialCharacter(male_gxt, 2)
	loadAllModelsNow()
	
	repeat
	wait (0)
	until hasSpecialCharacterLoaded(1) and hasSpecialCharacterLoaded(2)
	
	female = createChar(pedtype.CIVFEMALE, model.SPECIAL01, femX, femY, femZ)
	setCharHeading(female, femA)
	setCharCollision(female, false)
	setCharVisible (female, false)
	
	male = createChar(pedtype.CIVMALE, model.SPECIAL02, maleX, maleY, maleZ)
	setCharHeading(male, maleA)
	setCharCollision(male, false)
	setCharVisible (male, false)
	
	return female, male
end

--[[===============================================================
===================================================================]]
module.ChangePoseAndPlace = function (female_gxt, male_gxt, female, male, pose, place, speed_stat, slot, wait_time)
	local coords = require("lib.sex-machine.cameras-coordinates").coordinates
	local cam = require("lib.sex-machine.cameras-coordinates").camera
	local data = require("lib.sex-machine.save-load").data
	local timer = require("lib.sex-machine.machines").Timer
	
	data.Load(pose, place)
	local x, y, z = getCharCoordinates(playerPed)
	local a = getCharHeading(playerPed)
	z = z - 1.0
	coords.setPlayerPos(x, y, z, a)
	
	repeat -- Give time to GenerateSexFiles to work
	wait (0)
	until timer.get() >= wait_time
	
	local plyX, plyY, plyZ = coords.getPlayerPos()
	local femOffsX, femOffsY, femOffsZ, femOffsA = coords.getFemOffsets()
	local maleOffsX, maleOffsY, maleOffsZ, maleOffsA = coords.getMaleOffsets()
	female, male = module.GenerateActors_Alt(female_gxt, male_gxt, plyX, plyY, plyZ, femOffsX, femOffsY, femOffsZ, femOffsA, maleOffsX, maleOffsY, maleOffsZ, maleOffsA)
	module.LoadSexualPose(female, male, pose, place, speed_stat)
	setCharCollision(playerPed, false)
	
	if not(slot==0) then -- A slot was selected
		data.retrieveInfo(slot, female, male, pose, place, speed_stat)
		printHelpString("Loaded!")
	end
	
	local offsX, offsY, offsZ = coords.getPlayerOffsets()
	cam.relocateFreeCamCenter(plyX, plyY, plyZ, offsX, offsY, offsZ)
	setPlayerControl(playerchar, true)
	
	cam.mode = cam.modes.FIXED_CAM
	cam.id = 0
	wait (100)
	cam.ToggleSexualCamera_Alt(pose, place)
	setCharVisible(female, true)
	setCharVisible(male, true)
	module.PlayerDissapear()
	
	return female, male
end

--[[===============================================================
===================================================================]]
module.RemovePosesAndActors = function (female, male)
	local cursor = require("lib.sex-machine.cursor-control")
	local coord = require("lib.sex-machine.cameras-coordinates").coordinates
	
	cursor.waitUntilReleaseClickButton()
	deleteChar(female)
	deleteChar(male)
	setCharCollision(playerPed, true)
	
	local x, y, z, a = coord.getPlayerPos()
	setCharCoordinates(playerPed, x, y, z)
	setCharHeading(playerPed, a)
	setCameraBehindPlayer()
	restoreCameraJumpcut()
	
	setPlayerControl(playerchar, true)
end

return module