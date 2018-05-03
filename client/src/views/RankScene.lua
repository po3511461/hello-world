local RankScene = class("RankScene", cc.load("mvc").ViewBase)

function RankScene:onCreate()
    -- add background image
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
    local title = cc.Label:createWithSystemFont("财富排行榜", "Arial", 40)
    title:setPosition(display.cx, display.height - title_bgsize.height/2)
    title:enableShadow(cc.c4b(0, 0, 0), cc.size(1,1), 1) -- 启动阴影 
    title:enableOutline(cc.c4b(0,0,0), 1) -- 启动描边
    self:addChild(title); 

    local fh_wz = ccui.Text:create("< 我的", "Arial" , 40)
    local wz_size = fh_wz:getContentSize();
    local downLocation;
    fh_wz:addTouchEventListener(function(sender, eventType)
        if eventType == ccui.TouchEventType.began then
            downLocation = sender:getTouchMovePosition()
            move = false

            sender:setOpacity(150)
        elseif eventType == ccui.TouchEventType.ended then
            sender:setOpacity(255)
            if not move then
                require("app.MyApp"):create():enterScene("SetUpScene", "moveinl");
            end     
        elseif eventType == ccui.TouchEventType.moved then
            local p1 = sender:getTouchMovePosition()
            if downLocation  and  (math.abs(downLocation.x-p1.x) > wz_size.width or  math.abs(downLocation.y-p1.y) >wz_size.height ) then
                 move = true
                 sender:setOpacity(255)
            else 
                sender:setOpacity(150)
            end 
        elseif eventType == ccui.TouchEventType.cancel then 
            move = true
            sender:setOpacity(255)
        end
    end)

    fh_wz:setTouchEnabled(true);
    fh_wz:setAnchorPoint(cc.p(0, 0.5))
    fh_wz:setPosition(5, display.height - title_bgsize.height/2)
    self:addChild(fh_wz); 


    --info
    local start_y = display.height -  title_bgsize.height
   	-- center
    local bottom_height = 20
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
    local listdata = MyInfo.rankList.playerGoldInfo or {};
    table.sort( listdata, function (a,b )
        -- body
        return a.goldRank < b.goldRank;
    end )
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

end


-- 绘制centerItem
-- @param data = {pid:, nickName:名称， goldRank=， gold, introduction=描述}
function RankScene:createCenterItem( data )
    -- body
    local layout = ccui.Layout:create()
    layout:setAnchorPoint(cc.p(0, 0));
    local bg_height = 133; 

    -- line
    local line = display.newSprite("rank/line.png")
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
        self:createTip(data);
    end)
    
    bg_btn:setAnchorPoint(cc.p(0,0))
    bg_btn:setScaleX(scalex)
    layout:addChild(bg_btn); 

    -- 排名
    local img 
    if data.goldRank == 1 then 
        img = "rank/one.png";
    elseif data.goldRank == 2 then 
        img = "rank/two.png";
    elseif data.goldRank == 3 then 
        img = "rank/three.png";
    end  

    local offx = 50
    local rk
    if img then 
        rk = display.newSprite(img)
    else
        rk = cc.Label:createWithSystemFont(data.goldRank, "Arial", 30);
        rk:setTextColor(cc.c3b(0,0,0)); 
    end 
    rk:setPosition(offx, bgSize.height/2)
    layout:addChild(rk);

    -- 图标
    local tb_offx = 90
    local tb =  display.newSprite("head/" .. data.playerSimpleInfo.avatar .. ".jpg");
    local tbsize = tb:getContentSize();
    layout:addChild(tb)
    tb:setPosition(tb_offx + tbsize.width/2, bgSize.height/2)


    -- 名称
    local offy = 30
    local nm = cc.Label:createWithSystemFont(data.playerSimpleInfo.nickName, "Arial", 30)
    nm:setTextColor(cc.c3b(0, 0, 0));
    nm:setAnchorPoint(0,1)
    nm:setPosition(tb_offx + tbsize.width + 30,  bg_height - offy)
    layout:addChild(nm); 


    local jb = cc.Label:createWithSystemFont("拥有金币 : " .. data.gold, "Arial", 25)
    jb:setTextColor(cc.c3b(0, 0, 0));
    jb:setAnchorPoint(0,1)
    local jbSize = jb:getContentSize()
    jb:setPosition(tb_offx + tbsize.width + 30,  bg_height/2)
    layout:addChild(jb); 

    -- des
    local des = cc.Label:createWithSystemFont("个性签名 : " .. data.playerSimpleInfo.introduction, "Arial", 18)
    des:setTextColor(cc.c3b(0, 0, 0));
    des:setAnchorPoint(0,0)
    des:setPosition(tb_offx + tbsize.width + 30,  17)
    layout:addChild(des); 


    local layoutsize = cc.size(display.width, bg_height)
    layout.size = layoutsize;
    layout:setContentSize(layoutsize)
    return layout;
end

function RankScene:createTip(data)
    -- body
    -- 打开萌版
    local layout = ccui.Layout:create();
    layout:setTouchEnabled(true);
    local bg = cc.LayerColor:create(cc.c4b(0, 0, 0, 160), display.width, display.height)
    -- bg:setPosition();
    layout:addChild(bg);
    layout:setContentSize(cc.size(display.width, display.height));

        
    local tip = display.newSprite("rank/tip.jpg");
    local tipSize = tip:getContentSize()
    tip:setPosition(display.cx, display.cy + 20)
    layout:addChild(tip);


    local title = cc.Label:createWithSystemFont("个人信息", "Arial",  40);
    tip:addChild(title)
    local titlesize = title:getContentSize()
    title:setPosition(tipSize.width/2, tipSize.height - titlesize.height/2 - 10)

    local exit_btn = ccui.Button:create("rank/close.png"); 
    tip:addChild(exit_btn)
    local exit_btnsize = exit_btn:getContentSize();
    exit_btn:setPosition(tipSize.width - exit_btnsize.width/2 - 15, tipSize.height - titlesize.height/2 - 10);
    exit_btn:addClickEventListener(function ( ... )
        -- body
        self:removeChildByName("persondes");
    end)


    local start_y = tipSize.height - titlesize.height - 20
     -- 图标
    local tb_offx = 20
    local tb = display.newSprite("head/" .. data.playerSimpleInfo.avatar .. ".jpg");
    local tbsize = tb:getContentSize();
    tip:addChild(tb)
    local tb_y = start_y - tbsize.height/2 - 10
    tb:setPosition(tb_offx + tbsize.width/2, tb_y)


    -- 名称
    local nm = cc.Label:createWithSystemFont(data.playerSimpleInfo.nickName, "Arial", 24)
    nm:setTextColor(cc.c3b(0, 0, 0));
    nm:setAnchorPoint(0,1)
    nm:setPosition(tb_offx + tbsize.width + 10,  tb_y+tbsize.height/2)
    tip:addChild(nm); 


    local jb = cc.Label:createWithSystemFont("拥有金币 : " .. data.gold, "Arial", 24)
    jb:setTextColor(cc.c3b(0, 0, 0));
    jb:setAnchorPoint(0,0.5)
    local jbSize = jb:getContentSize()
    jb:setPosition(tb_offx + tbsize.width + 10,  tb_y)
    tip:addChild(jb); 

    -- des
    local des = cc.Label:createWithSystemFont("个人推荐码 : xxxx", "Arial", 24)
    des:setTextColor(cc.c3b(0, 0, 0));
    des:setAnchorPoint(0,0)
    des:setPosition(tb_offx + tbsize.width + 10,  tb_y - tbsize.height/2);
    tip:addChild(des); 
    
    local line = display.newSprite("rank/line.png"); 
    tip:addChild(line);
    local linesize = line:getContentSize(); 
    line:setScaleX((tipSize.width -10)/linesize.width);
    local line_y = tb_y - tbsize.height/2 - 5
    line:setPosition(tipSize.width/2, line_y);

    --个性签名 
    local qm = cc.Label:createWithSystemFont("个性签名:", "Arial", 24);
    tip:addChild(qm)
    local qmsize = qm:getContentSize(); 
    qm:setPosition(tb_offx + qmsize.width/2, line_y - 5 - qmsize.height/2);
    qm:setTextColor(cc.c3b(0,0,0));

    local des = cc.Label:createWithSystemFont(data.playerSimpleInfo.introduction, "Arial", 24);
    des:setAnchorPoint(cc.p(0, 1));
    tip:addChild(des)
    des:setPosition(tb_offx, line_y - qmsize.height - 10);
    des:setTextColor(cc.c3b(0,0,0));
    des:setLineBreakWithoutSpace(true);
    des:setMaxLineWidth(tipSize.width - tb_offx * 2);
    des:setWidth(tipSize.width - tb_offx*2);
    self:addChild(layout)
    layout:setName("persondes");
end
return RankScene
