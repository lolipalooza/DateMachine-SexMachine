local module = {}

--[[===============================================================
===================================================================]]
module.files = {}

module.files.orig_path = "modloader/.date&sex/sex" -- "models/files/sex"
module.files.dest_path = "modloader/date&sex/sex"
module.files.subfolders = {
	-- 				Sex					Blowjob				ReverseSex			Handjob					Cunnilingus				Oral 69				Titjob					Footjob
	--[[Bed]]		{"Sex Bed",			"Blowjob on Bed",	"Reverse on Bed",	"Handjob on Bed",		"",						"",					"Titjob on Bed 2",		""},
	--[[Sofa]]		{"Sex Sofa",		"Blowjob Sofa",		"Reverse on Sofa",	"Handjob Sit down",		"Cunnilingus Sofa",		"Oral69 Sofa",		"",						"Footjob on Sofa"},
	--[[Table]]		{"Sex Table",		"",					"Reverse Table",	"",						"",						"",					"",						""},
	--[[Sitdown]]	{"",				"Blowjob Sit down",	"",					"",						"",						"",					"",						""},
	--[[Floor]]		{"Sex on Floor",	"Blowjob on Knees",	"Reverse on Floor",	"",						"Cunnilingus Floor",	"",					"",						""},
	--[[Bath]]		{"",				"",					"Reverse on Knees",	"",						"",						"",					"",						""},
	--[[Kitchen]]	{"Sex Kitchen",		"Blowjob Kitchen",	"",					"",						"",						"",					"",						""},
	--[[Wall]]		{"Sex on Foot",		"",					"Reverse on Foot",	"",						"",						"",					"",						""},
	--[[Foot]]		{"",				"Blowjob on Foot",	"",					"Handjob on Foot",		"",						"",					"",						""},
}

--[[===============================================================
===================================================================]]
module.places = {
	-- Bed
	{
		"S_BJ_1",	"S_HJ_1",	"S_FK_1",	"S_AN_1",	"S_TJ_1",
		"",			"",			"",			"",			"",
		"",			"",			"",			"",			"",
		"",			"",			"",			"",			"",
		"",			"",			"",			"",			""
	},
	-- Sofa
	{
		"S_CN_1",	"S_BJ_1",	"S_69_1",	"",			"",
		"S_FK_1",	"S_AN_1",	"",			"",			"",
		"S_HJ_1",	"S_FJ_1",	"",			"",			"",
		"",			"",			"",			"",			"",
		"",			"",			"",			"",			""
	},
	-- Table
	{
		"S_FK_1",	"S_AN_1",	"",			"",			"",
		"",			"",			"",			"",			"",
		"",			"",			"",			"",			"",
		"",			"",			"",			"",			"",
		"",			"",			"",			"",			""
	},
	-- Chair
	{
		"S_BJ_1",	"",			"",			"",			"",
		"",			"",			"",			"",			"",
		"",			"",			"",			"",			"",
		"",			"",			"",			"",			"",
		"",			"",			"",			"",			""
	},
	-- Floor
	{
		"S_CN_1",	"S_BJ_1",	"",			"",			"",
		"S_FK_1",	"S_AN_1",	"",			"",			"",
		"",			"",			"",			"",			"",
		"",			"",			"",			"",			"",
		"",			"",			"",			"",			""
	},
	-- Bath
	{
		"S_AN_1",	"",			"",			"",			"",
		"",			"",			"",			"",			"",
		"",			"",			"",			"",			"",
		"",			"",			"",			"",			"",
		"",			"",			"",			"",			""
	},
	-- Kitchen
	{
		"S_BJ_1",	"S_FK_1",	"",			"",			"",
		"",			"",			"",			"",			"",
		"",			"",			"",			"",			"",
		"",			"",			"",			"",			"",
		"",			"",			"",			"",			""
	},
	-- Wall
	{
		"S_FK_1",	"S_AN_1",	"",			"",			"",
		"",			"",			"",			"",			"",
		"",			"",			"",			"",			"",
		"",			"",			"",			"",			"",
		"",			"",			"",			"",			""
	},
	-- OnFoot
	{
		"S_BJ_1",	"S_HJ_1",	"",			"",			"",
		"S_BL_1",	"",			"",			"",			"",
		"",			"",			"",			"",			"",
		"",			"",			"",			"",			"",
		"",			"",			"",			"",			""
	},
}

--[[===============================================================
===================================================================]]
module.animations = {
	-- SexCoitus
	{
		"idle 1 slow 1 normal 1 fast 1", --Bed
		"idle 1	slow 1	slow 1		fast 1", --Sofa
		"idle 1	slow 1	slow 1		fast 1", --Table
		"", --Sitdown
		"slow 1	slow 1	normal 1	fast 1", --Floor
		"", --Bath
		"idle 2	slow 1	slow 1		fast 1", --Kitchen
		"idle 1	slow 2	normal 2	fast 2", --Wall
		"", --Foot
	},
	-- Blowjob
	{
		"slow 1	slow 2	normal 3	normal 3", --Bed
		"slow 1	slow 3	normal 3	fast 1", --Sofa
		"", --Table
		"idle 1	slow 5	normal 4	fast 5", --Sitdown
		"slow 1	slow 3	normal 3	fast 3", --Floor
		"", --Bath
		"idle 1	slow 2	normal 3	fast 1", --Kitchen
		"", --Wall
		"idle 1	slow 5	normal 3	fast 2", --Foot
	},
	-- ReverseSex
	{
		"idle 1	slow 2	normal 2	fast 2", --Bed
		"slow 1	slow 3	normal 3	fast 3", --Sofa
		"idle 1	slow 1	slow 1		fast 1", --Table
		"", --Sitdown
		"slow 1	slow 1	normal 1	fast 1", --Floor
		"idle 1	slow 2	normal 2	fast 2", --Bath
		"", --Kitchen
		"slow 1	slow 3	normal 3	fast 3", --Wall
		"", --Foot
	},
	-- Handjob
	{
		"slow 1	slow 3	slow 3		fast 2", --Bed
		"slow 1	slow 1	slow 1		fast 1", --Sofa
		"", --Table
		"", --Sitdown
		"", --Floor
		"", --Bath
		"", --Kitchen
		"", --Wall
		"idle 1	slow 1	slow 1		fast 1", --Foot
	},
	-- Cunnilingus
	{
		"", --Bed
		"slow 1	slow 1	slow 1		slow 1", --Sofa
		"", --Table
		"", --Sitdown
		"idle 1	slow 2	normal 2	normal 2", --Floor
		"", --Bath
		"", --Kitchen
		"", --Wall
		"", --Foot
	},
	-- Oral69
	{
		"", --Bed
		"slow 1	slow 1	slow 1		fast 1", --Sofa
		"", --Table
		"", --Sitdown
		"", --Floor
		"", --Bath
		"", --Kitchen
		"", --Wall
		"", --Foot
	},
	-- Titjob
	{
		"slow 1	slow 1	normal 1	fast 1", --Bed
		"", --Sofa
		"", --Table
		"", --Sitdown
		"", --Floor
		"", --Bath
		"", --Kitchen
		"", --Wall
		"", --Foot
	},
	-- Footjob
	{
		"", --Bed
		"slow 1	slow 1	normal 1	fast 1", --Sofa
		"", --Table
		"", --Sitdown
		"", --Floor
		"", --Bath
		"", --Kitchen
		"", --Wall
		"", --Foot
	},
}

--[[===============================================================
===================================================================]]
module.poses_gxt = {
	"gxt S_FK_1 pose 1 bodytype 0",
	"gxt S_BJ_1 pose 2 bodytype 0",
	"gxt S_AN_1 pose 3 bodytype 0",
	"gxt S_HJ_1 pose 4 bodytype 0",
	"gxt S_CN_1 pose 5 bodytype 0",
	"gxt S_69_1 pose 6 bodytype 0",
	"gxt S_TJ_1 pose 7 bodytype 0",
	"gxt S_FJ_1 pose 8 bodytype 0",
	"gxt S_BL_1 pose 2 bodytype 1",
}

--[[===============================================================
===================================================================]]
module.places_gxt = {
	"gxt S_PL_1 place 1 bed",
	"gxt S_PL_2 place 2 sofa",
	"gxt S_PL_3 place 3 table",
	"gxt S_PL_4 place 4 chair",
	"gxt S_PL_5 place 5 floor",
	"gxt S_PL_6 place 6 bath",
	"gxt S_PL_7 place 7 kitchen",
	"gxt S_PL_8 place 8 wall",
	"gxt S_PL_9 place 9 onfoot",
}

--[[===============================================================
===================================================================]]
module.GetPoseFromGXT = function(gxt_entry)
	local i
	local poses_gxt = module.poses_gxt
	local pattern = "gxt%s+([%w_]+)%s+pose%s+(%d+)%s+bodytype%s+(%d+)"
	for i=1,#poses_gxt do
		local gxt_read, pose, bodytype = string.match(poses_gxt[i], pattern)
		if gxt_entry == gxt_read then
			return tonumber(pose), tonumber(bodytype)
		end
	end
	return nil, nil
end


--[[===============================================================
===================================================================]]
module.GetPlaceFromGXT = function(gxt_entry)
	local i
	local places_gxt = module.places_gxt
	local pattern = "gxt%s+([%w_]+)%s+place%s+(%d+)%s+%a+"
	for i=1,#places_gxt do
		local gxt_read, place = string.match(places_gxt[i], pattern)
		if gxt_entry == gxt_read then
			return tonumber(place)
		end
	end
	return nil
end

--[[===============================================================
===================================================================]]
module.getMenuPose = function (pose, place)
	local x,y=nil,nil
	for y=1,5 do
		for x=1,5 do
			local i = x + (y-1)*5
			local pose_gxt = module.places[place][i]
			local searching_pose, b = module.GetPoseFromGXT(pose_gxt)
			if searching_pose==pose then
				return i
			end
		end
	end
end

return module