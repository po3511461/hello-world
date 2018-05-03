local network = require("framework.network")

Utils = {}; 
function Utils.createPop(_type, params)
	_type = _type or 1; -- 1:确认框（默认），2:询问框  
	local yesstr = params.yesstr or "确 认"
	local nostr = params.nostr or "取 消"
	local layout = ccui.Layout:create(); 
	local _bg = cc.LayerColor:create(cc.c4b(0,0,0, 255 * 50 /100),display.width, display.height);
    layout:addChild(_bg)

	local bg = display.newSprite("pop/bg.jpg");
	layout:addChild(bg);


	layout:setTouchEnabled(true)
	bg:setAnchorPoint(cc.p(0,0));
	local bgSize = bg:getContentSize();
	bg:setPosition((display.width - bgSize.width)/2,(display.height - bgSize.height)/2);
	local laysize = cc.size(display.width, display.height);
	layout.size = laysize;
	layout:setContentSize(laysize);
	layout:setAnchorPoint(cc.p(0,0))

	


	local title = cc.Label:createWithSystemFont("提示", "Arial", 40);
	bg:addChild(title)
	title:setPosition(bgSize.width/2, bgSize.height - 32)

	local ms = cc.Label:createWithSystemFont(params.ms, "Arial", 40) 
	ms:setTextColor(cc.c3b(0,0,0));
	local mssize = ms:getContentSize();
	local maxline = bgSize.width - 30;
	if mssize.width > maxline then 
		ms:setWidth(maxline);
		ms:setMaxLineWidth(maxline)
	else 
		maxline = mssize.width
	end

	ms:setPosition((bgSize.width - maxline)/2,  bgSize.height/2 + 20);
	ms:setTextColor(cc.c3b(255, 0, 0))
	ms:setAnchorPoint(0, 1) 
	bg:addChild(ms)

	if _type == 1 then
		local yes_btn = ccui.Button:create("pop/yes.png");
		yes_btn:setTitleFontSize(30);
		yes_btn:setTitleText(yesstr); 
		btnsize = yes_btn:getContentSize();
		yes_btn:setPosition(bgSize.width/2, btnsize.height/2 + 20);
		yes_btn:addClickEventListener(function ( ... )
			-- body
			if params.yesFun then 
				params.yesFun();
			end

			layout:removeSelf();
		end)

		bg:addChild(yes_btn);
	elseif _type == 2 then 

		local yes_btn = ccui.Button:create("pop/yes.png");
		yes_btn:setTitleFontSize(30);
		yes_btn:setTitleText(yesstr); 
		local btnsize = yes_btn:getContentSize();
		yes_btn:setPosition(bgSize.width/2 - btnsize.width/2 - 40, btnsize.height/2 + 20);
		yes_btn:addClickEventListener(function ( ... )
			-- body
			if params.yesFun then 
				params.yesFun();
			end 
			layout:removeSelf();
		end)

		bg:addChild(yes_btn);


		local no_btn = ccui.Button:create("pop/no.png");
		no_btn:setTitleFontSize(30);
		no_btn:setTitleText(nostr); 
		local btnsize = no_btn:getContentSize();
		no_btn:setPosition(bgSize.width/2 + btnsize.width/2 + 40, btnsize.height/2 + 20);
		no_btn:addClickEventListener(function ( ... )
			-- body
			if params.noFun then 
				params.noFun();
			end
			layout:removeSelf();
		end)

		bg:addChild(no_btn);
	end 
	return layout 
end 

-- 延迟回调
function Utils.setTimeout(node, time, callback)
	-- body
	return performWithDelay(node, callback, time)
end

function Utils.getJb(num)
	-- body
	local num = tonumber(num) or 0
	if num >= 10000 then 
		num = math.floor(num/10000) .. "万";  
	end 

	return num;
end


--等待面板
function Utils.createWaitLayer( ... )
	-- body
	local layout = ccui.Layout:create()
    layout:setAnchorPoint(cc.p(0,0))
    layout:setContentSize(cc.size(display.width, display.height));
    layout:setPosition(0, 0);
    layout:setTouchEnabled(true);
    layout:setName("zd_Layer");

    local bg = cc.LayerColor:create(cc.c4b(0,0,0, 255 * 70 /100),display.width, display.height);
    layout:addChild(bg)
    bg:hide();
    layout.bg = bg;
    local zd = display.newSprite("city/zd_bg.png");
    layout:addChild(zd); 
    local zdsize = zd:getContentSize();
    zd:setPosition(display.cx, display.cy);
    zd:runAction(cc.RepeatForever:create(cc.RotateBy:create(1, 360)));

    zd:hide();
    layout.zd = zd;
    -- 添加转圈
   	return layout
end
function Utils.requestHttp( url, name, callback, sendStr )
	-- body
	local xhr = cc.XMLHttpRequest:new();
    xhr._urlFileName = name;
    xhr.responseType = cc.XMLHTTPREQUEST_RESPONSE_JSON;
    local url_addr = url..name.. "?" .. sendStr;
    print("请求的url地址：", url_addr);
    xhr:open("GET", url_addr)
    local function onComplete()
        print("http请求返回状态：readyState：", xhr.readyState , "， status：", xhr.status);
        if callback then 
            local result = {}
            result.readyState = xhr.readyState; 
            result.status = xhr.status
            result.response = xhr.response;
            callback(result);
        end 
    end
    xhr:registerScriptHandler(onComplete);
    xhr:send();
end