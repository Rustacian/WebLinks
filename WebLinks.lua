local function parseHyperlink(s)
	local link, type, data, text = string.match(s, "(|H(.+):(.+)|h(.+)|h)");
	return type, data, text, link;
end

local me = {
	name = "WebLinks",
	version = "0.9",
	slashCommand = "/web",
	enabled = true,
};

function me.OnLoad(this)
	this:RegisterEvent("VARIABLES_LOADED");
	_G[string.format("SLASH_%s1", me.name)] = me.slashCommand;
	SlashCmdList[me.name] = me.ExecuteSlashCommand;
end

function me.OnEvent()
	me.HookApi();
end

function me.HookApi()
	local originalClickEventHandler = _G["ChatFrame_OnHyperlinkClick"];
	_G["ChatFrame_OnHyperlinkClick"] = function(self, link, key)
		if me.enabled and key == "LBUTTON" then
			local linkType, linkData = parseHyperlink(link);
			if linkType == "web" then
				if IsShiftKeyDown() then
					ChatEdit_AddItemLink(link);
				elseif not IsCtrlKeyDown() then
					linkData = string.gsub(linkData, ";//", "://");
					--StaticPopupDialogs["OPEN_WEBROWER"].link = linkData;
					--StaticPopup_Show("OPEN_WEBROWER");
					GC_OpenWebRadio(linkData);
				end
				return;
			end
		end
		originalClickEventHandler(self, link, key);
	end;

	local originalAddMessage = DEFAULT_CHAT_FRAME.AddMessage;
	DEFAULT_CHAT_FRAME.AddMessage = function(self, txt, r, g, b)
		if me.enabled then
			txt = me.ConvertWebLinks(txt);
		end
		originalAddMessage(self, txt, r, g, b);
	end;

	-- hook other ChatFrames (thanks to tasquer)
	for i = 3, 10 do
		local frame = getglobal('ChatFrame' .. tostring(i))
		if frame then
			local orig = frame.AddMessage;
			
			frame.AddMessage = function(self, txt, r, g, b)
				if me.enabled then
					txt = me.ConvertWebLinks(txt);
				end
				orig(self, txt, r, g, b);
			end;
		end
	end
end

function me.ConvertWebLinks(txt)
	if txt == nil then return end;
	if string.find(txt, "://") then
		local newTxt = string.gsub(txt, "(%a+://[^%s]+)", "|Hweb:%1|h|cffC6896D[%1]|r|h");
		txt = string.gsub(newTxt, "web:(%a+)://", "web:%1;//");
	elseif string.find(txt, "www") then
		txt = string.gsub(txt, "(www[^%s]+)", "|Hweb:%1|h|cffC6896D[%1]|r|h");
	end
	return txt;
end

function me.Enable(enable)
	me.enabled = enable;
end

function me.ExecuteSlashCommand()
	if me.enabled then
		me.Enable(false);
		DEFAULT_CHAT_FRAME:AddMessage("WebLinks "..OFF);
	else
		me.Enable(true);
		DEFAULT_CHAT_FRAME:AddMessage("WebLinks "..ON);
	end
end

_G[me.name] = me;