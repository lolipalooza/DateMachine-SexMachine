local module = {}

function module.setOnMission(flag)
	writeMemory(0x00A49FC4, 4, flag, false)
end

function module.onMission()
	return readMemory(0x00A49FC4, 4, false) == 1
end

return module