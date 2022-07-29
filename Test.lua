local function serialize(o)
	local s = "";

	if o == nil then
		s = "(nil)";
	elseif type(o) == "number" or type(o) == "boolean" then
		s = tostring(o);
	elseif type(o) == "string" then
		s = string.format("%q", o);
	elseif type(o) == "function" then
		s = "(function)";
	elseif type(o) == "table" then
		s = "{";

		for k,v in pairs(o) do
			s = s..k.."="..serialize(v)..",";
		end

		s = s.."}";
	else
		error("cannot serialize a "..type(o));
	end

	return s;
end

local function printf(stringFormat, ...)
	print(string.format(stringFormat, ...));
end;

local function prints(tbl)
	print(serialize(tbl));
end

-- create RoM API stubs
SELECTED_CHAT_FRAME = {};
DEFAULT_CHAT_FRAME = SELECTED_CHAT_FRAME;
function SELECTED_CHAT_FRAME:AddMessage(s) print(s) end;

SlashCmdList = {};

StaticPopupDialogs = {};
StaticPopupDialogs["OPEN_WEBROWER"] = { link = "" };

function ChatFrame_OnHyperlinkClick()
end

function getglobal()
	return null;
end

function StaticPopup_Show(txt)
	printf("%s to %s", txt, StaticPopupDialogs["OPEN_WEBROWER"].link);
end

function IsShiftKeyDown()
	return false;
end

function IsCtrlKeyDown()
	return false;
end

dofile("WebLinks.lua");
WebLinks.HookApi();
-------------------------------

local webLink = "https://ts3.hoster.com?port=9987"
local tsLink = "ts3server://ts3.hoster.com?port=9987"
local wwwLink = "www.google.com"

local function processLink(link)
	local msg = string.format("click here %s now", link);
	msg = WebLinks.ConvertWebLinks(msg);
	print(msg);
	local _, gameLink = WebLinks.parseHyperlink(msg);
	print(gameLink);

	return gameLink
end


assert(webLink==processLink(webLink))
assert(tsLink==processLink(tsLink))
assert("https://"..wwwLink==processLink(wwwLink))


local notALink = "wwwHans"
local notALink2 = "www. adsf"

local function processText(text)
	local msg = WebLinks.ConvertWebLinks(text)
	print(msg)
	return msg
end

assert(processText(notALink)==notALink)
assert(processText(notALink2)==notALink2)