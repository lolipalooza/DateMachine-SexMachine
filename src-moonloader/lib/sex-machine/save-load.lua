-- https://stackoverflow.com/questions/1426954/split-string-in-lua (split string by character or expression)
--interiors: ABATOIR,AMMUN1,CARMOD1,FDREST1,GF1,JETINT,LACS1,LAHS1B,MAFCAS,MAFCAS2,SMASHTV,SVVGHO1,SWEETS,TSDINER,WUZIBET,BARBERS,BDUPS1,CARMOD2,CARTER,GF2,LAHS1A,LASTRIP,RYDERS,SVVGHO2,VGHSB1,VGHSB3,BARBER2,BDUPS,BIKESCH,BROTHL1,CARLS,CARMOD3,CHANGER,CSSPRT,DRIVES,DRIVES2,GENOTB,GF3,LAHSB4,OGLOCS,PAPER,PDOMES,PDOMES2,POLICE3,SEXSHOP,S1TEST,STRIP2,STUDIO,TATTO3,AMMUN2,DINER1,DIRBIKE,GF4,LAHS2A,LAHSS6,SFHSM2,X711S2,CSDESGN,DINER2,FDPIZA,GANG,GF5,GYM1,LACRAK,LAHSB3,MADDOGS,MDDOGS,SFHSB1,SVHOT1,VGHSM2,AMMUN3,AMMUN5,BROTHEL,GF6,GYM2,LAHSB1,POLICE1,RCPLAY,REST2,SFHSB2,SFHSS2,SVCUNT,SVSFSM,X7_11S,8TRACK,AMMUN4,GYM3,LAHSB2,OFTEST,BURHOUS,SFHSS1,SVLAMD,FDCHICK,LAHS2B,SFHSB3,SVGNMT2,SVVGMD,DESHOUS,FDBURG,POLICE2,SVGNMT1,TRICAS,SVSFMD,VGHSM3,X711S3,BAR2,SVLASM,BARBER3,MOROOM,SVLABIG,CSEXL,AIRPOR2,AIRPORT,CSCHP,MOTEL1,SFHSM1,VGHSS1,VGSHM2,VGSHM3,VGSHS2,TATTOO,X7_11C,BAR1,DAMIN,FDDONUT,TATTO2,X7_11D,ATRIUME,ATRIUMX,CLOTHGP,GENWRHS,UFOBAR,X7_11B

local module = {}

local SAVE_FILE = "modloader/date&sex/savedata/SexMachine.sav"

--[[===============================================================
===================================================================]]
module.data = {}

--[[===============================================================
===================================================================]]
module.data.Initialize = function ()
	local i
	local d = module.data
	for i=1,12 do
		d[i] = {}
		d[i].interior = ''
		d[i].pose = 0
		d[i].place = 0
		d[i].center = {0,0,0}
		d[i].fem = {0,0,0,0}
		d[i].male = {0,0,0,0}
		d[i].in_use = false
		d[i].cam = {}
		d[i].cam.free = {0,0,0}
		d[i].cam.fpv = {0,0,0,0,0}
		d[i].cam.fixed = {}
		local j
		for j=1,12 do
			d[i].cam.fixed[j] = {0,0,0,0,0}
		end
	end
end

module.data.Initialize1 = function () -- alternative (should do the exact same as .Initialize() )
	local i = nil
	for i=1,12 do
		module.data.clear(i)
	end
end

--[[===============================================================
===================================================================]]
module.data.clear = function (slot)
	module.data[slot] = {
		interior = '', pose = 0, place = 0,
		center = {0,0,0}, fem = {0,0,0,0}, male = {0,0,0,0},
		in_use = false, cam = {
			free = {0,0,0}, fpv = {0,0,0,0,0}, fixed = {
				{0,0,0,0,0}, {0,0,0,0,0}, {0,0,0,0,0}, {0,0,0,0,0},
				{0,0,0,0,0}, {0,0,0,0,0}, {0,0,0,0,0}, {0,0,0,0,0},
				{0,0,0,0,0}, {0,0,0,0,0}, {0,0,0,0,0}, {0,0,0,0,0},
			}
		}
	}
end

--[[===============================================================
===================================================================]]
local ClearAllInUseFlagsFromIntStorage = function (d)
	local i = nil
	for i = 1, #d do
		d[i].in_use = false
	end
end

--[[===============================================================
===================================================================]]
local writeDataTableLineToFile = function ()
	local slot, data = nil, module.data
	for slot=1,#data do
		if not(data[slot].interior == "") then
			local d = data[slot]
			io.write( string.format("interior %s pose %d place %d center_xyz %.6f %.6f %.6f fem_xyza %.6f %.6f %.6f %.6f male_xyza %.6f %.6f %.6f %.6f slot %d in_use %d free_cam %.6f %.6f %.6f fpv_pos %.6f %.6f %.6f fpv_angle %.6f fpv_rotation %.6f ",
				d.interior, d.pose - 1, d.place - 1, d.center[1], d.center[2], d.center[3],
				d.fem[1], d.fem[2], d.fem[3], d.fem[4], d.male[1], d.male[2], d.male[3], d.male[4],
				slot, d.in_use and "1" or "0", d.cam.free[1], d.cam.free[2], d.cam.free[3],
				d.cam.fpv[1], d.cam.fpv[2], d.cam.fpv[3], d.cam.fpv[4], d.cam.fpv[5]) )
			
			local i = nil
			for i=1,12 do
				io.write( string.format("fixed_pos %.6f %.6f %.6f angle %.6f rot %.6f ",
					d.cam.fixed[i][1], d.cam.fixed[i][2], d.cam.fixed[i][3], d.cam.fixed[i][4], d.cam.fixed[i][5]) )
			end
			io.write("\n")
		end
	end
end

--[[===============================================================
===================================================================]]
module.data.Save = function (_pose, _place) -- SaveData
	local line, temp = nil, {}
	if doesFileExist(SAVE_FILE) then
		for line in io.lines (SAVE_FILE) do
			table.insert(temp, line)
		end
	end
	
	-- Reinitialize save file
	local file = io.open(SAVE_FILE, "w+")
	io.output(file)
	
	local interiorName = getNameOfEntryExitCharUsed(playerPed)
	local interiorId = getActiveInterior()
	if interiorName == "" then
		interiorName = (interiorId == 0) and "EXTERIOR" or "UNKNOWN"
	end
	
	local i = nil
	local already_saved_data_in_use = false
	for i=1,#temp do
		line = temp[i]
		local check_interior, check_pose, check_place = string.match(line, "interior%s+([%w_]+)%s+pose%s+(%d+)%s+place%s+(%d+)")
		if check_interior == interiorName and tonumber(check_pose) == _pose and tonumber(check_place) == _place then
			if not already_saved_data_in_use then
				already_saved_data_in_use = true
				writeDataTableLineToFile()
			end
		else
			io.write(line.."\n")
		end
	end
	
	if not already_saved_data_in_use then
		writeDataTableLineToFile()
	end
	
	io.close(file)
end

--[[===============================================================
===================================================================]]
module.data.Load = function (_pose, _place) -- LoadData
	module.data.Initialize1()
	if doesFileExist(SAVE_FILE) then
		local interiorName = getNameOfEntryExitCharUsed(playerPed)
		local interiorId = getActiveInterior()
		
		if interiorName == "" then
			interiorName = (interiorId == 0) and "EXTERIOR" or "UNKNOWN"
		end
		
		local line = nil
		for line in io.lines (SAVE_FILE) do
			local check_interior, check_pose, check_place = string.match(line, "interior%s+([%w_]+)%s+pose%s+(%d+)%s+place%s+(%d+)")
			if check_interior == interiorName and tonumber(check_pose+1) == _pose and tonumber(check_place+1) == _place then
				local c = function(s) return string.format("(%s)", s) end
				
				local optional_space = "%s*"
				local spc, gxt, uint, flt, int = "%s+", "[%w_]+", "%d+", "[-%d.]+", "[-%d]+"
				local flt_3 = spc..flt..spc..flt..spc..flt..spc
				local c_flt_3 = spc..c(flt)..spc..c(flt)..spc..c(flt)..spc
				local c_flt_4 = spc..c(flt)..spc..c(flt)..spc..c(flt)..spc..c(flt)..spc
				
				local pattern = "interior"..spc..c(gxt)..spc
				pattern = pattern.."pose"..spc..c(uint)..spc.."place"..spc..c(uint)..spc
				pattern = pattern.."center_xyz"..c_flt_3.."fem_xyza"..c_flt_4.."male_xyza"..c_flt_4.."slot"..spc..c(uint)..spc.."in_use"..spc..c(uint)..spc
				pattern = pattern.."free_cam"..c_flt_3.."fpv_pos"..c_flt_3.."fpv_angle"..spc..c(flt)..spc.."fpv_rotation"..spc..c(flt)..spc

				local interior_gxt, pose, place, centerX, centerY, centerZ,
					femX, femY, femZ, femA, maleX, maleY, maleZ, maleA, slot, in_use,
					freeX, freeY, freeZ, fpvX, fpvY, fpvZ, fpvA, fpvR = string.match(line, pattern)
					
				local fixed = spc.."fixed_pos"..flt_3.."angle"..spc..flt..spc.."rot"..spc..flt
				local c_fixed = spc.."fixed_pos"..c_flt_3.."angle"..spc..c(flt)..spc.."rot"..spc..c(flt)
				
				local fx1x, fx1y, fx1z, fx1a, fx1r = string.match(line, c_fixed..fixed..fixed..fixed..fixed..fixed..fixed..fixed..fixed..fixed..fixed..fixed..optional_space)
				local fx2x, fx2y, fx2z, fx2a, fx2r = string.match(line, fixed..c_fixed..fixed..fixed..fixed..fixed..fixed..fixed..fixed..fixed..fixed..fixed..optional_space)
				local fx3x, fx3y, fx3z, fx3a, fx3r = string.match(line, fixed..fixed..c_fixed..fixed..fixed..fixed..fixed..fixed..fixed..fixed..fixed..fixed..optional_space)
				local fx4x, fx4y, fx4z, fx4a, fx4r = string.match(line, fixed..fixed..fixed..c_fixed..fixed..fixed..fixed..fixed..fixed..fixed..fixed..fixed..optional_space)
				local fx5x, fx5y, fx5z, fx5a, fx5r = string.match(line, fixed..fixed..fixed..fixed..c_fixed..fixed..fixed..fixed..fixed..fixed..fixed..fixed..optional_space)
				local fx6x, fx6y, fx6z, fx6a, fx6r = string.match(line, fixed..fixed..fixed..fixed..fixed..c_fixed..fixed..fixed..fixed..fixed..fixed..fixed..optional_space)
				local fx7x, fx7y, fx7z, fx7a, fx7r = string.match(line, fixed..fixed..fixed..fixed..fixed..fixed..c_fixed..fixed..fixed..fixed..fixed..fixed..optional_space)
				local fx8x, fx8y, fx8z, fx8a, fx8r = string.match(line, fixed..fixed..fixed..fixed..fixed..fixed..fixed..c_fixed..fixed..fixed..fixed..fixed..optional_space)
				local fx9x, fx9y, fx9z, fx9a, fx9r = string.match(line, fixed..fixed..fixed..fixed..fixed..fixed..fixed..fixed..c_fixed..fixed..fixed..fixed..optional_space)
				local fxAx, fxAy, fxAz, fxAa, fxAr = string.match(line, fixed..fixed..fixed..fixed..fixed..fixed..fixed..fixed..fixed..c_fixed..fixed..fixed..optional_space)
				local fxBx, fxBy, fxBz, fxBa, fxBr = string.match(line, fixed..fixed..fixed..fixed..fixed..fixed..fixed..fixed..fixed..fixed..c_fixed..fixed..optional_space)
				local fxCx, fxCy, fxCz, fxCa, fxCr = string.match(line, fixed..fixed..fixed..fixed..fixed..fixed..fixed..fixed..fixed..fixed..fixed..c_fixed..optional_space)
				
				local d = module.data
				slot = tonumber(slot)
				d[slot].interior = interior_gxt
				d[slot].pose = pose + 1
				d[slot].place = place + 1
				d[slot].center = {tonumber(centerX),tonumber(centerY),tonumber(centerZ)}
				d[slot].fem = {tonumber(femX), tonumber(femY), tonumber(femZ), tonumber(femA)}
				d[slot].male = {tonumber(maleX), tonumber(maleY), tonumber(maleZ), tonumber(maleA)}
				d[slot].in_use = (in_use=="0") and false or true
				d[slot].cam.free = {tonumber(freeX), tonumber(freeY), tonumber(freeZ)}
				d[slot].cam.fpv = {tonumber(fpvX), tonumber(fpvY), tonumber(fpvZ), tonumber(fpvA), tonumber(fpvR)}
				d[slot].cam.fixed = {
					{fx1x+0, fx1y+0, fx1z+0, fx1a+0, fx1r+0}, {fx2x+0, fx2y+0, fx2z+0, fx2a+0, fx2r+0}, {fx3x+0, fx3y+0, fx3z+0, fx3a+0, fx3r+0},
					{fx4x+0, fx4y+0, fx4z+0, fx4a+0, fx4r+0}, {fx5x+0, fx5y+0, fx5z+0, fx5a+0, fx5r+0}, {fx6x+0, fx6y+0, fx6z+0, fx6a+0, fx6r+0},
					{fx7x+0, fx7y+0, fx7z+0, fx7a+0, fx7r+0}, {fx8x+0, fx8y+0, fx8z+0, fx8a+0, fx8r+0}, {fx9x+0, fx9y+0, fx9z+0, fx9a+0, fx9r+0},
					{fxAx+0, fxAy+0, fxAz+0, fxAa+0, fxAr+0}, {fxBx+0, fxBy+0, fxBz+0, fxBa+0, fxBr+0}, {fxCx+0, fxCy+0, fxCz+0, fxCa+0, fxCr+0},
				}
			end
		end
	end
end

--[[===============================================================
===================================================================]]
module.data.storeInfo = function (slot, pose, place) -- StoreInformationInInternalStorage
	local interiorName = getNameOfEntryExitCharUsed(playerPed)
	local interiorId = getActiveInterior()
	if interiorName == "" then
		interiorName = (interiorId == 0) and "EXTERIOR" or ""
	end
	
	if not(interiorName == "") then
		local coords = require("lib.sex-machine.cameras-coordinates").coordinates
		local cam = require("lib.sex-machine.cameras-coordinates").camera
		
		local plyX, plyY, plyZ = coords.getPlayerPos()
		local offsX, offsY, offsZ = coords.getPlayerOffsets()
		local femX, femY, femZ, femA = coords.getFemOffsets()
		local maleX, maleY, maleZ, maleA = coords.getMaleOffsets()
		ClearAllInUseFlagsFromIntStorage(module.data)
		
		local fpvX, fpvY, fpvZ, fpvA, fpvRot, fpvTx = cam.fpv.get()
		
		local data = module.data[slot]
		data.interior = interiorName
		data.pose = pose
		data.place = place
		data.center = {plyX, plyY, plyZ}
		data.fem = {femX, femY, femZ, femA}
		data.male = {maleX, maleY, maleZ, maleA}
		data.in_use = true
		data.cam = {}
		data.cam.free = {offsX, offsY, offsZ}
		data.cam.fpv = {fpvX, fpvY, fpvZ, fpvA, fpvRot}
		
		data.cam.fixed = {}
		local i = nil
		for i = 1, 12 do
			local x, y, z, a, rot, tx = cam.fixed.get(i-1)
			data.cam.fixed[i] = {x, y, z, a, rot}
		end
	end
end

--[[===============================================================
===================================================================]]
module.data.retrieveInfo = function (slot, female, male, pose, place, speed) -- RetrieveInformationFromInternalStorage
	if not(module.data[slot].interior == "") then
		local data = module.data[slot]
		local coords = require("lib.sex-machine.cameras-coordinates").coordinates
		local cam = require("lib.sex-machine.cameras-coordinates").camera
		local actors = require("lib.sex-machine.actors-poses")
		
		coords.setPlayerPos(data.center[1], data.center[2], data.center[3])
		coords.setFemOffsets(data.fem[1], data.fem[2], data.fem[3], data.fem[4])
		coords.setMaleOffsets(data.male[1], data.male[2], data.male[3], data.male[4])
		
		actors.RelocateActor_Alt(female, data.center[1], data.center[2], data.center[3], data.fem[1], data.fem[2], data.fem[3], data.fem[4])
		actors.RelocateActor_Alt(male, data.center[1], data.center[2], data.center[3], data.male[1], data.male[2], data.male[3], data.male[4])
		actors.LoadSexualPose(female, male, pose, place, speed)
		
		ClearAllInUseFlagsFromIntStorage(module.data)
		data.in_use = true
		
		coords.setPlayerOffsets(data.cam.free[1], data.cam.free[2], data.cam.free[3]) -- TODO: check if this is enough
		cam.fpv.store(data.cam.fpv[1], data.cam.fpv[2], data.cam.fpv[3], data.cam.fpv[4], data.cam.fpv[5], 0)
		
		local i = nil
		for i = 1, 12 do
			cam.fixed.store(i-1, data.cam.fixed[i][1], data.cam.fixed[i][2], data.cam.fixed[i][3], data.cam.fixed[i][4], data.cam.fixed[i][5], 0)
		end
	end
end

--[[===============================================================
===================================================================]]
return module