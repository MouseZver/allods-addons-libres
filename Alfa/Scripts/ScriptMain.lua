--------------------------------------------------------------------------------
-- GLOBAL		
--------------------------------------------------------------------------------
Global( "onEvent", {} )
Global( "KRI_BUY_TMP", {} )
--------------------------------------------------------------------------------
-- FUNCTIONS
--------------------------------------------------------------------------------
function RegisterEventHandlers( handlers )
	for event, handler in pairs( handlers ) do
		common.RegisterEventHandler( handler, event )
	end
end

function OnAOPanelStart()
  local SetVal = { val1 = userMods.ToWString( " A" ), class1 = "Friendly" }
  local params = { header = SetVal, ptype = 'button', size = 30 } 
  userMods.SendEvent( 'AOPANEL_SEND_ADDON', { name = common.GetAddonName(), sysName = common.GetAddonName(), param = params } )
end

function GetCurrencyRates()
	if currencyExchange.IsServiceActive() then
        local section = {
            --shard = userMods.FromWString(mission.GetShardName()),
            kri_buy = currencyExchange.CalcBuyRate(),
            kri_sell = currencyExchange.CalcSellRate(),
			kri_shard = mission.GetShardName(),
            kri_time = mission.GetGlobalDateTimeMs()
        }
		
		if KRI_BUY_TMP ~= section.kri_buy then
			KRI_BUY_TMP = section.kri_buy
			userMods.SetGlobalConfigSection( "CrystalRates", section )
		end
		
		--common.LogInfo("", tostring(mission.GetGlobalDateTimeMs()) )
    end
end


function chatMessage( params )
	local section = {
		chat_sender = userMods.FromWString(params.sender), -- Автор текста
		chat_shard = userMods.FromWString(params.shard),
		--chat_senderUniqueId = tostring(params.senderUniqueId),
		chat_chatType = tostring(params.chatType), -- тип сообщения Integer 
		chat_isEcho = tostring(params.isEcho),
		chat_msg = userMods.FromWString(params.msg), -- текст сообщения
		chat_spamWeight = tostring(params.spamWeight),
		chat_time = mission.GetGlobalDateTimeMs()
	}
	
	--common.LogInfo("", userMods.FromWString(params.msg) )
	
	userMods.SetGlobalConfigSection( "ChatMessage", section )
end

-- Передача прав лидера игроку сообщением в группе "!!"
function setLeader( params )
	if ( group.IsExist() and group.IsLeader( nil ) and params.chatType == 1 and not params.isEcho and userMods.FromWString( params.msg ) == "!!" ) then
		-- Передать лидера игроку
		group.SetLeader( params.senderUniqueId )
	end
end

-- Приглашение в группу
function groupInvite( params )
	if ( group.CanInvite() and params.chatType == 0 and not params.isEcho and userMods.FromWString( params.msg ) == "!!" ) then
		--local name = userMods.ToWString(params.sender)
		local name = object.GetName(params.senderId)
		group.InviteByName( name )
		--group.Invite( params.senderUniqueId )
	end
end
--------------------------------------------------------------------------------
-- EVENT HANDLERS	
--------------------------------------------------------------------------------
onEvent[ "EVENT_AVATAR_CREATED" ] = function()
	GetCurrencyRates()
end
onEvent[ "EVENT_SECOND_TIMER" ] = function()
	GetCurrencyRates()
	
	--local unitId = avatar.GetId()
	--local factionId = unit.GetFactionId( unitId )
	--common.LogInfo( "Unit faction: ", userMods.FromWString( factionId:GetInfo().name ) == "лига" and "l" or "i" )
end

-- sender: WString - имя отправителя (игрока или моба)
-- shard: WString - название сервера отправителя
-- senderUniqueId: UniqueId or nil - уникальный идентификатор персонажа-отправителя
-- senderId: ObjectId - идентификатор персонажа-отправителя или nil, если данная информация недоступна (например, если игрок не отреплицирован)
-- chatType: number (enum CHAT_TYPE_...) - тип сообщения
-- isEcho: boolean - является ли сообщение эхом

-- Для CHAT_TYPE_WHISPER (только для эха):
-- recipient:  WString - имя получателя

-- isAlive: boolean - жив игрок (может действовать) или нет (мертв или в числилище)

-- msg: WString - текст сообщения
-- spamWeight: number (integer) - спам-вес сообщения. если меньше 100, то не спам, иначе - спам
onEvent[ "EVENT_CHAT_MESSAGE" ] = function( param )
	chatMessage( param )
	setLeader( param )
	groupInvite( param )
end

onEvent[ "EVENT_GROUP_INVITE" ] = function()
	if group.GetInviteInfo().invited then
		group.Accept()
	end
end

onEvent[ "EVENT_GROUP_CHANGED" ] = function()
	if ( group.IsExist() and group.IsLeader( nil ) ) then
		loot.SetMinItemQualityForLootScheme( ITEM_QUALITY_DRAGON )
	end
end

onEvent[ "AOPANEL_START" ] = function()
	OnAOPanelStart()
end

--[[onEvent[ "EVENT_GROUP_INVITE_END" ] = function()
	if ( group.IsExist() and group.IsLeader( nil ) ) then
		loot.SetMinItemQualityForLootScheme( ITEM_QUALITY_DRAGON )
	end
end]]
--------------------------------------------------------------------------------
-- INITIALIZATION
--------------------------------------------------------------------------------
function Init()
    RegisterEventHandlers( onEvent )
	--common.RegisterEventHandler( chatMessage, "EVENT_CHAT_MESSAGE" )
	--common.RegisterEventHandler( OnAlchemyReactionFinished, "EVENT_ALCHEMY_REACTION_FINISHED")
	if avatar.IsExist() then 
		onEvent[ "EVENT_AVATAR_CREATED" ]() 
	end
end
--------------------------------------------------------------------------------
Init()
--------------------------------------------------------------------------------