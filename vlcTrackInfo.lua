dir = nil
metaInfo = nil

function descriptor()
	return {
		title = "vlcTrackInfo",
		author = "AFB",
		shortdesc = "vlcTrackInfo",
		capabilities = {"input-listener"}
	}
end

function activate()
	vlc.msg.info("vlcTrackInfo activated")
	dir = vlc.config.userdatadir() .. "/lua/extensions/trackInfo.txt"
	vlc.msg.info(dir)
	getMetaInfo()
	rwFile("w")
end

function deactivate()
	vlc.msg.info("vlcTrackInfo deactivated")
end

function getMetaInfo()
	metaInfo = vlc.input.item():metas()
end

function rwFile(mode)
	local file
	local readContent
	
	if mode == "w" then
		file = io.open(dir,"w")	
		file:write(metaInfo["artist"] .. " - " .. metaInfo["title"])
	elseif mode == "r" then
		file = io.open(dir,"r")	
		readContent = file:read()
	end
	
	file:close()
	if readContent ~= nil then
		return readContent
	end
end

function meta_changed()
	getMetaInfo()
	local trackInfo = metaInfo["artist"] .. " - " .. metaInfo["title"]

	if rwFile("r") ~= trackInfo then
		rwFile("w")
		-- vlc.msg.info(rwFile("r"))
	end
end