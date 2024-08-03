local wtRowsPanel = mainForm:GetChildChecked("RowsPanel", false)
local wtEnslavementPanel = mainForm:GetChildChecked("EnslavementPanel", false)
local wtOptionsPanel = mainForm:GetChildChecked("OptionsPanel", false)
local Header = wtOptionsPanel:GetChildChecked("HeaderText", false) 
local GroupPanel = wtOptionsPanel:GetChildChecked("GroupPanel", true)  
local GroupHeader = wtOptionsPanel:GetChildChecked("GroupHeader", true) 
local wtGroupContainer = wtOptionsPanel:GetChildChecked("GroupContainer", true)
local OptionsContainer = wtOptionsPanel:GetChildChecked("Container", true)
local SliderBG = wtOptionsPanel:GetChildChecked("SliderBackground", false)
local wtCurPanel = wtRowsPanel:GetChildChecked("Currencies", false)
local wtLabel = wtCurPanel:GetChildChecked("SearchLine", false):GetChildChecked("Label", false)
local wtEditLine = wtCurPanel:GetChildChecked("SearchLine", false):GetChildChecked("EditLine", false)
local wtInfoLabirint = wtCurPanel:GetChildChecked("Info", false)
local wtHeader = wtRowsPanel:GetChildChecked("Header", false)
local wtEnsHeader = wtEnslavementPanel:GetChildChecked("Header", false)
local wtShowHideButton = mainForm:GetChildChecked("ShowForm", false)
local wtCheck = wtRowsPanel:GetChildChecked("CheckboxRestart", false)
local wtAutoRestart = wtRowsPanel:GetChildChecked("AutoRestart", false)
local wtEmbrium = wtCurPanel:GetChildChecked("Embrium", false)
local wtCoral = wtCurPanel:GetChildChecked("Coral", false)
local wtGranit = wtCurPanel:GetChildChecked("Granit", false)
local wtSpark = wtCurPanel:GetChildChecked("Spark", false)
local wtSupplies = wtCurPanel:GetChildChecked("Supplies", false)
local wtPayToMerc = wtCurPanel:GetChildChecked("PayToMerc", false)
local wtIcon = wtCurPanel:GetChildChecked("Icon", false)
local wtContainer = wtRowsPanel:GetChildChecked("Container", false)
local wtEnsContainer = wtEnslavementPanel:GetChildChecked("Container", false)
local ButtonUsebox = mainForm:GetChildChecked("ButtonUsebox", false)
local Bag = stateMainForm:GetChildChecked("ContextBag", false):GetChildChecked("Bag", false) Bag:AddChild(ButtonUsebox)


local tablecolor = { ['LogColorBlack'] = "0xFF95918C", ['LogColorLightGreen'] = "0xFF1DF914", ['LogColorBlue'] = "0xFF1974D2" }

local colorclass = {
[0] = "tip_grey",
[1] = "Common",
[2] = "Uncommon",
[3] = "Rare",
[4] = "Epic",
[5] = "Legendary",
[6] = "Relic",
}

local AstralSector = {
[0] = "None",
[1] = "Emerald",
[2] = "Azure",
[3] = "Purple",
[4] = "Amber",
[5] = "Forsaken",
[6] = "Relic",
}

local IconCoral
local IconGranit
local IconSpark
local IconSupplies
local IconPayToMerc
local IconEmbrium

local SortShard
local SortName
local SortType
local SortValue
local SortDays
local SortDelete

local SortEnsShard
local SortEnsName
local SortEnsTime
local SortEnsQuality
local SortEnsDelete
local wtDefendersType

local Rog = {}
local wtOption = {}
local wtOptionContainer = {}
local RogSelected = {}
local CurrentUnlock = 0

local ListRows = {10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20}
local ListDelay = {0, 1, 2, 3, 4, 5, 6, 7}
local ListTimeZone = {-11, -10, -9, -8, -7, -6, -5, -4, -3, -2, -1, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11}
local ListSupplies = {0, 1000, 2000, 3000, 4000, 5000, 7500, 10000, 12500, 15000, 20000}
local ListUseBoxSettings = {0, 1, 2, 3}

local UseBoxNameTable = {
[1] = GTL('Gold') ,
[2] = GTL('Tears'),
[3] = GTL('Coral'),
[4] = GTL('Granit'),
}

local eventMy = 0
local eventAll = 0
local eventCount = 0
local eventColor = "LogColorBlack"
local EnsName = "Avatar"

local wtInfo = nil
local wtTextInfo = nil
local wtInfoButton = nil
local wtInfoButton2 = nil

local Lab = nil
local Cfg = userMods.GetGlobalConfigSection("LabCalendar_Cfg") or {}
local cfgId = nil
local EnsCfg = nil
local EnsCfgId = nil
local itemtable

local config = {
    ['Rows'] = 10,
    ['Delay'] = 1,
    ['TimeZone'] = 12,
    ['SuppliesLimit'] = 1,
    ['ShowSupplies'] = true,
    ['FullMode'] = true,
    ['ShowInfo'] = true,
    ['ShowHornReady'] = true,
    ['ShowHornForEmbrium'] = true,
    ['ShowHornBuild'] = true,
    ['ShowEnsReady'] = true,
    ['ShowDefenderUpdate'] = true,
    ['WeeklyBoxSettings'] = 3,
    ['AutoUseWeaklyBoxes'] = true,
}

local day = 1000 * 60 * 60 * 24
local timezone = 1000 * 60 * 60 * ListTimeZone[config['TimeZone']]

local avatarId = nil
local avatarName = nil
local ShardName = nil

local IsAOPanelEnabled = GetConfig("EnableAOPanel") or GetConfig("EnableAOPanel") == nil
------------------------------------------------------
function CloneTable(t)
    if type(t) ~= "table" then return t end
    local c = {}
    for i, v in pairs(t) do c[i] = CloneTable(v) end
    return c
end

function LogTable(t, tabstep)
    tabstep = tabstep or 1
    if t == nil then
        LogInfo("nil (no table)")
        return
    end
    assert(type(t) == "table", "Invalid data passed")
    local TabString = string.rep("    ", tabstep)
    local isEmpty = true
    for i, v in pairs(t) do
        if type(v) == "table" then
            LogInfo(TabString, i, ":")
            LogTable(v, tabstep + 1)
        else
            LogInfo(TabString, i, " = ", v)
        end
        isEmpty = false
    end
    if isEmpty then
        LogInfo(TabString, "{} (empty table)")
    end
end

function wtSetPlace(w, place)
    local p = w:GetPlacementPlain()
    for k, v in pairs(place) do
        p[k] = place[k] or v
    end
    w:SetPlacementPlain(p)
end

function SetWidth(w, newW)
    local Placement = w:GetPlacementPlain()
    Placement.sizeY = 120 + (31 * newW)
    w:SetPlacementPlain(Placement)
end

function WCD(descr, name, parent, place, show)
	local d1 = mainForm:GetChildChecked( descr, true )
	local d2= d1:GetWidgetDesc()
	local n
	n = mainForm:CreateWidgetByDesc( d2 )
	if name then n:SetName( name ) end
	if parent then parent:AddChild(n) end
	if place then wtSetPlace( n, place ) end
	n:Show( show == true )
	return n
end

--local wtEditLine = WCD("EditLine", "EditLine", nil, nil, true)

function ShowInfo(mode)
	if not config['ShowInfo'] then return end
    wtInfo = WCD("InfoPanel", 'InfoPanel', mainForm, { alignX = 2, posX = 0, highPosX = 0, sizeX = 300, alignY = 2, posY = 0, highPosY = 0, sizeY = 140 }, true)
    wtTextInfo = WCD("Text", "TextInfo1", wtInfo, { alignX = 3, sizeX = 0, posX = 10, highPosX = 10, alignY = 0, sizeY = 45, posY = 30, highPosY = 0, }, true)
    if mode == 0 then
        wtTextInfo:SetFormat(userMods.ToWString('<header alignx = "center" fontsize="15" outline="1"><rs class="class"><tip_white><r name="value"/></tip_white><br><tip_green><r name="value2"/></tip_green><tip_yellow><r name="value3"/></tip_yellow></br></rs></header>'))
        wtTextInfo:SetVal("value", GTL('Harvest') .. ': ')
        wtTextInfo:SetVal("value2", userMods.FromWString(avatarName) .. ': ' .. tostring(eventMy) .. ', ')
        wtTextInfo:SetVal("value3", GTL('Other') .. ': ' .. tostring(eventAll))
        wtInfoButton = WCD("Button", 'ShowInfo', wtInfo, { alignX = 2, posX = 0, highPosX = 0, sizeX = 80, alignY = 1, posY = 0, highPosY = 20, sizeY = 30 }, true)
        wtInfoButton:SetVal("button_label", userMods.ToWString("OK"))
    elseif mode == 1 then
        wtTextInfo:SetFormat(userMods.ToWString('<header alignx = "center" fontsize="16" outline="1"><rs class="class"><tip_green><r name="value"/></tip_green></rs></header>'))
        wtTextInfo:SetVal("value", GTL("Horn Not Found"))
        wtInfoButton = WCD("Button", 'Robbed', wtInfo, { alignX = 0, posX = 20, highPosX = 0, sizeX = 90, alignY = 1, posY = 0, highPosY = 20, sizeY = 30 }, true)
        wtInfoButton:SetVal("button_label", userMods.ToWString(GTL("Robbed")))
        wtInfoButton2 = WCD("Button", 'NewHorn', wtInfo, { alignX = 0, posX = 190, highPosX = 0, sizeX = 90, alignY = 1, posY = 0, highPosY = 20, sizeY = 30 }, true)
        wtInfoButton2:SetVal("button_label", userMods.ToWString(GTL("New Horn")))
    elseif mode == 2 then
        wtTextInfo:SetFormat(userMods.ToWString('<header alignx = "center" fontsize="16" outline="1"><rs class="class"><tip_green><r name="value"/></tip_green></rs></header>'))
        wtTextInfo:SetVal("value", GTL('Can Build New'))
        wtInfoButton = WCD("Button", 'ShowInfo', wtInfo, { alignX = 2, posX = 0, highPosX = 0, sizeX = 80, alignY = 1, posY = 0, highPosY = 20, sizeY = 30 }, true)
        wtInfoButton:SetVal("button_label", userMods.ToWString("OK"))
    elseif mode == 3 then
		wtTextInfo:SetFormat(userMods.ToWString('<header alignx = "center" fontsize="15" outline="1"><rs class="class"><tip_white><r name="value"/></tip_white><br><tip_green><r name="value2"/></tip_green></br></rs></header>'))
        wtTextInfo:SetVal("value", GTL('EnsReady'))
        wtTextInfo:SetVal("value2", EnsName)
        wtInfoButton = WCD("Button", 'ShowInfo', wtInfo, { alignX = 2, posX = 0, highPosX = 0, sizeX = 80, alignY = 1, posY = 0, highPosY = 20, sizeY = 30 }, true)
        wtInfoButton:SetVal("button_label", userMods.ToWString("OK"))
	elseif mode == 4 then
        wtTextInfo:SetFormat(userMods.ToWString('<header alignx = "center" fontsize="16" outline="1"><rs class="class"><tip_green><r name="value"/></tip_green></rs></header>'))
        wtTextInfo:SetVal("value", GTL('Can Build New For Embrium'))
        wtInfoButton = WCD("Button", 'ShowInfo', wtInfo, { alignX = 2, posX = 0, highPosX = 0, sizeX = 80, alignY = 1, posY = 0, highPosY = 20, sizeY = 30 }, true)
        wtInfoButton:SetVal("button_label", userMods.ToWString("OK"))
	elseif mode == 5 then
		wtTextInfo:SetFormat(userMods.ToWString('<header alignx = "center" fontsize="15" outline="1"><rs class="class"><tip_white><r name="value"/></tip_white><br><tip_red><r name="value2"/></tip_red><tip_white><r name="value3"/></tip_white><tip_green><r name="value4"/></tip_green></br></rs></header>'))
		wtTextInfo:SetVal("value", GTL('You need more supplies'))
        wtTextInfo:SetVal("value2", tostring(Cfg[cfgId].HaveSupplies))
        wtTextInfo:SetVal("value3", tostring(GTL("From")))
        wtTextInfo:SetVal("value4", tostring(ListSupplies[config['SuppliesLimit']]))
        wtInfoButton = WCD("Button", 'ShowInfo', wtInfo, { alignX = 2, posX = 0, highPosX = 0, sizeX = 80, alignY = 1, posY = 0, highPosY = 20, sizeY = 30 }, true)
        wtInfoButton:SetVal("button_label", userMods.ToWString("OK"))
	elseif mode == 6 then
        wtTextInfo:SetFormat(userMods.ToWString('<header alignx = "center" fontsize="16" outline="1"><rs class="class"><tip_green><r name="value"/></tip_green></rs></header>'))
        wtTextInfo:SetVal("value", GTL('Up defenders!'))
        wtInfoButton = WCD("Button", 'ShowInfo', wtInfo, { alignX = 2, posX = 0, highPosX = 0, sizeX = 80, alignY = 1, posY = 0, highPosY = 20, sizeY = 30 }, true)
        wtInfoButton:SetVal("button_label", userMods.ToWString("OK"))
    end
end

function AddRogWith(avatarName, RogType, RogDays, RogId, RogValue, shardName)
    -- LogInfo("Adding Horn")
    local ldate = common.GetLocalDateTime()
    local now = math.floor((ldate.overallMs + timezone) / day) * day
    local slab = {
        Name = avatarName,
        Type = RogType,
        Date = now + RogDays * day + ListDelay[config['Delay']] * day,
        Id = RogId,
        Value = RogValue,
        Shard = shardName
    }

    if GetTableSize(Lab) > 0 then
        table.insert(Lab, slab)
    else
        Lab = { [1] = slab }
    end
    CreateList()
    userMods.SetGlobalConfigSection("LabCalendar_Data", Lab)
	RogSelected = {}
end

function AddRog(num)
    -- LogInfo("function AddRog()")
    table.insert(Rog, {})

    local ldate = common.GetLocalDateTime()
    local now = math.floor((ldate.overallMs + timezone) / day) * day

    local col = 'white'
    if Lab[num].Date <= now then
        if userMods.FromWString(Lab[num].Name) == userMods.FromWString(avatarName)
                and userMods.FromWString(Lab[num].Shard) == userMods.FromWString(ShardName) then
            eventMy = eventMy + 1
        else
            eventAll = eventAll + 1
        end
        col = 'green'
    end

    if not Lab[num].Value then
        Lab[num].Value = 0
    end

    Rog[num].Id = Lab[num].Id
    Rog[num].Days = (Lab[num].Date - now) / day
    if Rog[num].Days < 0 then
        Rog[num].Days = 0
    end

    Rog[num].wtPanel = WCD("ItemPanel", 'Panel', nil, { alignX = 3, sizeX = 372, posX = 5, highPosX = 25, alignY = 3, sizeY = 30, posY = 0, highPosY = 0, }, true)

    if userMods.FromWString(Lab[num].Name) == userMods.FromWString(avatarName)
            and userMods.FromWString(Lab[num].Shard) == userMods.FromWString(ShardName) then
        Rog[num].wtPanel:SetBackgroundColor({ r = 1.0; g = 1.0; b = 1.0; a = 1.0 })
    else
        Rog[num].wtPanel:SetBackgroundColor({ r = 0.7; g = 0.7; b = 0.8; a = 1.0 })
    end
	Rog[num].wtShard = WCD("Shard", "Shard", Rog[num].wtPanel, { alignX = 0, sizeX = 50, posX = 0, highPosX = 0, alignY = 0, sizeY = 20, posY = 6, highPosY = 0, }, true)
    Rog[num].wtShard:SetFormat(userMods.ToWString('<header alignx = "center" fontsize="12" outline="1"><rs class="class"><tip_' .. col .. '><r name="value"/></tip_' .. col .. '></rs></header>'))
    Rog[num].wtShard:SetVal("value", Lab[num].Shard)

    Rog[num].wtName = WCD("Name", "Name", Rog[num].wtPanel, { alignX = 0, sizeX = 140, posX = 50, highPosX = 0, alignY = 0, sizeY = 20, posY = 6, highPosY = 0, }, true)
    Rog[num].wtName:SetFormat(userMods.ToWString('<header alignx = "center" fontsize="12" outline="1"><rs class="class"><tip_' .. col .. '><r name="value"/></tip_' .. col .. '></rs></header>'))
    Rog[num].wtName:SetVal("value", Lab[num].Name)

    Rog[num].wtType = WCD("Type", "Type", Rog[num].wtPanel, { alignX = 0, sizeX = 86, posX = 195, highPosX = 0, alignY = 0, sizeY = 20, posY = 6, highPosY = 0, }, true)
    Rog[num].wtType:SetFormat(userMods.ToWString('<header alignx = "center" fontsize="12" outline="1"><rs class="class"><tip_' .. col .. '><r name="value"/></tip_' .. col .. '></rs></header>'))
    Rog[num].wtType:SetVal("value", GTL(Lab[num].Type))

    Rog[num].wtVal = WCD("Value", "Value", Rog[num].wtPanel, { alignX = 0, sizeX = 55, posX = 280, highPosX = 15, alignY = 0, sizeY = 20, posY = 6, highPosY = 0, }, true)
    Rog[num].wtVal:SetFormat(userMods.ToWString('<header alignx = "center" fontsize="12" outline="1"><rs class="class"><tip_' .. col .. '><r name="value"/></tip_' .. col .. '></rs></header>'))
    Rog[num].wtVal:SetVal("value", tostring(Lab[num].Value))

    Rog[num].wtDays = WCD("Days", "Days", Rog[num].wtPanel, { alignX = 0, sizeX = 50, posX = 335, highPosX = 15, alignY = 0, sizeY = 20, posY = 6, highPosY = 0, }, true)
    Rog[num].wtDays:SetFormat(userMods.ToWString('<header alignx = "center" fontsize="12" outline="1"><rs class="class"><tip_' .. col .. '><r name="value"/></tip_' .. col .. '></rs></header>'))
    Rog[num].wtDays:SetVal("value", tostring(Rog[num].Days))

    Rog[num].wtDel = WCD("ButtonDelete", 'RogDel_' .. Lab[num].Id, Rog[num].wtPanel, nil, true)

    wtContainer:Insert(num - 1, Rog[num].wtPanel)
end

function DelRog(n)
    --LogInfo("function DelRog()")
    -- LogInfo("Deleting Horn at position "..n)
    for i = 1, GetTableSize(Rog) do
        if Rog[i].Id == Lab[n].Id then
            if Rog[i].Days == 0 then
            end
            Rog[i].wtPanel:DestroyWidget()
            Rog[i].wtPanel = nil
            table.remove(Rog, i)
            break
        end
    end
    table.remove(Lab, n)
end

function CloseInfo(param)
	param.widget:GetParent():DestroyWidget()
	wtInfo = nil
end
--OnClick
function OnButtonClick(param)
    if DnD:IsDragging() then
        return
    end
    local num = 0
    local ldate = common.GetLocalDateTime()
    local now = math.floor((ldate.overallMs + timezone) / day) * day
    if param.sender == 'ShowForm' then
        wtRowsPanel:Show(not wtRowsPanel:IsVisible()) wtEditLine:SetFocus(false) wtLabel:Show(true) wtEditLine:SetText(common.GetEmptyWString()) DestroyRowsList() CreateList()
    elseif param.sender == 'ButtonCornerCross' then
        wtRowsPanel:Show(false)
    elseif param.sender == 'ButtonCloseEnslavement' then
        wtEnslavementPanel:Show(false) DestroyEnsList()
    elseif param.sender == 'ShowInfo' then
        CloseInfo(param)
    elseif param.sender == 'ButtonSettings' then
	if wtOptionsPanel:IsVisible() then	
		wtOptionsPanel:Show(false)
		wtOption['ShowInfo'].widget:DestroyWidget()
		wtOption['ShowHornReady'].widget:DestroyWidget()
		wtOption['FullMode'].widget:DestroyWidget()
		wtOption['ShowHornBuild'].widget:DestroyWidget()
		wtOption['SuppliesLimit'].widget:DestroyWidget()
		wtOption['ShowHornForEmbrium'].widget:DestroyWidget()
		wtOption['ShowDefenderUpdate'].widget:DestroyWidget()
		wtOption['ShowEnsReady'].widget:DestroyWidget()
		wtOption['ShowSupplies'].widget:DestroyWidget()
		wtOption['WeeklyBoxSettings'].widget:DestroyWidget()
		wtOption['Delay'].widget:DestroyWidget()
		wtOption['AutoUseWeaklyBoxes'].widget:DestroyWidget()
		wtOption['Rows'].widget:DestroyWidget()
		wtOption['TimeZone'].widget:DestroyWidget()
		wtOptionContainer[1].container:DestroyWidget()
		wtOptionContainer[2].widget:DestroyWidget()
	else
		wtOptionsPanel:Show(true)	
		ShowSettings()
	end  
    elseif param.sender == 'Robbed' then
        for i = 1, GetTableSize(Lab) do
            if (userMods.FromWString(Lab[i].Name) == userMods.FromWString(avatarName)) and (Lab[i].Type == RogSelected.Type) and (userMods.FromWString(Lab[i].Shard) == userMods.FromWString(ShardName)) then
                Lab[i].Date = Lab[i].Date + 2 * day
                for j = 1, GetTableSize(Rog) do
                    if Rog[j].Id == Lab[i].Id then
                        Rog[j].wtDays:SetVal("name", tostring((Lab[i].Date - now) / day))
                        break
                    end
                end
            end
        end
        userMods.SetGlobalConfigSection("LabCalendar_Data", Lab)
		RogSelected = {}				
        CloseInfo(param)

    elseif param.sender == 'NewHorn' then
        local num = 0
        if Lab then
            num = GetTableSize(Lab)
        end

        AddRogWith(avatarName, RogSelected.Type, RogSelected.Days, ldate.overallMs, RogSelected.Value, ShardName)
        CloseInfo(param)
    elseif string.find(param.sender, 'EnsClear_') then
        num = tonumber(string.sub(param.sender, 10))
        param.widget:GetParent():DestroyWidget()
        EnsCfg[num] = nil
        userMods.SetGlobalConfigSection("LabCalendar_EnsCfg", EnsCfg)
    elseif string.find(param.sender, 'RogDel_') then
        num = tonumber(string.sub(param.sender, 8))
        for i = 1, GetTableSize(Lab) do
            if Lab[i].Id == num then
                DelRog(i)
                userMods.SetGlobalConfigSection("LabCalendar_Data", Lab)
                eventMy = eventMy - 1
                eventCount = 0
                if eventMy ~= 0 then
                    eventCount = eventMy
                else
                    eventCount = eventAll
                end
				if eventMy < 0 then
				  eventCount = eventAll
                end
                eventColor = "LogColorBlack"
                if eventAll ~= 0 then
                    eventColor = "LogColorBlue"
                end
                if eventMy ~= 0 then
                    eventColor = "LogColorLightGreen"
                end

                if wtShowHideButton:IsVisible() then
                    wtShowHideButton:SetVal("button_label", userMods.ToWString("    " .. tostring(eventCount)))
                    wtShowHideButton:SetTextColor(nil, tablecolor[eventColor])
                else
                    local SetVal = { val1 = userMods.ToWString("    " .. tostring(eventCount)), class1 = eventColor }
                    userMods.SendEvent("AOPANEL_UPDATE_ADDON", { sysName = "LabCalendar", header = SetVal })
                end
                break
            end
        end
    end
end

function OnCornerCross(param) --destroywgts
    wtOptionsPanel:Show(not wtOptionsPanel:IsVisible())
    if param.sender == 'ButtonCornerCross' then
	wtOption['ShowInfo'].widget:DestroyWidget()
	wtOption['ShowHornReady'].widget:DestroyWidget()
	wtOption['FullMode'].widget:DestroyWidget()
	wtOption['ShowHornBuild'].widget:DestroyWidget()
	wtOption['SuppliesLimit'].widget:DestroyWidget()
	wtOption['ShowHornForEmbrium'].widget:DestroyWidget()
	wtOption['ShowDefenderUpdate'].widget:DestroyWidget()
	wtOption['ShowEnsReady'].widget:DestroyWidget()
	wtOption['ShowSupplies'].widget:DestroyWidget()
	wtOption['WeeklyBoxSettings'].widget:DestroyWidget()
	wtOption['Delay'].widget:DestroyWidget()
	wtOption['AutoUseWeaklyBoxes'].widget:DestroyWidget()
	wtOption['Rows'].widget:DestroyWidget()
	wtOption['TimeZone'].widget:DestroyWidget()
	wtOptionContainer[1].container:DestroyWidget()
	wtOptionContainer[2].widget:DestroyWidget()
	end
end

function OnButtonClickR(param)
    if param.sender == 'ShowForm' then
        wtEnslavementPanel:Show(not wtEnslavementPanel:IsVisible()) OnShowEnslavementPanel()
    end
end

Header:SetVal("name", common.GetAddonName())

function createContainer(id, text)
local newWidget = {}
newWidget.widget = WCD("GroupPanel") 
newWidget.widget:Show( true )
newWidget.header = newWidget.widget:GetChildChecked("GroupHeader", true) 
newWidget.header:Show( true )
newWidget.header:SetVal("value", text)
newWidget.container = newWidget.widget:GetChildChecked("GroupContainer", true) 

OptionsContainer:PushBack(newWidget.widget)

wtOptionContainer[id] = newWidget
end

function createListPanel(id, container, text, list, listtext)
	local newWidget = {}
	newWidget.widget = WCD("ListPanel")
	newWidget.widget:Show( true )
	newWidget.text = newWidget.widget:GetChildChecked( "ListPanelText", false )
	newWidget.text:SetVal( "list_text", text)
	newWidget.descText = newWidget.widget:GetChildChecked( "ListPanelDescText", false )
	newWidget.index = config[id]
	if listtext then
	newWidget.descText:SetVal( "list_desctext", listtext[newWidget.index])
	else
	newWidget.descText:SetVal( "list_desctext", userMods.FromWString(common.FormatNumber( list[newWidget.index], "[3]A5")))
	end
	newWidget.leftButton = newWidget.widget:GetChildChecked( "ListPanelButtonLeft", false )
	newWidget.rightButton = newWidget.widget:GetChildChecked( "ListPanelButtonRight", false )
	newWidget.leftButton:SetName(id)
	newWidget.rightButton:SetName(id)
	newWidget.list = list
	newWidget.maxIndex = GetTableSize(list)
	function newWidget:update(id)
		self.index = config[id]
		if listtext then
		newWidget.descText:SetVal( "list_desctext", listtext[newWidget.index])
		else
		wtOption[id].descText:SetVal( "list_desctext", userMods.FromWString(common.FormatNumber( list[newWidget.index], "[3]A5")))
		end
		wtOption[id].leftButton:Enable( self.index ~= 1 )
		wtOption[id].rightButton:Enable( self.index ~= self.maxIndex)
	end
	container:PushBack( newWidget.widget )
	wtOption[id] = newWidget
end

function сreateBoxPanel(id, container, text)
	local newWidget = {}
	newWidget.widget = WCD("CheckboxPanel")
	newWidget.widget:Show( true )
	newWidget.value = config[id]
	newWidget.text = newWidget.widget:GetChildChecked( "CheckboxPanelText", false )
	newWidget.text:SetVal( "checkbox_text", text)
	newWidget.checkbox = newWidget.widget:GetChildChecked( "Checkbox", false )
	newWidget.checkbox:SetName(id)
	newWidget.checkbox:SetVariant( newWidget.value and 1 or 0 )
function newWidget:update(id)
	self.value = config[id]
	self.checkbox:SetVariant( self.value and 1 or 0 )
end
	container:PushBack( newWidget.widget )
	wtOption[id] = newWidget
end

function listleftbuttonpressed( params )
	local id = params.sender
	local newIndex = wtOption[id].index - 1

	if newIndex >= 1 then	
		wtOption[id].descText:SetVal( "list_desctext", userMods.FromWString(common.FormatNumber( wtOption[id].list[newIndex], "[3]A5")) )
		wtOption[id].index = newIndex
	end

	if newIndex == 1 then
		wtOption[id].leftButton:Enable( false )
	else
	  wtOption[id].leftButton:Enable( true )
	end
	
	wtOption[id].rightButton:Enable( true )	
	config[id] = newIndex
	updateGUI()	
end


function listrightbuttonpressed( params )
	local id = params.sender
	local newIndex = wtOption[id].index + 1

	if newIndex <= wtOption[id].maxIndex then	
		wtOption[id].descText:SetVal( "list_desctext", userMods.FromWString(common.FormatNumber( wtOption[id].list[newIndex], "[3]A5")) )
		wtOption[id].index = newIndex
	end

	if newIndex == wtOption[id].maxIndex then
		wtOption[id].rightButton:Enable( false )
	else
	  wtOption[id].rightButton:Enable( true )
	end
	
	wtOption[id].leftButton:Enable( true )	

	config[id] = newIndex
	updateGUI()
end

function updateGUI()
		for id, v in pairs(wtOption) do
			v:update(id)
		end
	SetWidth(wtRowsPanel, ListRows[config['Rows']])
	userMods.SetGlobalConfigSection("LabCalendar_Settings", config)
	Cfg[cfgId].UseBoxSettings = config["WeeklyBoxSettings"]
	userMods.SetGlobalConfigSection("LabCalendar_Cfg", Cfg)
end

function ShowSettings()
createContainer(1, GTL('General Options'))
сreateBoxPanel("FullMode", wtOptionContainer[1].container, GTL('FullMode'))
createListPanel("Rows", wtOptionContainer[1].container, GTL("Rows" ), ListRows)
createListPanel("Delay", wtOptionContainer[1].container, GTL("Delay"), ListDelay)
createListPanel("TimeZone", wtOptionContainer[1].container, GTL("TimeZone"), ListTimeZone)
createListPanel("SuppliesLimit", wtOptionContainer[1].container, GTL("SuppliesLimit"), ListSupplies)
сreateBoxPanel("AutoUseWeaklyBoxes", wtOptionContainer[1].container, GTL('AutoUseWeaklyBoxes'))
createListPanel("WeeklyBoxSettings", wtOptionContainer[1].container, GTL("WeeklyBoxSettings"), ListUseBoxSettings, UseBoxNameTable)
createContainer(2, GTL('Announcement'))
сreateBoxPanel("ShowInfo", wtOptionContainer[2].container, GTL('ShowInfo'))
сreateBoxPanel("ShowHornReady", wtOptionContainer[2].container, GTL('ShowHornReady'))
сreateBoxPanel("ShowHornBuild", wtOptionContainer[2].container, GTL('ShowHornBuild'))
сreateBoxPanel("ShowHornForEmbrium", wtOptionContainer[2].container, GTL('ShowHornForEmbrium'))
сreateBoxPanel("ShowEnsReady", wtOptionContainer[2].container, GTL('ShowEnsReady'))
сreateBoxPanel("ShowSupplies", wtOptionContainer[2].container, GTL('ShowSupplies'))
сreateBoxPanel("ShowDefenderUpdate", wtOptionContainer[2].container, GTL('ShowDefenderUpdate'))
updateGUI()
end

function GetMaxDefenderRank(gearscore)
local defenderrank = 0
if gearscore < 38043 and CurrentUnlock >= 1 or CurrentUnlock >= 1 then --fix 13.0
defenderrank = 1
end
if gearscore >= 38043 and CurrentUnlock >= 2 then
defenderrank = 2
end
if gearscore >= 47369 and CurrentUnlock >= 3 then
defenderrank = 3
end
if gearscore >= 58799 and CurrentUnlock >= 4 then
defenderrank = 4
end
if gearscore >= 73246 and CurrentUnlock >= 5 then
defenderrank = 5
end
if gearscore >= 90663 and CurrentUnlock >= 6 then
defenderrank = 6
end
	return defenderrank
end
function CheckRog()
    local ldate = common.GetLocalDateTime()
    local now = math.floor((ldate.overallMs + timezone) / day) * day
    --LogInfo("now")
    --LogInfo(now)
    --LogInfo("LabName "..userMods.FromWString(avatarName))
    --LogInfo("RogSelected "..RogSelected.Type)
    --LogInfo("ShardName "..userMods.FromWString(ShardName))
    --LogInfo("Days "..RogSelected.Days)

    local found = false
	local broken = false 
	local position = 0
if config['FullMode'] then
    for i = 1, GetTableSize(Lab) do
        if (userMods.FromWString(Lab[i].Name) == userMods.FromWString(avatarName))
                and (Lab[i].Type == RogSelected.Type)
                and (userMods.FromWString(Lab[i].Shard) == userMods.FromWString(ShardName))
                and (((Lab[i].Date - now) / day == RogSelected.Days) or ((RogSelected.Days == 0) and ((Lab[i].Date - now) / day < 0))) then
            --LogInfo("found")
            found = true
            break
        end
    end

	-- I like more rogs!
	if not found then
    for i=1, GetTableSize(Lab) do       
		if (userMods.FromWString(Lab[i].Name)==userMods.FromWString(avatarName)) and (Lab[i].Type==RogSelected.Type) and (Lab[i].Value==RogSelected.Value) and (userMods.FromWString(Lab[i].Shard) == userMods.FromWString(ShardName))
		and ((Lab[i].Date-now)/day+2==RogSelected.Days)
		then
			found = true
			broken = true
			break
			end
		end  
	end
	-- +2 days
	if found and broken then
		ShowInfo(1)   
	end

    if not found then
        --LogInfo("not found, adding")
        AddRogWith(avatarName, RogSelected.Type, RogSelected.Days, ldate.overallMs, RogSelected.Value, ShardName)
        wtInfoLabirint:SetVal("name", tostring(GetTableSize(Cfg))) --update labirint list
    end
elseif config['FullMode'] == 0 then
	for i = 1, GetTableSize(Lab) do
        if (userMods.FromWString(Lab[i].Name) == userMods.FromWString(avatarName))
                and (Lab[i].Type == RogSelected.Type)
                and (userMods.FromWString(Lab[i].Shard) == userMods.FromWString(ShardName)) then
            if (((Lab[i].Date - now) / day == RogSelected.Days) or ((RogSelected.Days == 0) and ((Lab[i].Date - now) / day < 0))) then
                -- LogInfo("===== found")
                found = true
                break
            elseif ((Lab[i].Date - now) / day == RogSelected.Days - 2) then
                -- LogInfo("===== found robbed")
                position = i
                broken = true
            end
        end
    end

    if not found then
        if (forceNew or not broken) then
            -- LogInfo("===== not found, adding")
            AddRogWith(avatarName, RogSelected.Type, RogSelected.Days, RogSelected.Id, RogSelected.Value, ShardName)

            -- TODO: Replace with a actual count of labirints (i.e. avatars), because now it is a total number of all horns
            -- Таблица CFG обновляется только тогда, когда происходит общение с гоблином непосредственно на Личном Аллоде, лишние персонажи, о которых нет аллода, не записываются туда.
			wtInfoLabirint:SetVal("name", tostring(GetTableSize(Cfg))) --update labirint list
        else
            -- LogInfo("===== not found, broken, asking")
            ShowInfo(1)
			end
		end
	end
	CreateList()
end

function OnInteract()
	local inter=avatar.GetInteractorInfo()
	if inter then
    
    if (userMods.FromWString(object.GetName(inter.interactorId))==GTL('Bob Jackhammer')) then
		local cue = avatar.GetInteractorNextCues()    
		if cue[0] then 
	if Cfg[cfgId].NeedCoral~=cue[0].data[0].number then
        Cfg[cfgId].NeedCoral=cue[0].data[0].number
        wtCoral:SetVal("val2", tostring(Cfg[cfgId].NeedCoral))
        userMods.SetGlobalConfigSection("LabCalendar_Cfg", Cfg)
		 end
	  else  
		if tostring(Cfg[cfgId].NeedCoral)~="Full" and (not cue[0]) then --need to fix
		Cfg[cfgId].NeedCoral="Full"
		wtCoral:SetVal("val2", GTL(tostring(Cfg[cfgId].NeedCoral)))
        userMods.SetGlobalConfigSection("LabCalendar_Cfg", Cfg)
		end
      end  
		if type(Cfg[cfgId].NeedCoral) == "number" then
		wtCoral:SetVal("val3", tostring((Cfg[cfgId].NeedCoral - Cfg[cfgId].HaveCoral)/5 ))
		else 
		wtCoral:SetVal("val3", "0")
		end
	elseif (userMods.FromWString(object.GetName(inter.interactorId))==GTL('Bob the Muscle')) then
		local cue = avatar.GetInteractorNextCues()
		if cue then
			local avatarGS = math.ceil(unit.GetGearScore(avatar.GetId()))
			Cfg[cfgId].DefenderRank = GetMaxDefenderRank(avatarGS)
			wtDefendersType:SetVal("name", GTL(AstralSector[Cfg[cfgId].DefenderRank]) )
			wtDefendersType:SetClassVal("class", colorclass[Cfg[cfgId].DefenderRank] )
			userMods.SetGlobalConfigSection("LabCalendar_Cfg", Cfg)
			--LogInfo(GetMaxDefenderRank(avatarGS), " ", GTL(AstralSector[Cfg[cfgId].DefenderRank]), " ", colorclass[Cfg[cfgId].DefenderRank])
		end
	elseif (userMods.FromWString(object.GetName(inter.interactorId))==GTL('Horn')) then  
      local num = 0
      local ldate = common.GetLocalDateTime()  
      local now = math.floor((ldate.overallMs+timezone)/day)*day    
		
      local cue = avatar.GetInteractorNextCues()
      local icue=avatar.GetInteractorCue()

      --Rog +Золото HotFix
      if string.find(userMods.FromWString(icue.name),GTL('Produce Gold')) then
        --LogInfo('Start money: '..tostring(icue.data[0].number))
        if Lab then num=GetTableSize(Lab) end
		
		local ValueGold = icue.data[0].number -- Rog gold fix
		if icue.data[0].number == 18882 then
		ValueGold = 18883
		end
		
        local slab={Name=avatarName,Type="Gold",Date=now+15*day+ListDelay[config['Delay']]*day, Id=ldate.overallMs, Value=ValueGold, Shard=ShardName}
        if config['FullMode'] then
		if num>0 then
          table.insert(Lab,slab)
        else
          Lab={[1]=slab}
        end  
        num=num+1
        AddRog(num)    
        userMods.SetGlobalConfigSection("LabCalendar_Data", Lab)
		elseif config['FullMode'] == 0 then
		CheckRog(true)
		end
        avatar.StopInteract()
		
		--Rog +EPIC_TEARS
      elseif string.find(userMods.FromWString(icue.name),GTL('Produce Epic Tears')) then
        --LogInfo('Start money: '..tostring(icue.data[0].number))
        if Lab then num=GetTableSize(Lab) end
        
        local slab={Name=avatarName,Type="EpicT",Date=now+15*day+ListDelay[config['Delay']]*day, Id=ldate.overallMs, Value=icue.data[0].number, Shard=ShardName}
		if config['FullMode'] then
		if num>0 then
          table.insert(Lab,slab)
        else
          Lab={[1]=slab}
        end  
        num=num+1
        AddRog(num)    
        userMods.SetGlobalConfigSection("LabCalendar_Data", Lab)
		elseif config['FullMode'] == 0 then
		CheckRog(true)
		end
        avatar.StopInteract()
		
		--Rog +LEGENDARY_TEARS
      elseif string.find(userMods.FromWString(icue.name),GTL('Produce Legendary Tears')) then
        --LogInfo('Start money: '..tostring(icue.data[0].number))
        if Lab then num=GetTableSize(Lab) end
        
        local slab={Name=avatarName,Type="LegendT",Date=now+15*day+ListDelay[config['Delay']]*day, Id=ldate.overallMs, Value=icue.data[0].number, Shard=ShardName}
		if config['FullMode'] then
		if num>0 then
          table.insert(Lab,slab)
        else
          Lab={[1]=slab}
        end  
        num=num+1
        AddRog(num)    
        userMods.SetGlobalConfigSection("LabCalendar_Data", Lab)
		elseif config['FullMode'] == 0 then
		CheckRog(true)
		end
        avatar.StopInteract()
        
      --Rog +Коралл
      elseif string.find(userMods.FromWString(icue.name),GTL('Produce Coral')) then
        --LogInfo('Start money: '..tostring(icue.data[0].number))
        if Lab then num=GetTableSize(Lab) end
        
        local slab={Name=avatarName,Type="Coral",Date=now+15*day+ListDelay[config['Delay']]*day, Id=ldate.overallMs, Value=icue.data[0].number, Shard=ShardName}
		if config['FullMode'] then
		if num>0 then
          table.insert(Lab,slab)
        else
          Lab={[1]=slab}
        end  
        num=num+1
        AddRog(num)    
        userMods.SetGlobalConfigSection("LabCalendar_Data", Lab)
		elseif config['FullMode'] == 0 then
		CheckRog(true)
		end
        avatar.StopInteract()
        
      --Rog +Гранит
      elseif string.find(userMods.FromWString(icue.name),GTL('Produce Granit')) then
        --LogInfo('Start money: '..tostring(icue.data[0].number))
        if Lab then num=GetTableSize(Lab) end
        
        local slab={Name=avatarName,Type="Granit",Date=now+15*day+ListDelay[config['Delay']]*day, Id=ldate.overallMs, Value=icue.data[0].number, Shard=ShardName}
        if config['FullMode'] then
			if num>0 then
			  table.insert(Lab,slab)
			else
			  Lab={[1]=slab}
			end  
			num=num+1
			AddRog(num)    
			userMods.SetGlobalConfigSection("LabCalendar_Data", Lab)
		elseif config['FullMode'] == 0 then
			CheckRog(true)
		end
        avatar.StopInteract()
		
		--Rog +Эмбриум(AO 9.1+)
      elseif string.find(userMods.FromWString(icue.name),GTL('Produce Embrium')) then
        --LogInfo('Start money: '..tostring(icue.data[0].number))
        if Lab then num=GetTableSize(Lab) end
        
        local slab={Name=avatarName,Type="Embrium",Date=now+15*day+ListDelay[config['Delay']]*day, Id=ldate.overallMs, Value=icue.data[0].number, Shard=ShardName}
        if config['FullMode'] then
			if num>0 then
			  table.insert(Lab,slab)
			else
			  Lab={[1]=slab}
			end  
			num=num+1
			AddRog(num)    
			userMods.SetGlobalConfigSection("LabCalendar_Data", Lab)
		elseif config['FullMode'] == 0 then
			CheckRog(true)
		end
        avatar.StopInteract()
       
      --Rog  выбрать
      elseif (userMods.FromWString(icue.name)==GTL('Manage Horn')) then
        --Рог перезапуск
        if (string.find(userMods.FromWString(icue.text:ToWString()),GTL('Horn Ready'))) and (Cfg[cfgId].AutoRestart) then 
			local choices = avatar.GetInteractorNextCues()
			
			local imax = choices and GetTableSize(choices) or -1
			for i = 0, imax do 
					if choices[i] and string.find(userMods.FromWString(choices[i].name), GTL('Produce Gold')) and RogSelected.Type=='Gold' then
					avatar.SelectInteractorCue(i)
					elseif choices[i] and string.find(userMods.FromWString(choices[i].name), GTL('Produce Coral')) and RogSelected.Type=='Coral' then
					avatar.SelectInteractorCue(i)
					elseif choices[i] and string.find(userMods.FromWString(choices[i].name), GTL('Produce Granit')) and RogSelected.Type=='Granit' then
					avatar.SelectInteractorCue(i)
					elseif choices[i] and string.find(userMods.FromWString(choices[i].name), GTL('Produce Embrium')) and RogSelected.Type=='Embrium' then
					avatar.SelectInteractorCue(i)
					elseif choices[i] and string.find(userMods.FromWString(choices[i].name), GTL('Produce Epic Tears')) and RogSelected.Type=='EpicT' then
					avatar.SelectInteractorCue(i)
					elseif choices[i] and string.find(userMods.FromWString(choices[i].name), GTL('Produce Legendary Tears')) and RogSelected.Type=='LegendT' then
					avatar.SelectInteractorCue(i)
					end 
				end
			
        --Рог еще работает
        elseif string.find(userMods.FromWString(icue.text:ToWString()),GTL('Horn Busy')) then 
          RogSelected.Days=icue.data[0].number
          if (userMods.FromWString(icue.data[1].string)==GTL('_Gold')) then
            RogSelected.Type='Gold'           
          elseif (userMods.FromWString(icue.data[1].string)==GTL('_Granit')) then
            RogSelected.Type='Granit'
          elseif (userMods.FromWString(icue.data[1].string)==GTL('_Coral')) then
            RogSelected.Type='Coral'    
		  elseif (userMods.FromWString(icue.data[1].string)==GTL('_Embrium')) then
            RogSelected.Type='Embrium'  
		  elseif (userMods.FromWString(icue.data[1].string)==GTL('_EpicTears')) then
            RogSelected.Type='EpicT'  
		  elseif (userMods.FromWString(icue.data[1].string)==GTL('_LegendTears')) then
            RogSelected.Type='LegendT'  
          end  
          RogSelected.Value=icue.data[2].number
          RogSelected.Shard=ShardName
          CheckRog(false)
        --Рог завершил работу  
        elseif string.find(userMods.FromWString(icue.text:ToWString()),GTL('Horn Completed')) then 
          RogSelected.Days=0
          if (userMods.FromWString(cue[0].data[0].string)==GTL('_Gold')) then
            RogSelected.Type='Gold'           
          elseif (userMods.FromWString(cue[0].data[0].string)==GTL('_Granit')) then
            RogSelected.Type='Granit'
          elseif (userMods.FromWString(cue[0].data[0].string)==GTL('_Coral')) then
            RogSelected.Type='Coral'       
          elseif (userMods.FromWString(cue[0].data[0].string)==GTL('_Embrium')) then
            RogSelected.Type='Embrium'
		  elseif (userMods.FromWString(cue[0].data[0].string)==GTL('_EpicTears')) then
			RogSelected.Type='EpicT'  	
		  elseif (userMods.FromWString(cue[0].data[0].string)==GTL('_LegendTears')) then
			RogSelected.Type='LegendT'  	  			
          end  
          RogSelected.Value=cue[0].data[1].number
		  RogSelected.Shard=ShardName
		if config['FullMode'] then
          CheckRog()
          avatar.SelectInteractorCue(0)          
          
          eventMy = eventMy - 1
          eventCount = 0
          if eventMy ~= 0 then  
            eventCount = eventMy
          else
            eventCount = eventAll
          end
		  if eventMy < 0 then
			  eventCount = eventAll
          end
          eventColor="LogColorBlack"
          if eventAll~=0 then eventColor="LogColorBlue" end
          if eventMy~=0 then eventColor="LogColorLightGreen" end          
          
          if wtShowHideButton:IsVisible() then
			wtShowHideButton:SetVal("button_label", userMods.ToWString("    "..tostring(eventCount)))
			wtShowHideButton:SetTextColor(nil, tablecolor[eventColor] )
          else 
            local SetVal = {val1 = userMods.ToWString("    "..tostring(eventCount)), class1=eventColor}
            userMods.SendEvent( "AOPANEL_UPDATE_ADDON", { sysName = "LabCalendar", header = SetVal } )          
          end  
		elseif config['FullMode'] == 0 then
		 -- "Схлопываем" одинаковые рога: удаляем готовый
				for i = 1, GetTableSize(Lab) do
					if (userMods.FromWString(Lab[i].Name) == userMods.FromWString(avatarName))
							and (Lab[i].Type == RogSelected.Type)
							and ((Lab[i].Date - now) / day <= 0)
							and (userMods.FromWString(Lab[i].Shard) == userMods.FromWString(RogSelected.Shard)) then
						-- LogInfo("===== Horn to be deleted...")
						DelRog(i)
						userMods.SetGlobalConfigSection("LabCalendar_Data", Lab)
						break
					end
				end
				-- "Схлопываем" одинаковые рога: не добавляем, если есть с тем же "ключом".
				avatar.SelectInteractorCue(0)
		end
          
        --Рог сломан  
        elseif string.find(userMods.FromWString(icue.text:ToWString()),GTL('Horn Broken')) then 
          RogSelected.Days=icue.data[1].number
        if (userMods.FromWString(icue.data[2].string)==GTL('_Gold')) then
            RogSelected.Type='Gold'           
        elseif (userMods.FromWString(icue.data[2].string)==GTL('_Granit')) then
            RogSelected.Type='Granit'
        elseif (userMods.FromWString(icue.data[2].string)==GTL('_Coral')) then
            RogSelected.Type='Coral'   
		elseif (userMods.FromWString(icue.data[2].string)==GTL('_Embrium')) then
            RogSelected.Type='Embrium' 		
		elseif (userMods.FromWString(icue.data[2].string)==GTL('_EpicTears')) then
            RogSelected.Type='EpicT' 	
		elseif (userMods.FromWString(icue.data[2].string)==GTL('_LegendTears')) then
            RogSelected.Type='LegendT' 				
          end  
          RogSelected.Value=icue.data[3].number  
		  RogSelected.Shard=ShardName
			if config['FullMode'] then
				CheckRog()
			elseif config['FullMode'] == 0 then
				local foundAtPosition = -1
                    for i = 1, GetTableSize(Lab) do
                        -- LogInfo(i)
                        if (userMods.FromWString(Lab[i].Name) == userMods.FromWString(avatarName))
                                and (Lab[i].Type == RogSelected.Type)
                                and (userMods.FromWString(Lab[i].Shard) == userMods.FromWString(RogSelected.Shard)) then
                            if (((Lab[i].Date - now) / day) == (icue.data[1].number - icue.data[0].number)) then
                                -- точное соответствие
                                foundAtPosition = i
                                break
                            elseif (((Lab[i].Date - now) / day) < (icue.data[1].number - icue.data[0].number)) then
                                -- возможно, счётчик остановлен грабежом, запоминаем индекс
                                foundAtPosition = i
                            end
                        end
                    end
                    if (foundAtPosition > 0) then
                        DelRog(foundAtPosition)
                    end
                    -- если совсем новый - добавляем; если был и ограблен, мы его только что удалили - добавляем
                    RogSelected.Type = RogSelected.Type
                    RogSelected.Days = icue.data[1].number
                    RogSelected.Value = icue.data[3].number
                    CheckRog(true)
			end
        end
        
      --Rog Отмена производства
      elseif (userMods.FromWString(icue.text:ToWString())==GTL('Production Canceled')) or (userMods.FromWString(icue.text:ToWString())==GTL('Ready for production')) then  
        local found=false
        for i=1, GetTableSize(Lab) do   
          if (userMods.FromWString(Lab[i].Name)==userMods.FromWString(avatarName)) and (Lab[i].Type==RogSelected.Type) and (Lab[i].Value==RogSelected.Value) 
          and (((Lab[i].Date-now)/day==RogSelected.Days) or ((RogSelected.Days==0) and ((Lab[i].Date-now)/day<0))) and (userMods.FromWString(Lab[i].Shard) == userMods.FromWString(RogSelected.Shard))
          then
            DelRog(i)
            found=true
            userMods.SetGlobalConfigSection("LabCalendar_Data", Lab)
            break
          end
        end
        if not found then
			for i=1, GetTableSize(Lab) do
            if (userMods.FromWString(Lab[i].Name)==userMods.FromWString(avatarName)) and (Lab[i].Type==RogSelected.Type) and (Lab[i].Value==0)
             and (userMods.FromWString(Lab[i].Shard) == userMods.FromWString(RogSelected.Shard))
				 then 
				if config['FullMode'] then
					if (((Lab[i].Date - now) / day == RogSelected.Days) or ((RogSelected.Days == 0) and ((Lab[i].Date-now) / day < 0))) then
					DelRog(i)
					found = true
					userMods.SetGlobalConfigSection("LabCalendar_Data", Lab)
						break
						end
					--end
				elseif config['FullMode'] == 0 then
					if ((Lab[i].Date - now) / day == RogSelected.Days) then
					DelRog(i)
					found = true
					userMods.SetGlobalConfigSection("LabCalendar_Data", Lab)
							break
						end
					end
				end 
			RogSelected = {}		
			end
        end
        avatar.SelectInteractorCue(0)
			
              
      --Rog  -1 день
      elseif (userMods.FromWString(icue.text:ToWString())==GTL('Spark Used')) then  
        for i=1, GetTableSize(Lab) do       
          if (userMods.FromWString(Lab[i].Name)==userMods.FromWString(avatarName)) and (Lab[i].Type==RogSelected.Type) and (Lab[i].Value==RogSelected.Value) and ((Lab[i].Date-now)/day==RogSelected.Days) and (userMods.FromWString(Lab[i].Shard)==userMods.FromWString(RogSelected.Shard))
          then
            Lab[i].Date=Lab[i].Date-day
            userMods.SetGlobalConfigSection("LabCalendar_Data", Lab)
            for j=1, GetTableSize(Rog) do
              if Rog[j].Id==Lab[i].Id then
                Rog[j].wtDays:SetVal("value", tostring((Lab[i].Date-now)/day))
                break
              end
            end
            break
					end
				end 
			end      
		end    
	end  
end

function AnnounceReadyHorn()
    if type(Cfg[cfgId].NeedCoral) == "number" then
        wtCoral:SetVal("val3", tostring((Cfg[cfgId].NeedCoral - Cfg[cfgId].HaveCoral) / 5))
    else
        wtCoral:SetVal("val3", "0")
    end
	-- anounce Horn build if only Coral enough to build
	if (not wtInfo) 
			and type(Cfg[cfgId].NeedCoral) == "number"
			and (Cfg[cfgId].HaveCoral >= Cfg[cfgId].NeedCoral) and Cfg[cfgId].NeedCoral~=0 and  config['ShowHornBuild'] then
        ShowInfo(2)
    end
	-- anounce Horn build if Coral+Embrium enough to build
    if (not wtInfo)
            and type(Cfg[cfgId].NeedCoral) == "number"
            and (Cfg[cfgId].HaveCoral + 5 * Cfg[cfgId].HaveEmbrium >= Cfg[cfgId].NeedCoral) and  Cfg[cfgId].NeedCoral~=0 and config['ShowHornForEmbrium'] then
        ShowInfo(4)
    end
end

function AnnounceNeedSupplies()
if Cfg[cfgId].HaveSupplies <= ListSupplies[config['SuppliesLimit']] and Cfg[cfgId].MainAllod and config['ShowSupplies'] then
	ShowInfo(5)
	end
end

function AnnounceCheckDefender()
local avatarGS = math.ceil(unit.GetGearScore(avatar.GetId()))
local show = false
if EnableAstral() then
	if avatarGS < 38043 and Cfg[cfgId].DefenderRank <= 0 then 
		show = true
	end
	if avatarGS >= 38043 and avatarGS < 47369 and Cfg[cfgId].DefenderRank < GetMaxDefenderRank(avatarGS) then
		show = true
	end
	if avatarGS >= 47369 and avatarGS < 58799 and Cfg[cfgId].DefenderRank < GetMaxDefenderRank(avatarGS) then
		show = true
	end
	if avatarGS >= 58799 and avatarGS < 73246 and Cfg[cfgId].DefenderRank < GetMaxDefenderRank(avatarGS) then
		show = true
	end
	if avatarGS >= 73246 and avatarGS < 90663 and Cfg[cfgId].DefenderRank < GetMaxDefenderRank(avatarGS) then
		show = true
	end
	if avatarGS >= 90663 and Cfg[cfgId].DefenderRank < GetMaxDefenderRank(avatarGS) then
		show = true
		end
	if show and config['ShowDefenderUpdate'] and EnablePlayersAllod() then
	ShowInfo(6)
		end
	end
end


function onEventAvatarItemTake(params)
if config['AutoUseWeaklyBoxes'] and userMods.FromWString(itemLib.GetName(params.itemObject:GetId())) == GTL("Dungeon Keeper's Chest") then
	--We can`t open the box immediately from the mail :C
	OpenBoxFromPost()
	end
end

function OpenBoxFromPost()
local tab = avatar.GetInventoryItemIds()
	for _,itemId in pairs( tab ) do
		local info=itemLib.GetItemInfo( itemId )
		if info and userMods.FromWString(info.name) == GTL("Dungeon Keeper's Chest") then
		local stack = itemLib.GetStackInfo( itemId )
		avatar.UseItemAndTakeActions( itemId, stack.count, ListUseBoxSettings[Cfg[cfgId].UseBoxSettings] )
		end
	end
end

function OnCurrencyChanged(param)
    local info = param.id:GetInfo()
    if info.name then
        if userMods.FromWString(info.name) == GTL('_Coral') then
            Cfg[cfgId].HaveCoral = Cfg[cfgId].HaveCoral + param.delta
            wtCoral:SetVal("val1", tostring(Cfg[cfgId].HaveCoral))
			AnnounceReadyHorn()
        elseif userMods.FromWString(info.name) == GTL('_Granit') then
            Cfg[cfgId].HaveGranit = Cfg[cfgId].HaveGranit + param.delta
            wtGranit:SetVal("val1", tostring(Cfg[cfgId].HaveGranit))
        elseif userMods.FromWString(info.name) == GTL('_Spark') then
            Cfg[cfgId].HaveIskra = Cfg[cfgId].HaveIskra + param.delta
            wtSpark:SetVal("val1", tostring(Cfg[cfgId].HaveIskra))
        elseif userMods.FromWString(info.name) == GTL('Embrium') then
            Cfg[cfgId].HaveEmbrium = Cfg[cfgId].HaveEmbrium + param.delta
            wtEmbrium:SetVal("val1", tostring(Cfg[cfgId].HaveEmbrium))
			AnnounceReadyHorn()
        elseif userMods.FromWString(info.name) == GTL('Supplies') then
            Cfg[cfgId].HaveSupplies = Cfg[cfgId].HaveSupplies + param.delta
            wtSupplies:SetVal("val1", common.FormatNumber(Cfg[cfgId].HaveSupplies, "[3]A5"))
			AnnounceNeedSupplies()
        elseif userMods.FromWString(info.name) == GTL('PayToMerc') then
            Cfg[cfgId].HavePayToMerc = Cfg[cfgId].HavePayToMerc + param.delta
            wtPayToMerc:SetVal("val1", common.FormatNumber(Cfg[cfgId].HavePayToMerc, "[3]A5"))
        end
    end
end

function UpdateMainLabirint()
if cartographer.GetCurrentZoneInfo().sysZoneName:find("PlayersAllod") then
		local buffsInfo = object.GetBuffsInfo( object.GetBuffs( avatar.GetId() ) )
		Cfg[cfgId].MainAllod = false
		for _, buffInfo in pairs( buffsInfo) do
			local name = buffInfo.name
				if cartographer.GetCurrentZoneInfo().sysZoneName then
					if buffInfo.sysName == "main_maze_announce" then
						Cfg[cfgId].MainAllod = true
					end
				end
			userMods.SetGlobalConfigSection("LabCalendar_Cfg", Cfg)
		end
	end
end

local RemortNames = stateMainForm:GetChildChecked("RemortList", false):GetChildChecked("RemortList", false):GetChildChecked("Content", false)
local remorts
RemortNames:SetOnShowNotification(true)

function trim(s)
   return s:match( "^%s*(.-)%s*$" )
end

function RemortListInfo()
    local ldate = common.GetLocalDateTime()
    local now = math.floor((ldate.overallMs + timezone) / day) * day
    local dnw = userMods.GetGlobalConfigSection("LabCalendar_Data")
    remorts = remort.GetRemortsList()
    for num, _ in pairs(remorts) do
        local wtcont = RemortNames:At(num)
        local child = wtcont:GetNamedChildren()
        for _, v in pairs(child) do
            if (common.GetApiType(v) == "TextViewSafe") and v:GetName() == "Name" then
                local txt = userMods.FromWString(v:GetValuedText():ToWString())
                local lens = string.len(txt)
                local conv = trim(string.sub(txt, 1, lens - 5))
                for _, val in pairs(dnw) do
                    if val.Date <= now and userMods.FromWString(ShardName) == userMods.FromWString(val.Shard) and userMods.FromWString(val.Name) == conv then    
						local ico = WCD("Icon", "ico" .. num, v, { alignX = 1, sizeX = 30, posX = 0, highPosX = -5, alignY = 1, sizeY = 30, posY = 0, highPosY = 0 }, true)
                        ico:SetBackgroundTexture(common.GetAddonRelatedTextureGroup("Group01"):GetTexture("Icon2"))
                        ico:SetPriority(50)
					end
                end
            end
        end
    end
end

function ClearWG(params)
    if params.widget:IsVisibleEx() == false and params.widget:GetName() == "Content" then
        if remorts then
            for num, _ in pairs(remorts) do
                local wtcont = RemortNames:At(num)
                local child = wtcont:GetNamedChildren()
                for _, v in pairs(child) do
                    if (common.GetApiType(v) == "TextViewSafe") and v:GetName() == "Name" then
                        local cld = v:GetNamedChildren()
                        for _, vv in pairs(cld) do
                            vv:DestroyWidget()
                        end
                    end
                end
            end
        end
    end
end

local cooldowntable = {
    [4] = 7200000,
    [5] = 28800000,
    [6] = 43200000,
}

local colors = {
    [4] = { r = 050 / 255; g = 070 / 255; b = 190 / 255; a = 1 },
    [5] = { r = 120 / 255; g = 070 / 255; b = 170 / 255; a = 1 },
    [6] = { r = 170 / 255; g = 100 / 255; b = 050 / 255; a = 1 },
}

function OnUseEnslavement(params)
    local found = false
    local info = itemLib.GetItemInfo(params.itemObject:GetId())
    if userMods.FromWString(info.name) == GTL('Seal') then
        for i, _ in pairs(EnsCfg) do
            if (userMods.FromWString(EnsCfg[i].Name) == userMods.FromWString(avatarName)) and (userMods.FromWString(EnsCfg[i].Shard) == userMods.FromWString(ShardName)) then
                EnsCfg[i].Quality = itemLib.GetQuality(params.itemObject:GetId()).quality
                EnsCfg[i].Date = common.GetMsFromDateTime(common.GetLocalDateTime()) + cooldowntable[itemLib.GetQuality(params.itemObject:GetId()).quality]
                EnsCfg[i].Show = true
                userMods.SetGlobalConfigSection("LabCalendar_EnsCfg", EnsCfg)
                found = true
                break
            end
        end
        if not found then
            EnsCfg[GetTableSize(EnsCfg) + 1] = {
                Name = avatarName,
                Shard = ShardName,
                Quality = itemLib.GetQuality(params.itemObject:GetId()).quality,
                Date = common.GetMsFromDateTime(common.GetLocalDateTime()) + cooldowntable[itemLib.GetQuality(params.itemObject:GetId()).quality],
                Show = true
            }
            EnsCfgId = EnsCfgId + 1
            userMods.SetGlobalConfigSection("LabCalendar_EnsCfg", EnsCfg)
        end
    end
end

function OnShowEnslavementPanel()
	itemtable = nil itemtable = {}
	DestroyEnsList()
    for k, v in pairs(EnsCfg) do
        local ItemSlot = WCD("EnsItemPanel", 'EPanel', nil, { alignX = 3, sizeX = 372, posX = 5, highPosX = 25, alignY = 3, sizeY = 30, posY = 0, highPosY = 0, }, true)
        local ShardName = WCD("EnsShard", "EShard", ItemSlot, { alignX = 0, sizeX = 50, posX = 0, highPosX = 0, alignY = 0, sizeY = 20, posY = 6, highPosY = 0, }, true)
        ShardName:SetFormat(userMods.ToWString('<header alignx = "center" fontsize="14" outline="1"><rs class="class"><tip_white><r name="value"/></tip_white></rs></header>'))
        ShardName:SetVal("value", v.Shard)
        local AvatarName = WCD("EnsName", "EName", ItemSlot, { alignX = 0, sizeX = 140, posX = 50, highPosX = 0, alignY = 0, sizeY = 20, posY = 6, highPosY = 0, }, true)
        AvatarName:SetFormat(userMods.ToWString('<header alignx = "center" fontsize="14" outline="1"><rs class="class"><tip_white><r name="value"/></tip_white></rs></header>'))
        AvatarName:SetVal("value", v.Name)
        local Timer = WCD("EnsTimer", "ETimer" .. k, ItemSlot, { alignX = 0, sizeX = 140, posX = 165, highPosX = 0, alignY = 0, sizeY = 20, posY = 6, highPosY = 0, }, true)
        Timer:SetFormat(userMods.ToWString('<header alignx = "center" fontsize="14" outline="1"><rs class="class"><tip_white><r name="value"/></tip_white></rs></header>'))
        Timer:SetVal("value", tostring(StartENSTimer(v.Date)))
        local Quality = WCD("EnsQuality", "EQuality", ItemSlot, { alignX = 0, sizeX = 30, posX = 290, highPosX = 0, alignY = 0, sizeY = 30, posY = 0, highPosY = 0, }, true)
        Quality:SetBackgroundColor(colors[v.Quality])
        local Delete = WCD("EnsButtonDelete", 'EnsClear_' .. k, ItemSlot, nil, true)
        table.insert(itemtable, { ItemSlot = ItemSlot })
        wtEnsContainer:PushFront(ItemSlot)
    end
end

function DestroyEnsList()
for _, wtChild in ipairs( wtEnsContainer:GetChildChecked("__Content", true):GetNamedChildren() ) do
wtChild:DestroyWidget()
end
end

function StartENSTimer(data)
    local cdend = data
    if (cdend - common.GetLocalDateTime().overallMs) >= 0 then
        local timem = common.GetDateTimeFromMs(cdend - common.GetLocalDateTime().overallMs)
        if timem then
            local strTime = tostring(timem.min) .. GTL("m")
            if timem.h > 0 then
                strTime = tostring(timem.h) .. GTL("h") .. strTime
            else
                if timem.h == 0 then
                    strTime = strTime .. tostring(timem.s) .. GTL("s")
                elseif timem.h == 0 and timem.min == 0 then
                    strTime = tostring(timem.s) .. GTL("s")
                end
            end
            return strTime
        end
    else
        return "++"
    end
end

function onAOPanelStart()
    local SetVal = { val1 = userMods.ToWString("    " .. tostring(eventCount)), class1 = eventColor }
    local wtI = mainForm:GetChildChecked("Icon", false)
    local params = { header = SetVal, ptype = "button", size = 50, icon = wtI }
    userMods.SendEvent("AOPANEL_SEND_ADDON", { name = "Labirint Calendar", sysName = "LabCalendar", param = params })
    wtShowHideButton:Show(false)
end

function onAOPanelChange(params)
    if params.unloading and params.name == "UserAddon/AOPanelMod" then
        wtShowHideButton:Show(true)
    end
end

function enableAOPanelIntegration(enable)
    IsAOPanelEnabled = enable
    SetConfig("EnableAOPanel", enable)
    if enable then
        onAOPanelStart()
    else
        wtShowHideButton:Show(true)
    end
end

function OnAOPanelButtonLeftClick(param)
    if DnD:IsDragging() then return end
    if param.sender == "LabCalendar" then 
		wtRowsPanel:Show(not wtRowsPanel:IsVisible()) wtEditLine:SetFocus(false) wtLabel:Show(true) wtEditLine:SetText(common.GetEmptyWString()) DestroyRowsList() CreateList()
	end
end

function OnAOPanelButtonRightClick(param)
    if param.sender == "LabCalendar" then wtEnslavementPanel:Show(not wtEnslavementPanel:IsVisible()) OnShowEnslavementPanel() end
end

function OnUpdateTimer()
    if not itemtable then OnShowEnslavementPanel() end
    for _, tab in pairs(itemtable) do
        for k, v in pairs(tab) do
            local children = v:GetNamedChildren()
            for i = 1, #children do
                local wtChild = children[i]
                local name = wtChild:GetName()
                if string.find(name, 'ETimer') then
                    local num = tonumber(string.sub(name, 7))
                    if tostring(StartENSTimer(EnsCfg[num].Date)) == "++" and (not wtInfo) and (EnsCfg[num].Show == true) then
                        EnsName = userMods.FromWString(EnsCfg[num].Name)
                        if config['ShowEnsReady'] then ShowInfo(3) end
                        EnsCfg[num].Show = false
                    else
                        wtChild:SetVal("value", tostring(StartENSTimer(EnsCfg[num].Date)))
                    end
                end
            end
        end
    end
end

function ReactionCBox( params )
if params.sender == "CheckboxRestart" then
	if wtCheck:GetVariant() == 0 then
        wtCheck:SetVariant(1)
        Cfg[cfgId].AutoRestart = true
    else
        wtCheck:SetVariant(0)
        Cfg[cfgId].AutoRestart = false
    end
    userMods.SetGlobalConfigSection("LabCalendar_Cfg", Cfg)
end
	local id = params.sender
if wtOption[id] then
	if wtOption[id].checkbox:GetVariant() == 0 then
		wtOption[id].checkbox:SetVariant(1)
		wtOption[id].value = true
	else
		wtOption[id].checkbox:SetVariant(0)
		wtOption[id].value = false
	end
	config[id] = wtOption[id].value
	end
	updateGUI()
end

function EventColor()
    if eventMy ~= 0 then
        eventCount = eventMy
    else
        eventCount = eventAll
    end
    eventColor = "LogColorBlack"
    if eventAll ~= 0 then
        eventColor = "LogColorBlue"
    end
    if eventMy ~= 0 then
        eventColor = "LogColorLightGreen"
    end
    if wtShowHideButton:IsVisible() then
        wtShowHideButton:SetVal("button_label", userMods.ToWString("    " .. tostring(eventCount)))
        wtShowHideButton:SetTextColor(nil, tablecolor[eventColor])
    else
        local SetVal = { val1 = userMods.ToWString("    " .. tostring(eventCount)), class1 = eventColor }
        userMods.SendEvent("AOPANEL_UPDATE_ADDON", { sysName = "LabCalendar", header = SetVal })
    end
end

function EditLineFocus(params)
    if params.sender == "EditLine" then
        if params.active then
            wtLabel:Show(false)
        end
        if not (params.active) and params.widget:GetString() == "" then
            wtLabel:Show(true) CreateList()
        end
    end
end

function EditLineEsc(params)
    if params.sender == params.widget:GetName() then
        params.widget:SetFocus(false)
    end
end

function EditLineChange(params)
    if params.sender == "EditLine" then
        local txt = params.widget:GetString()
        if txt ~= "" then
            ShowList(txt)
        else
            CreateList()
        end
    end
end

function ShowList(txt)
    local labnames = CloneTable(Lab)
    CreateList()
    for k, v in pairs(labnames) do
        if not string.find(userMods.FromWString(v.Name:ToUpper()), userMods.FromWString(userMods.ToWString(txt):ToUpper())) then
            for i = 1, GetTableSize(Rog) do
                if Rog[i].Id == labnames[k].Id then
                    if Rog[i].wtPanel then
                        Rog[i].wtPanel:DestroyWidget()
                        Rog[i].wtPanel = nil
                        break
                    end
                end
            end
        end
    end
end

function DestroyRowsList()
	for _, wtChild in ipairs( wtContainer:GetChildChecked("__Content", true):GetNamedChildren() ) do
	wtChild:DestroyWidget()
	end
end

function CreateList()
    eventMy = 0
    eventAll = 0
    eventCount = 0
    eventColor = "LogColorBlack"
	DestroyRowsList()
   -- wtContainer:RemoveItems()
    if Lab then
        Rog = nil
        Rog = {}
        local ldate = common.GetLocalDateTime()
        local now = math.floor((ldate.overallMs + timezone) / day) * day
        local a, b
        table.sort(Lab, function(a, b)
            -- consider all completed as Days-To-Complete === 0
            local dayA = (a.Date - now) / day
            if dayA < 0 then
                dayA = 0
            end

            local dayB = (b.Date - now) / day
            if dayB < 0 then
                dayB = 0
            end

            if (dayA < dayB) then
                return true
            elseif (dayA > dayB) then
                return false
            else
                if (userMods.FromWString(a.Name) < userMods.FromWString(b.Name)) then
                    return true
                elseif (userMods.FromWString(a.Name) > userMods.FromWString(b.Name)) then
                    return false
                else
                    -- if avatar is the same, sort by Type
                    if (a.Type < b.Type) then
                        return true
                    elseif (a.Type > b.Type) then
                        return false
                    else
                        if (a.Value > b.Value) then
                            return true
                        else
                            return false
                        end
                    end
                end
            end
        end)
        local num = 0
        if Lab then
            num = GetTableSize(Lab)
        end
        if num > 0 then
            for i = 1, num do
                AddRog(i)
            end
        end
    end
    EventColor()
end

function AstralUnlockChanged()
local сategories = matchMaking.GetEventCategories()
	if сategories then
		for i = 0, GetTableSize(сategories) - 1 do
			for k, v in pairs(matchMaking.GetEventsByCategory( сategories[i] )) do
			local name = userMods.FromWString(matchMaking.GetEventInfo(v).name:ToWString())
			if name:find(GTL('Layer')) and k >= 0 then
			CurrentUnlock = tonumber(name:sub(GTL('LayerFound'), name:find(":")-1))
				end
			end
		end
	end
end

function EnableAstral()
local сategories = matchMaking.GetEventCategories()
local active = false
	if сategories then
		for i = 0, GetTableSize(сategories) - 1 do
			for k, v in pairs(matchMaking.GetEventsByCategory( сategories[i] )) do
			if userMods.FromWString(matchMaking.GetEventInfo(v).name:ToWString()):find(GTL('Layer')) and k >= 0 then
			active = true
				end
			end
		end
	end
	return active
end

function UpdateTableKeys(table)
local NewTab = {}
for k, v in pairs(table) do 
	table.insert(NewTab, k)
		end
table.sort(NewTab)
for k, v in pairs(NewTab) do
	NewTab[k] = table[v]
	end
	return table
end

function GetCurrencies()
    --Получаем все категории альтернативных валют-------------------------------------------------------------
    local Categorys = avatar.GetCurrencyCategories()
	if Categorys then
    for i, CategoryId in pairs(Categorys) do
		local cat = CategoryId:GetInfo()
		--	if cat and cat.name then
		--	local CategoryName = userMods.FromWString(cat.name)
			--Получаем идентификаторы альтернативных валют игрока в категории---------------------------------------
			local Currencies = avatar.GetCategoryCurrencies(CategoryId)
			for j, CurrencyId in pairs(Currencies) do

				--Получаем информацию о валюте и записываем в таблицу-------------------------------------------------
				local info = CurrencyId:GetInfo()
				local values = avatar.GetCurrencyValue(CurrencyId)
				if info.name then
					if userMods.FromWString(info.name) == GTL('_Coral') then
						Cfg[cfgId].HaveCoral = values.value
						wtCoral:SetVal("val1", tostring(Cfg[cfgId].HaveCoral))
						if type(Cfg[cfgId].NeedCoral) == "number" then
							wtCoral:SetVal("val3", tostring((Cfg[cfgId].NeedCoral - Cfg[cfgId].HaveCoral) / 5))
						else
							wtCoral:SetVal("val3", "0")
						end
					elseif userMods.FromWString(info.name) == GTL('_Granit') then
						Cfg[cfgId].HaveGranit = values.value
						wtGranit:SetVal("val1", tostring(Cfg[cfgId].HaveGranit))
					elseif userMods.FromWString(info.name) == GTL('_Spark') then
						Cfg[cfgId].HaveIskra = values.value
						wtSpark:SetVal("val1", tostring(Cfg[cfgId].HaveIskra))
						wtSpark:SetVal("val2", tostring(values.maxValue))
					elseif userMods.FromWString(info.name) == GTL('Supplies') then
						Cfg[cfgId].HaveSupplies = values.value
						wtSupplies:SetVal("val1", common.FormatNumber(Cfg[cfgId].HaveSupplies, "[3]A5"))
					elseif userMods.FromWString(info.name) == GTL('PayToMerc') then
						Cfg[cfgId].HavePayToMerc = values.value
						wtPayToMerc:SetVal("val1", common.FormatNumber(Cfg[cfgId].HavePayToMerc, "[3]A5"))
					elseif userMods.FromWString(info.name) == GTL('Embrium') then
						Cfg[cfgId].HaveEmbrium = values.value
						wtEmbrium:SetVal("val1", tostring(Cfg[cfgId].HaveEmbrium))
		--				end
					end
                end
            end
        end
    end
end

function CheckList(timedate, name, shard)
if Lab then
for k, v in pairs(Lab) do
	if not v.Date then v.Date = timedate end
	if not v.Value then v.Value = 0 end
	if not v.Type then v.Type = "Gold" end
	if not v.Id then v.Id = timedate - 1542 end
	if not v.Name then v.Name = name end
	if not v.Shard then v.Shard = shard end
		end
	end
end

function EnablePlayersAllod()
local list = avatar.GetTeleportLocations()
local findallod = false
	if list then
		for k, v in pairs(list) do
		local locationInfo = avatar.GetTeleportLocationInfo( v )
		if locationInfo then
			if userMods.FromWString(locationInfo.name) == GTL('Private Allod') then
			findallod = true
				end
			end
		end
	end
	return findallod
end

function FixConfig()
if userMods.GetGlobalConfigSection('LabCalendar_Settings') then
    local cfg = userMods.GetGlobalConfigSection('LabCalendar_Settings')
		if GetTableSize(cfg) ~= GetTableSize(config) then
			cfg = config
			userMods.SetGlobalConfigSection("LabCalendar_Settings", cfg)
		end
	end
end

function Init()
	FixConfig()
    Lab = userMods.GetGlobalConfigSection("LabCalendar_Data")
    if userMods.GetGlobalConfigSection('LabCalendar_Settings') then
        config = userMods.GetGlobalConfigSection('LabCalendar_Settings')
    else
        userMods.SetGlobalConfigSection("LabCalendar_Settings", config)
    end
	if config['Rows'] > 11 then config['Rows'] = 11 userMods.SetGlobalConfigSection("LabCalendar_Settings", config) end
    SetWidth(wtRowsPanel, ListRows[config['Rows']])
    avatarId = avatar.GetId()
    avatarName = object.GetName(avatarId)
    ShardName = common.GetShortString(mission.GetShardName())
    local ldate = common.GetLocalDateTime()
    local now = math.floor((ldate.overallMs + timezone) / day) * day
	CheckList(now, avatarName, ShardName)
    CreateList()
    wtShowHideButton:SetVal("button_label", userMods.ToWString("    " .. tostring(eventCount)))
    wtShowHideButton:SetTextColor(nil, tablecolor[eventColor])

    if (not wtInfo) and (eventCount ~= 0) and config['ShowInfo'] then
        ShowInfo(0)
    end
    cfgId = 1
    if Cfg then
        cfgId = GetTableSize(Cfg) + 1
        for i = 1, GetTableSize(Cfg) do
            if userMods.FromWString(Cfg[i].Name) == userMods.FromWString(avatarName) and userMods.FromWString(Cfg[i].Shard) == userMods.FromWString(ShardName) then
                cfgId = i
                break
            end
        end
    end

    if not Cfg[cfgId] then
        Cfg[cfgId] = {}
    end
    if not Cfg[cfgId].Name then
        Cfg[cfgId].Name = avatarName
    end
    if not Cfg[cfgId].Shard then
        Cfg[cfgId].Shard = ShardName
    end --TODO fix: for i = 1, GetTableSize(Cfg) do
    if not Cfg[cfgId].NeedCoral then
        Cfg[cfgId].NeedCoral = 0
    end
    if Cfg[cfgId].AutoRestart == nil then
        Cfg[cfgId].AutoRestart = true
    end
	if not Cfg[cfgId].MainAllod then
        Cfg[cfgId].MainAllod = false
    end
	if not Cfg[cfgId].DefenderRank then
        Cfg[cfgId].DefenderRank = 0
    end
	if not Cfg[cfgId].UseBoxSettings then
        Cfg[cfgId].UseBoxSettings = 3
    end
	
	UpdateMainLabirint()
	
    EnsCfg = userMods.GetGlobalConfigSection("LabCalendar_EnsCfg") or {}
    EnsCfgId = 1

    --[[for _, num in pairs(EnsCfg) do
      if common.GetLocalDateTime().overallMs - num.Date > 0 then
      if (not wtInfo) then ShowInfo(3) end
      end
    end]]
	
		
    wtAutoRestart:SetVal("name", GTL('CFG_AutoRestart'))
    wtHeader:SetVal("name", common.GetAddonName())
    wtEnsHeader:SetVal("name", "EnslavementTimer")

    if (Cfg[cfgId].AutoRestart == true) then
        wtCheck:SetVariant(1)
    else
        wtCheck:SetVariant(0)
    end

    wtEmbrium:SetFormat(userMods.ToWString('<header alignx = "left" fontsize="12" outline="1"><rs class="class"><tip_white><r name="val1"/></tip_white></rs></header>'))
    wtEmbrium:SetVal("val1", '0')

    wtCoral:SetFormat(userMods.ToWString('<header alignx = "left" fontsize="12" outline="1"><rs class="class"><tip_white><r name="val1"/> / <r name="val2"/></tip_white> <tip_white>(<r name="val3"/>)</tip_white></rs></header>'))
    wtCoral:SetVal("val1", '0')
    wtCoral:SetVal("val3", '0')
    wtCoral:SetVal("val2", GTL(tostring(Cfg[cfgId].NeedCoral)))

    wtGranit:SetFormat(userMods.ToWString('<header alignx = "left" fontsize="12" outline="1"><rs class="class"><tip_white><r name="val1"/></tip_white></rs></header>'))
    wtGranit:SetVal("val1", '0')

    wtSpark:SetFormat(userMods.ToWString('<header alignx = "left" fontsize="12" outline="1"><rs class="class"><tip_white><r name="val1"/> / <r name="val2"/></tip_white></rs></header>'))
    wtSpark:SetVal("val1", '0')
    wtSpark:SetVal("val2", '0')

    wtSupplies:SetFormat(userMods.ToWString('<header alignx = "left" fontsize="12" outline="1"><rs class="class"><tip_white><r name="val1"/></tip_white></rs></header>'))
    wtSupplies:SetVal("val1", '0')

    wtPayToMerc:SetFormat(userMods.ToWString('<header alignx = "left" fontsize="12" outline="1"><rs class="class"><tip_white><r name="val1"/></tip_white></rs></header>'))
    wtPayToMerc:SetVal("val1", '0')

    IconCoral = WCD("Icon", 'IconCoral', wtCurPanel, { alignX = 0, posX = 20, highPosX = 0, sizeX = 20, alignY = 0, posY = 10, highPosY = 0, sizeY = 20 }, true)
    IconCoral:SetBackgroundTexture(common.GetAddonRelatedTextureGroup("Group01"):GetTexture("CORAL"))
    IconGranit = WCD("Icon", 'IconGranit', wtCurPanel, { alignX = 0, posX = 20, highPosX = 0, sizeX = 20, alignY = 0, posY = 30, highPosY = 0, sizeY = 20 }, true)
    IconGranit:SetBackgroundTexture(common.GetAddonRelatedTextureGroup("Group01"):GetTexture("GRANIT"))
    IconSpark = WCD("Icon", 'IconSpark', wtCurPanel, { alignX = 0, posX = 160, highPosX = 0, sizeX = 18, alignY = 0, posY = 10, highPosY = 0, sizeY = 30 }, true)
    IconSpark:SetBackgroundTexture(common.GetAddonRelatedTextureGroup("Group01"):GetTexture("SPARK"))
    IconSupplies = WCD("Icon", 'IconSupplies', wtCurPanel, { alignX = 0, posX = 160, highPosX = 0, sizeX = 18, alignY = 0, posY = 30, highPosY = 0, sizeY = 30 }, true)
    IconSupplies:SetBackgroundTexture(common.GetAddonRelatedTextureGroup("Group01"):GetTexture("SUPPLIES"))
    IconEmbrium = WCD("Icon", 'IconEmbrium', wtCurPanel, { alignX = 0, posX = 310, highPosX = 0, sizeX = 18, alignY = 0, posY = 10, highPosY = 0, sizeY = 30 }, true)
    IconEmbrium:SetBackgroundTexture(common.GetAddonRelatedTextureGroup("Group01"):GetTexture("EMBRIUM"))
    IconPayToMerc = WCD("Icon", 'IconPayToMerc', wtCurPanel, { alignX = 0, posX = 310, highPosX = 0, sizeX = 18, alignY = 0, posY = 30, highPosY = 0, sizeY = 30 }, true)
    IconPayToMerc:SetBackgroundTexture(common.GetAddonRelatedTextureGroup("Group01"):GetTexture("PAYTOMERC"))
	
	wtDefendersType = WCD("AutoRestart", "DefendersType", wtRowsPanel, {sizeX = 110, alignX = 1, highPosY = 10, highPosX = 70}, true)
	wtDefendersType:SetFormat(userMods.ToWString('<header alignx = "left" fontsize="16" outline="1"><rs class="class"><r name="name"/></rs></header>'))
    wtDefendersType:SetVal("name", GTL(AstralSector[Cfg[cfgId].DefenderRank]) )
    wtDefendersType:SetClassVal("class", colorclass[Cfg[cfgId].DefenderRank] )

    SortShard = WCD("SortButton", 'SortShard', wtRowsPanel, { alignX = 0, posX = 20, highPosX = 0, sizeX = 55, alignY = 0, posY = 120, highPosY = 20, sizeY = 30 }, true)
    SortName = WCD("SortButton", 'SortName', wtRowsPanel, { alignX = 0, posX = 71, highPosX = 0, sizeX = 145, alignY = 0, posY = 120, highPosY = 20, sizeY = 30 }, true)
    SortType = WCD("SortButton", 'SortType', wtRowsPanel, { alignX = 0, posX = 212, highPosX = 0, sizeX = 89, alignY = 0, posY = 120, highPosY = 20, sizeY = 30 }, true)
    SortValue = WCD("SortButton", 'SortValue', wtRowsPanel, { alignX = 0, posX = 297, highPosX = 0, sizeX = 60, alignY = 0, posY = 120, highPosY = 20, sizeY = 30 }, true)
    SortDays = WCD("SortButton", 'SortDays', wtRowsPanel, { alignX = 0, posX = 353, highPosX = 0, sizeX = 54, alignY = 0, posY = 120, highPosY = 20, sizeY = 30 }, true)
    SortDelete = WCD("SortButton", 'SortDelete', wtRowsPanel, { alignX = 0, posX = 403, highPosX = 0, sizeX = 55, alignY = 0, posY = 120, highPosY = 20, sizeY = 30 }, true)
	

    SortShard:SetVal('button_label', userMods.ToWString(GTL('Shard'))) SortShard:Enable(false)
    SortName:SetVal('button_label', userMods.ToWString(GTL('Name'))) SortName:Enable(false)
    SortType:SetVal('button_label', userMods.ToWString(GTL('Type'))) SortType:Enable(false)
    SortValue:SetVal('button_label', userMods.ToWString(GTL('Val'))) SortValue:Enable(false)
    SortDays:SetVal('button_label', userMods.ToWString(GTL('Days'))) SortDays:Enable(false)
    SortDelete:SetVal('button_label', userMods.ToWString(GTL('Del'))) SortDelete:Enable(false)

    SortEnsShard = WCD("SortButton", 'SortEnsShard', wtEnslavementPanel, { alignX = 0, posX = 20, highPosX = 0, sizeX = 55, alignY = 0, posY = 35, highPosY = 20, sizeY = 30 }, true) SortEnsShard:SetVal('button_label', userMods.ToWString(GTL('Shard'))) SortEnsShard:Enable(false)
    SortEnsName = WCD("SortButton", 'SortEnsName', wtEnslavementPanel, { alignX = 0, posX = 71, highPosX = 0, sizeX = 145, alignY = 0, posY = 35, highPosY = 20, sizeY = 30 }, true) SortEnsName:SetVal('button_label', userMods.ToWString(GTL('Name'))) SortEnsName:Enable(false)
    SortEnsTime = WCD("SortButton", 'SortType', wtEnslavementPanel, { alignX = 0, posX = 212, highPosX = 0, sizeX = 89, alignY = 0, posY = 35, highPosY = 20, sizeY = 30 }, true) SortEnsTime:SetVal('button_label', userMods.ToWString(GTL('Time'))) SortEnsTime:Enable(false)
    SortEnsQuality = WCD("SortButton", 'SortValue', wtEnslavementPanel, { alignX = 0, posX = 297, highPosX = 0, sizeX = 60, alignY = 0, posY = 35, highPosY = 20, sizeY = 30 }, true) SortEnsQuality:SetVal('button_label', userMods.ToWString(GTL('Quality'))) SortEnsQuality:Enable(false)
    SortEnsDelete = WCD("SortButton", 'SortEnsDelete', wtEnslavementPanel, { alignX = 0, posX = 353, highPosX = 0, sizeX = 55, alignY = 0, posY = 35, highPosY = 20, sizeY = 30 }, true) SortEnsDelete:SetVal('button_label', userMods.ToWString(GTL('Del'))) SortEnsDelete:Enable(false)

    wtLabel:SetVal("name", GTL('Search'))
    wtInfoLabirint:SetFormat(userMods.ToWString('<header alignx = "left" fontsize="14" outline="1"><rs class="class"><tip_yellow>' .. GTL('LabList') .. ': </tip_yellow><tip_white><r name="name"/></tip_white></rs></header>'))
    wtInfoLabirint:SetVal("name", "0")
    if Cfg then
        wtInfoLabirint:SetVal("name", tostring(GetTableSize(Cfg)))
    end

    common.RegisterReactionHandler(OpenBoxFromPost, "Usebox")
    common.RegisterReactionHandler(OnButtonClick, "ButtonReaction")
    common.RegisterReactionHandler(OnCornerCross, "cross_pressed")
    common.RegisterReactionHandler(OnButtonClickR, "ButtonReactionR")
    common.RegisterReactionHandler(EditLineChange, "Change")
    common.RegisterReactionHandler(EditLineFocus, "ChangeFocus")
    common.RegisterReactionHandler(EditLineEsc, "EditLineEscape")
	common.RegisterReactionHandler(ReactionCBox, "checkbox_pressed" )
	common.RegisterReactionHandler(listleftbuttonpressed, "list_leftbutton_pressed" )
	common.RegisterReactionHandler(listrightbuttonpressed, "list_rightbutton_pressed" )
    common.RegisterEventHandler(UpdateMainLabirint, "EVENT_AVATAR_CLIENT_ZONE_CHANGED")
	common.RegisterEventHandler(UpdateMainLabirint, "EVENT_OBJECT_BUFF_REMOVED", {objectId = avatar.GetId(), sysName = "main_maze_announce"})
    common.RegisterEventHandler(OnInteract, "EVENT_INTERACTION_STARTED")
    common.RegisterEventHandler(RemortListInfo, "EVENT_REMORT_LIST_GAINED")
    common.RegisterEventHandler(ClearWG, "EVENT_WIDGET_SHOW_CHANGED")
    common.RegisterEventHandler(OnUseEnslavement, "EVENT_AVATAR_ITEM_DROPPED", { actionType = "ENUM_TakeItemActionType_Spell" })
    common.RegisterEventHandler(OnUpdateTimer, "EVENT_SECOND_TIMER")
    common.RegisterEventHandler(OnCurrencyChanged, "EVENT_CURRENCY_VALUE_CHANGED")
    common.RegisterEventHandler(AnnounceCheckDefender, "EVENT_PLAYER_GEAR_SCORE_CHANGED", { playerId = avatarId })
	common.RegisterEventHandler(onEventAvatarItemTake, "EVENT_AVATAR_ITEM_TAKEN", { actionType = "ENUM_TakeItemActionType_Mail" })
    common.RegisterEventHandler(onAOPanelChange, "EVENT_ADDON_LOAD_STATE_CHANGED")
    common.RegisterEventHandler(onAOPanelStart, "AOPANEL_START")
    common.RegisterEventHandler(OnAOPanelButtonLeftClick, "AOPANEL_BUTTON_LEFT_CLICK")
    common.RegisterEventHandler(OnAOPanelButtonRightClick, "AOPANEL_BUTTON_RIGHT_CLICK")
	common.RegisterEventHandler(AstralUnlockChanged, "EVENT_MATCH_MAKING_EVENT_ADDED" )

    Cfg[cfgId].HaveCoral = 0
    Cfg[cfgId].HaveGranit = 0
    Cfg[cfgId].HaveIskra = 0
    Cfg[cfgId].HaveSupplies = 0
    Cfg[cfgId].HaveEmbrium = 0
    Cfg[cfgId].HavePayToMerc = 0
	config["WeeklyBoxSettings"] = Cfg[cfgId].UseBoxSettings
	matchMaking.ListenEvents( true )
	GetCurrencies()
	AnnounceNeedSupplies()
	AnnounceReadyHorn()
	AstralUnlockChanged()
	AnnounceCheckDefender()
    DnD.Init(wtShowHideButton, wtShowHideButton, true)
    DnD.Init(wtRowsPanel, wtRowsPanel, true)
    DnD.Init(wtOptionsPanel, wtOptionsPanel, true)
    DnD.Init(wtEnslavementPanel, wtEnslavementPanel, true)
end

--------------------------------------------------------------------------------
if (avatar.IsExist()) then
    Init()
else
    common.RegisterEventHandler(Init, "EVENT_AVATAR_CREATED")
end
--ver. 2.5.5