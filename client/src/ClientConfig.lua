require("mgr.init");

ClientConfig = {} 
ClientConfig.ip = "39.108.68.45"
ClientConfig.port = 7001;

function ClientConfig.return_key()
    local layer = cc.Layer:create()
    --回调方法
    local function onrelease(code, event)
        if code == cc.KeyCode.KEY_BACK then
			print("你点击了返回键")
			local layout=  Utils.createPop(2, {ms="你确定退出游戏?", yesFun = function ( ... )
				cc.Director:getInstance():endToLua()	
			end});
			layout:setName("popwin")
			layer:addChild(layout); 
			layout:setPosition((display.width - layout.size.width)/2, (display.height - layout.size.height)/2);

			
        elseif code == cc.KeyCode.KEY_HOME then
            print("你点击了HOME键")
            -- cc.Director:getInstance():endToLua()
        end
    end

    --监听手机返回键
    local listener = cc.EventListenerKeyboard:create()
    listener:registerScriptHandler(onrelease, cc.Handler.EVENT_KEYBOARD_RELEASED)
    --lua中得回调，分清谁绑定，监听谁，事件类型是什么
    local eventDispatcher =layer:getEventDispatcher()
    eventDispatcher:addEventListenerWithSceneGraphPriority(listener,layer)
    return layer
end

