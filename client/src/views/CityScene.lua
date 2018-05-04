-- 主界面场景
local CityScene = class("CityScene", cc.load("mvc").ViewBase)

local function getHotList( ... )
    -- body
    local result = {}
    for i,v in ipairs(MyInfo.roomList)do
        if tonumber(v.recommend) == 2 then 
            table.insert(result, v);
        end 
    end 

    return result;
end

function CityScene:onCreate()
    -- add background image
    print("22222222222");
    local bg = display.newSprite("city/bg.jpg")
    local bgSize = bg:getContentSize();
    local scalex = display.width/bgSize.width
    local scaley = display.height/bgSize.height

    local scale = math.max(scalex, scaley) 
    bg:setScale(scale) 
    bg:setAnchorPoint(cc.p(0,0));
    self:addChild(bg)

    -- add title_bg
    local title_bg = display.newSprite("city/top.jpg");
    local title_bgsize = title_bg:getContentSize()
    title_bg:setAnchorPoint(cc.p(0,1));
    title_bg:setPosition(0, display.height);
    title_bg:setScaleX(display.width/title_bgsize.width)
    self:addChild(title_bg); 

    -- add title
    local title = cc.Label:createWithSystemFont("红信", "Arial", 40)
    title:setPosition(display.cx, display.height - title_bgsize.height/2)
    title:enableShadow(cc.c4b(0, 0, 0), cc.size(1,1), 1) -- 启动阴影 
    title:enableOutline(cc.c4b(0,0,0), 1) -- 启动描边
    self:addChild(title); 


    -- add 公告 
    local  gg_str = "即将开服，充值有大礼包免费领！！！";
    local gg_label = cc.Label:createWithSystemFont(gg_str,"Arial", 30);
    gg_label:setTextColor(cc.c3b(0, 0, 0))
    gg_label:setAnchorPoint(0, 0); 
    local gg_size = gg_label:getContentSize();
    local gg_y =  display.height - title_bgsize.height - 35
    gg_label:setPosition(display.width, gg_y);
    self:addChild(gg_label)

    --一直循环移动
    local move = cc.MoveTo:create(5, cc.p(-gg_size.width, gg_y));
    local delay = cc.DelayTime:create(2) 
    local seq = cc.Sequence:create(move, delay, cc.Place:create(cc.p(display.width, gg_y)));
    gg_label:runAction(cc.RepeatForever:create(seq))

    -- add line
    local start_y = display.height - title_bgsize.height - 40
    local line = display.newSprite("city/line.png")
    local size = line:getContentSize() 
    line:setScaleX(display.width/ size.width) 
    line:setPosition(display.cx, start_y);
    self:addChild(line) 

    start_y = start_y - 140;
    -- add ScrollView 滚动区域 
    local ScrollView_2 = ccui.ScrollView:create()
    ScrollView_2:setBounceEnabled(true)
    ScrollView_2:setDirection(2)
    ScrollView_2:setInnerContainerSize({width = display.width, height = 150})
    ScrollView_2:ignoreContentAdaptWithSize(false)
    ScrollView_2:setClippingEnabled(true)
    ScrollView_2:setBackGroundColorType(1)
    ScrollView_2:setBackGroundColor({r = 255, g = 150, b = 100})
    ScrollView_2:setBackGroundColorOpacity(0)
    ScrollView_2:setLayoutComponentEnabled(true)
    ScrollView_2:setCascadeColorEnabled(true)
    ScrollView_2:setCascadeOpacityEnabled(true)
    ScrollView_2:setPosition(0, start_y)
    local layout = ccui.LayoutComponent:bindLayoutComponent(ScrollView_2)
    layout:setPositionPercentX(0.7800)
    layout:setPositionPercentY(0.4464)
    layout:setPercentWidth(0.2083)
    layout:setPercentHeight(0.3125)
    layout:setSize({width = display.width, height = 150})
    layout:setLeftMargin(748.8054)
    layout:setRightMargin(11.1946)
    layout:setTopMargin(154.3036)
    layout:setBottomMargin(285.6964)
    self:addChild(ScrollView_2)

    -- 添加滚动元素 
    local hotList = getHotList();
    local itemsize
    local offx = 70; 
    local startx = 15
    for i,v in ipairs(hotList)do 
        local item = self:createHotItem(v); 
        if not itemsize then 
            itemsize = item.size;
        end 
        item:setPosition(startx + (i-1) * (itemsize.width + offx), 0)
        ScrollView_2:addChild(item)
    end 

    local scrollsize = ScrollView_2:getContentSize();
    local width = scrollsize.width;
    if itemsize then 
        local realwidth = (itemsize.width + offx) * #hotList
        if realwidth > width then 
            width = realwidth; 
        end 
    end 

    ScrollView_2:setInnerContainerSize(cc.size(width, scrollsize.height)); 

    -- center
    local bottom_height = 85
    -- add ScrollView 滚动区域 
    local center_height = start_y - bottom_height - 5
    local ScrollView_2 = ccui.ScrollView:create()
    ScrollView_2:setBounceEnabled(true)
    ScrollView_2:setDirection(1)
    ScrollView_2:setInnerContainerSize({width = display.width, height = center_height})
    ScrollView_2:ignoreContentAdaptWithSize(false)
    ScrollView_2:setClippingEnabled(true)
    ScrollView_2:setBackGroundColorType(1)
    ScrollView_2:setBackGroundColor({r = 255, g = 150, b = 100})
    ScrollView_2:setBackGroundColorOpacity(0)
    ScrollView_2:setLayoutComponentEnabled(true)
    ScrollView_2:setCascadeColorEnabled(true)
    ScrollView_2:setCascadeOpacityEnabled(true)
    ScrollView_2:setPosition(0, bottom_height)
    local layout = ccui.LayoutComponent:bindLayoutComponent(ScrollView_2)
    layout:setPositionPercentX(0.7800)
    layout:setPositionPercentY(0.4464)
    layout:setPercentWidth(0.2083)
    layout:setPercentHeight(0.3125)
    layout:setSize({width = display.width, height = center_height})
    layout:setLeftMargin(748.8054)
    layout:setRightMargin(11.1946)
    layout:setTopMargin(154.3036)
    layout:setBottomMargin(285.6964)
    self:addChild(ScrollView_2)

    -- 添加滚动元素 
    local listdata = MyInfo.roomList 
    local itemsize
    local offy = 0; 
    for i,v in ipairs(listdata)do 
        local item = self:createCenterItem(v); 
        if not itemsize then 
            itemsize = item.size;
        end
        ScrollView_2:addChild(item)
    end 

    local scrollsize = ScrollView_2:getContentSize();
    local height = scrollsize.height;

    if itemsize then 
        local realheight = (itemsize.height + offy) * # listdata
        if realheight > height then 
            height = realheight ;
        end 

        for i,v in ipairs(ScrollView_2:getChildren())do 
            v:setPosition(0, height - i * itemsize.height); 
        end
    end 
    ScrollView_2:setInnerContainerSize(cc.size(display.width, height)); 

    -- bottom
    local bottom_bg = display.newSprite("city/bottom_bg.jpg");
    self:addChild(bottom_bg)
    local size = bottom_bg:getContentSize(); 
    bottom_bg:setScaleX(display.width/ size.width);
    bottom_bg:setAnchorPoint(cc.p(0,0))
    bottom_bg:setPosition(0, 0)

    local offy = 40
    local offx = 70
    --说明
    local sm_btn = ccui.Button:create()
    sm_btn:loadTextureNormal("city/sm.png")
    -- sm_btn:loadTexturePressed("city/sm.png")
    sm_btn:addClickEventListener(function ( ... )
        require("app.MyApp"):create():enterScene("DescScene", "MOVEINR");
    end)
    sm_btn:setPosition(offx, offy)
    self:addChild(sm_btn); 

    --客服 
    local kf_btn = ccui.Button:create() 
    kf_btn:loadTextureNormal("city/kf.png"); 
    -- kf_btn:loadTexturePressed("city/kf.png"); 
    kf_btn:addClickEventListener(function ( ... )
        -- body
        print("暂未开放")
    end)
    kf_btn:setPosition(display.width/2, offy)
    self:addChild(kf_btn);

    -- 个人中心 
    local me_btn = ccui.Button:create(); 
    me_btn:loadTextureNormal("city/me.png");
    -- me_btn:loadTexturePressed("city/me.png");
    me_btn:addClickEventListener(function ( ... )
        -- body
        require("app.MyApp"):create():enterScene("SetUpScene", "MOVEINR");
    end)
    me_btn:setPosition(display.width - offx, offy)
    self:addChild(me_btn);
end

-- 绘制图标
-- @param data = {id:, name, desc, upperLimit, playerNum, type:类型}

function CityScene:createHotItem( data )
    -- body
    local layout = ccui.Layout:create()
    layout:setAnchorPoint(cc.p(0, 0));
    

    local bgimg = "city/tbbg1.png";
    if data.type == 3 then 
        bgimg = "city/tbbg2.png";
    end  

    -- 背景
    local bg = display.newSprite(bgimg); 
    local bgSize = bg:getContentSize()
    bg:setAnchorPoint(cc.p(0,0))
    layout:addChild(bg); 
    bg:setPosition(0,  30)

    local _height = bgSize.height + 30 -- 背景高度 + 文字高度  

    layout.size  = cc.size(bgSize.width, _height);
    layout:setContentSize(layout.size); 


    -- 图标
    local item = ccui.Button:create()
    item:loadTextureNormal("icon/" .. data.icon .. ".png");
    item:addClickEventListener(function ( ... )
        -- body
        -- 进入房间
        self:enterRoom(data);
    end)
    local itemsize = item:getContentSize()

    local x,y = bg:getPosition();

    item:setPosition(x + bgSize.width/2, y + bgSize.height/2)
    layout:addChild(item)

    -- 名称
    local nm = cc.Label:createWithSystemFont(data.name, "Arial", 25)
    nm:setAnchorPoint(0.5,0)
    nm:setPosition(x + bgSize.width/2, 0)
    nm:setTextColor(cc.c3b(0, 0,0));
    layout:addChild(nm);
    return layout;
end


-- 绘制centerItem
-- @param data = {id:, type:类型}
function CityScene:createCenterItem( data )
    -- body
    local layout = ccui.Layout:create()
    layout:setAnchorPoint(cc.p(0, 0));
    local bg_height = 133; 

    -- line
    local line = display.newSprite("city/line.png")
    local size = line:getContentSize() 
    line:setScaleX(display.width/ size.width) 
    line:setPosition(display.cx,  bg_height);
    layout:addChild(line) 
    --背景 
    local bg = display.newSprite("city/bg.jpg");
    local bgSize = bg:getContentSize();
    
    local scalex = display.width/ bgSize.width;


    local bg_btn = ccui.Button:create("city/bg.jpg", "city/item_bg.jpg"); 
    bg_btn:addClickEventListener(function ( ... )
        -- body
        self:enterRoom(data)
    end)
    
    bg_btn:setAnchorPoint(cc.p(0,0))
    bg_btn:setScaleX(scalex)
    layout:addChild(bg_btn); 

    -- 图标
    local bgimg = "city/tbbg1.png";
    if data.type == 3 then 
        bgimg = "city/tbbg2.png";
    end  

    -- 背景
    local bg = display.newSprite(bgimg); 
    local bgSize = bg:getContentSize()
    bg:setAnchorPoint(cc.p(0,0)) 

    -- 图标
    local tb_offx = 15
    local tb = display.newSprite("icon/" .. data.icon  .. ".png");
    bg:addChild(tb); 
    local tbsize = tb:getContentSize() 
    tb:setPosition(bgSize.width/2, bgSize.height/2)
    
    bg:setPosition(tb_offx, (bg_height - bgSize.height)/2)
    layout:addChild(bg);

    -- 名称
    local offy = 30
    local nm = cc.Label:createWithSystemFont(data.name, "Arial", 28)
    nm:setTextColor(cc.c3b(0, 0, 0));
    nm:setAnchorPoint(0,1)
    nm:setPosition(tb_offx + tbsize.width + 30,  bg_height - offy)
    layout:addChild(nm); 


    -- des
    local des = cc.Label:createWithSystemFont(data.desc, "Arial", 30)
    des:setTextColor(cc.c3b(0, 0, 0));
    des:setAnchorPoint(0,0)
    des:setPosition(tb_offx + tbsize.width + 30,  offy)
    layout:addChild(des); 


    --RS 
    local person = cc.Label:createWithSystemFont("场内人数: " .. data.playerNum .. "/" .. data.upperLimit,  "Arial", 28)
    person:setTextColor(cc.c3b(0, 0, 0));
    person:setAnchorPoint(1,1)
    person:setPosition(display.width - 30,  bg_height - offy)
    layout:addChild(person); 

    local width = display.width
    local height = bg_height;
    local layoutsize = cc.size(width, height)
    layout.size = layoutsize;
    layout:setContentSize(layoutsize)
    return layout;
end

function CityScene:enterRoom( _data)
    -- body

    local param =  {id= _data.id}
    MsgMgr.sendData({cmd = 20001, msg =param}); 
    -- 进入房间
    MsgMgr.waitMsg(20001,function (data)
        -- body
        if data.code == 0 then  -- 进入房间成功
            MyInfo.roomData = data.data
            MyInfo.roomID = _data.id
            require("app.MyApp"):create():enterScene("RedPackageScene", "MOVEINR");
        else
            CodeRes.showTip(data.code); 
            print("进入房间失败, data.code = ", data.code);
        end 
    end)
end
return CityScene
