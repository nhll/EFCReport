--
-- EFCReport by Cubenicke aka Yrrol@vanillagaming
-- Thx for the good looking graphics lanevegame!
--
EFCReport = CreateFrame('Frame', "EFCReport", UIParent)
EFCReport.enabled = false
EFCReport.created = false
EFCReport:RegisterEvent("ADDON_LOADED")
EFCReport:RegisterEvent("PLAYER_ENTERING_WORLD")
EFCReport:RegisterEvent("ZONE_CHANGED_NEW_AREA")
SLASH_EFCReport1 = '/efcr'
SLASH_EFCReport2 = '/EFCR'

if not EFCRSaves then
	EFCRSaves = { scale = 0, x = 0, y = 0, dim = false }
end

function EFCReport:GetButtons()
	local faction = UnitFactionGroup("player") == "Horde" and "H" or "A"

	local fcPrefix = "Going >>> "
	local efcPrefix = "EFC @ "
	local ourPrefix = ""
	local enemyPrefix = "E"
	local locs = {
		["gy"] = "GY",
		["fr"] = "FR",
		["balc"] = "BALC",
		["ramp"] = "RAMP",
		["leaf"] = "LEAF",
		["fence"] = "FENCE/TOT",
		["tun"] = "TUN",
		["zerk"] = "ZERK",
		["roof"] = "ROOF",
	}

	local buttons = {
		{ x = {2,2}, y = {-2,-2}, w = 32, h = 32, tex = "repic28", text = "=== REPICK ===" },
		{ faction = "A", loc = locs.roof, x = {34,34}, y = faction == "H" and {-2,-194} or {-194,-2}, w = 64, h = 32, tex = "aroof.blp" },
		{ x = {98,98}, y = {-2,-2}, w = 32, h = 32, tex = "cap28", text = "=== CAP ===" },

		{ faction = "A", loc = locs.gy, x = faction == "H" and {2,98} or {98,2}, y = faction == "H" and {-34,-162} or {-162,-34}, w = 32, h = 32, tex = "agy.blp" },
		{ faction = "A", loc = locs.fr, x = faction == "H" and {34,66} or {66,34}, y = faction == "H" and {-34,-162} or {-162,-34}, w  =32, h = 32, tex = "afr.blp" },
		{ faction = "A", loc = locs.balc, x = faction == "H" and {66,34} or {34,66}, y = faction == "H" and {-34,-162} or {-162,-34}, w = 32, h = 32, tex = "abalc.blp" },
		{ faction = "A", loc = locs.ramp, x = faction == "H" and {98,2} or {2,98}, y = faction == "H" and {-34,-162} or {-162,-34}, w = 32, h = 32, tex = "aramp.blp" },
		{ faction = "A", loc = locs.leaf, x = faction == "H" and {2,98} or {98,2}, y = faction == "H" and {-66,-130} or {-130,-66}, w = 32, h = 32, tex = "aresto.blp" },
		{ faction = "A", loc = locs.fence, x = faction == "H" and {34,66} or {66,34}, y = faction == "H" and {-66,-130} or {-130,-66}, w = 32, h = 32, tex = "afence.blp" },
		{ faction = "A", loc = locs.tun, x = faction == "H" and {66,34} or {34,66}, y = faction == "H" and {-66,-130} or {-130,-66}, w = 32, h = 32, tex = "atun.blp" },
		{ faction = "A", loc = locs.zerk, x = faction == "H" and {98,2} or {2,98}, y = faction == "H" and {-66,-130} or {-130,-66}, w = 32, h = 32, tex = "azerk.blp" },

		{ loc = "WEST", x = faction == "H" and {18,18} or {82,82}, y={-98,-98}, w=32, h=32, tex = faction == "H" and "west.blp" or "east.blp"},
		{ loc = "MID", x = {50,50}, y={-98,-98}, w=32, h=32, tex = "mid.blp", text = "MID"},
		{ loc = "EAST", x = faction == "H" and {82,82} or {18,18}, y={-98,-98}, w=32, h=32, tex = faction == "H" and "east.blp" or "west.blp"},

		{ faction = "H", loc = locs.zerk, x= faction == "H" and {2,98} or {98,2}, y= faction == "H" and {-130,-66} or {-66,-130}, w=32, h=32, tex = "hzerk.blp"},
		{ faction = "H", loc = locs.tun, x= faction == "H" and {34,66} or {66,34}, y= faction == "H" and {-130,-66} or {-66,-130}, w=32, h=32, tex = "htun.blp"},
		{ faction = "H", loc = locs.fence, x= faction == "H" and {66,34} or {34,66}, y= faction == "H" and {-130,-66} or {-66,-130}, w=32, h=32, tex = "hfence.blp"},
		{ faction = "H", loc = locs.leaf, x= faction == "H" and {98,2} or {2,98}, y= faction == "H" and {-130,-66} or {-66,-130}, w=32, h=32, tex = "hresto.blp"},
		{ faction = "H", loc = locs.ramp, x= faction == "H" and {2,98} or {98,2}, y= faction == "H" and {-162,-34} or {-34,-162}, w=32, h=32, tex = "hramp.blp"},
		{ faction = "H", loc = locs.balc, x= faction == "H" and {34,66} or {66,34}, y= faction == "H" and {-162,-34} or {-34,-162}, w=32, h=32, tex = "hbalc.blp"},
		{ faction = "H", loc = locs.fr, x= faction == "H" and {66,34} or {34,66}, y= faction == "H" and {-162,-34} or {-34,-162}, w=32, h=32, tex = "hfr.blp"},
		{ faction = "H", loc = locs.gy, x= faction == "H" and {98,2} or {2,98}, y= faction == "H" and {-162,-34} or {-34,-162}, w=32, h=32, tex = "hgy.blp"},
		{ faction = "H", loc = locs.roof, x={34,34}, y= faction == "H" and {-194,-2} or {-2, -194}, w=64, h=32, tex = "hroof.blp"},
	}

	for i,btn in pairs(buttons) do
		if btn.loc ~= nil then
			local loc = btn.loc

			if btn.faction ~= nil then
				loc = (btn.faction == faction and ourPrefix or enemyPrefix) .. btn.loc
			end

			btn.fcText = fcPrefix .. " " .. loc
			btn.efcText = efcPrefix .. " " .. loc
		end
	end

	return buttons;
end

local iconPath = "Interface\\Addons\\EFCReport\\Icons\\"

function Print(arg1)
	DEFAULT_CHAT_FRAME:AddMessage("|cffCC121D EFCR|r "..(arg1 or ""))
end

-- Show the dialog when entering WSG
function EFCReport:OnEvent()
	if event == "ADDON_LOADED" and arg1 == "EFCReport" then
		Print("Loaded")
	elseif event == 'PLAYER_ENTERING_WORLD' or event == 'ZONE_CHANGED_NEW_AREA' then
		if GetRealZoneText() == "Warsong Gulch" then
			EFCReport.create()
			EFCReport.EFCFrame:Show()
			EFCReport.enabled = true
		elseif EFCReport.enabled then
			EFCReport.enabled = false
			EFCReport.EFCFrame:Hide()
		end
	end
end
EFCReport:SetScript("OnEvent", EFCReport.OnEvent)

-- Hanlde slash commands
-- /efcr
-- /efcr scale <0 - 1>
-- /efcr xy <x> <Y>
-- /efcr x <x>
-- /efcr y <y>
SlashCmdList['EFCReport'] = function (msg)
	local _, _, cmd, args = string.find(msg or "", "([%w%p]+)%s*(.*)$")
	if cmd == "" or cmd == nil then
		if EFCReport.enabled then
			EFCReport.enabled = false
			EFCReport.EFCFrame:Hide()
		else
			EFCReport.create()
			EFCReport.EFCFrame:Show()
			EFCReport.enabled = true
		end
	elseif cmd == "scale" then
		EFCRSaves.scale = tonumber(args)
		Print("Setting Scale "..args)
		if EFCReport.EFCFrame then
			EFCReport.EFCFrame:SetScale(EFCRSaves.scale)
		end
	elseif cmd == "xy" or cmd == "pos" then
		local x, y = string.find(args,"(.*)%s*(.*)")
		EFCRSaves.x = x or 0
		EFCRSaves.y = y or 0
		EFCReport.EFCFrame:SetPoint("TOPLEFT", nil, "TOPLEFT", EFCRSaves.x, -EFCRSaves.y)
	elseif cmd == "x" then
		EFCRSaves.x = tonumber(args) or 0
		EFCReport.EFCFrame:SetPoint("TOPLEFT", nil, "TOPLEFT", EFCRSaves.x, -EFCRSaves.y)
	elseif cmd == "y" then
		EFCRSaves.y = tonumber(args) or 0
		EFCReport.EFCFrame:SetPoint("TOPLEFT", nil, "TOPLEFT", EFCRSaves.x, -EFCRSaves.y)
	elseif cmd == "dim" then
		if EFCRSaves.dim then
			EFCReport.EFCFrame:SetAlpha(1)
			EFCRSaves.dim = false
		else
			EFCReport.EFCFrame:SetAlpha(0.4)
			EFCRSaves.dim = true
		end
	else
		Print("Unknown command "..cmd)
	end
end

function EFCReport_OnEnter()
	if EFCRSaves.dim then
		EFCReport.EFCFrame:SetAlpha(1)
	end
end

function EFCReport_OnLeave()
	if EFCRSaves.dim then
		EFCReport.EFCFrame:SetAlpha(0.4)
	end
end

-- Create the EFCReport dialog
function EFCReport:create()
	if (EFCReport.EFCFrame ~= nil) then
		EFCReport.EFCFrame:Hide()
		EFCReport.enabled = false
    end

	-- Option Frame
	local frame = CreateFrame("Frame", "EFCRFrame")
	local ix = 1

	EFCReport.EFCFrame = frame

	tinsert(UISpecialFrames,"EFCReport")

	EFCReport.Language = 'Common'
	local numSkills = GetNumSkillLines();
	for i = 1, numSkills do
		local skill = GetSkillLineInfo(i);
		if string.find(skill, 'Orcish') then
			EFCReport.Language = 'Orcish'
		end
	end

	-- Set scale, size and position
	frame:SetWidth(132)
	frame:SetHeight(228)
	if EFCRSaves.scale > 0 then
		frame:SetScale(EFCRSaves.scale)
	end
	if not (EFCRSaves.x > 0 and EFCRSaves.y > 0) then
		EFCRSaves.x = 400
		EFCRSaves.y = 50
	end

	-- Background on entire frame
	frame:SetPoint("TOPLEFT", nil, "TOPLEFT", EFCRSaves.x, -EFCRSaves.y)
	frame:SetBackdrop( {
	  bgFile = "Interface\\DialogFrame\\UI-DialogBox-Background",
	  edgeFile = "Interface\\Tooltips\\UI-Tooltip-Background",
	  tile = true,
	  tileSize = 32,
	  edgeSize = 2,
	  insets = { left = 2, right = 2, top = 2, bottom = 2 }
	} );
	frame:SetBackdropColor(0, 0, 0, .91)
	frame:SetBackdropBorderColor(0.3, 0.3, 0.3, 1)

	-- Make it moveable
	frame:SetMovable(true)
	frame:EnableMouse(true)
	frame:SetClampedToScreen(false)
	if EFCRSaves.dim then
		frame:SetAlpha(0.4)
	end
	frame:Hide()

	-- Handle drag of window
	frame:SetScript("OnMouseDown", function()
		if arg1 == "LeftButton" and not this.isMoving then
			this:StartMoving();
			this.isMoving = true;
		end
	end)
	frame:SetScript("OnMouseUp", function()
		if arg1 == "LeftButton" and this.isMoving then
			local _,_,_,x,y = this:GetPoint()
			EFCRSaves.x = x
			EFCRSaves.y = -y
			this:StopMovingOrSizing();
			this.isMoving = false;
		end
	end)
	frame:SetScript("OnHide", function()
		if this.isMoving then
			this:StopMovingOrSizing();
			this.isMoving = false;
		end
	end)
	frame:SetScript("OnEnter", EFCReport_OnEnter)
	frame:SetScript("OnLeave", EFCReport_OnLeave)

	-- Create the buttons
	local buttons = EFCReport:GetButtons()
	for i,btn in pairs(buttons) do
		local btn_frame = CreateFrame("Button", btn.text, frame)
		btn_frame:SetPoint("TOPLEFT", frame, "TOPLEFT", btn.x[ix], btn.y[ix])
		btn_frame.id = i
		btn_frame:SetWidth(btn.w)
		btn_frame:SetHeight(btn.h)

		-- Left click: EFC report
		btn_frame:RegisterForClicks("LeftButtonUp", "RightButtonUp")
		btn_frame:SetScript("OnClick", function()
			local b = buttons[this.id]
			local text = (arg1 == "LeftButton" and b.efcText or b.fcText) or b.text

			faction = UnitFactionGroup

			if (IsRaidLeader() or IsRaidOfficer()) then
				SendChatMessage(text,"RAID_WARNING" , EFCReport.Language)
			else
				SendChatMessage(text,"BATTLEGROUND" , EFCReport.Language)
			end
		end)

		btn_frame:SetBackdrop( {
			bgFile = iconPath..btn.tex,
		} );
		btn_frame:SetScript("OnEnter", EFCReport_OnEnter)
		btn_frame:SetScript("OnLeave", EFCReport_OnLeave)
	end
	EFCReport.created = true
end