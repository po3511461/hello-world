-- 红包记录
local RedPackageRecordScene = class("RedPackageRecordScene",function()
    return display.newLayer();
end);

function RedPackageRecordScene:update( timems)
    -- body
    -- 当前页数，小于总页数 ，并且没有在请求中，才会去请求数据 
    local cur_info - self.cur_info;
    if cur_info  and not self.issend then 
        local total_page = math.ceil(cur_info.total/15)
        if self.page < total_page then 
            local centerScroll = self.centerScroll;
            if centerScroll then 
                local container = centerScroll:getInnerContainer();

                local x,y = container:getPosition()
                if y > 0 then 
                    -- 请求下一页数据
                    self:getData(self.page + 1);
                end 
            end 
        end 
    end 
end
-- local json = require("framework.json");
function RedPackageRecordScene:ctor(yk)
	self.yk = yk or 1; -- 收到的红包，发出的红包
	self.page = 1;
    self.rows = {};
    self:scheduleUpdateWithPriorityLua(function ( ms )
        -- body
        self:update(ms);
    end, 0)
	local bg = display.newSprite("redpackageRecord/bg.jpg");
    local bgSize = bg:getContentSize();
    local scalex = display.width/bgSize.width
    local scaley = display.height/bgSize.height

    local scale = math.max(scalex, scaley) 
    bg:setScale(scale) 
    bg:setAnchorPoint(cc.p(0,0));
    self:addChild(bg)

    -- add title
    local title = cc.Label:createWithSystemFont("收到的红包", "Arial", 35)
    title:setPosition(display.cx, display.height - 70)
    title:enableShadow(cc.c4b(255, 250, 250), cc.size(1,1), 1) -- 启动阴影 
    title:enableOutline(cc.c4b(255, 250, 250), 1) -- 启动描边
    self:addChild(title); 

    self.title = title
    -- 关闭按钮 
    local exit = ccui.Button:create("redpackage/close_text.png");
    exit:addClickEventListener(function ( ... )
        -- body
        self:removeSelf();
    end)
    local exitsize = exit:getContentSize()
    exit:setPosition(20 + exitsize.width/2, display.height - 70)
    self:addChild(exit);

    -- 三点 
    local xq_btn = ccui.Button:create("bank/point.png");
    self:addChild(xq_btn);
    xq_btn:addClickEventListener(function ( ... )
        -- body
        self:createOperation();
    end)
    local btnsize = xq_btn:getContentSize();
    xq_btn:setPosition(display.width - 30 - btnsize.width/2, display.height - 70)

    self:getData();
end

function RedPackageRecordScene:getData( page)
	-- body
    self.issend = true;
    if self.yk == 1 then -- 收到的红包
    	local page = page or 1
    	local param = "" 

        param = param .. "receiveYear=2018&" .. "receive_unique_id=" .. tonumber(MyInfo.uniqueId)  ..  "&page=" .. page .. "&limit=15"; 
        -- local cs = json.encode(param)
        Utils.requestHttp( "http://39.108.68.45:8080/", "chess/logRedPacketRecord/listForGame", function ( data )
            -- body
            if data.readyState == 4 and (data.status >= 200 and data.status < 207) then
                local info = json.decode(data.response);
                self.page = page;
                if page == 1 then 
                    self.rows ={};
                end 

                local cur_rows = info.info.rows 
                for i,v in ipairs(cur_rows)do 
                    table.insert(self.rows, v);
                end
                self:createCenter(info);
                self.issend = false;
            end
        end, param);
    else -- 发出的红包
        local page = page or 1
        local param = "" 

        param = param .. "sendYear=2018&" .. "send_unique_id=" .. tonumber(MyInfo.uniqueId)  ..  "&page=" .. page .. "&limit=15"; 
        -- local cs = json.encode(param)
        Utils.requestHttp( "http://39.108.68.45:8080/", "chess/logRedPacket/listForGame", function ( data )
            -- body
            if data.readyState == 4 and (data.status >= 200 and data.status < 207) then
                local info = json.decode(data.response);
                self.page = page;
                if page == 1 then 
                    self.rows ={};
                end 

                local cur_rows = info.info.rows 
                for i,v in ipairs(cur_rows)do 
                    table.insert(self.rows, v);
                end
                self:createCenter(info);
                self.issend = false;
            end
        end, param);
    end 
end

function RedPackageRecordScene:createOperation( ... )
    -- body
    local layout = ccui.Layout:create();
    layout:setLocalZOrder(101)
    layout:setTouchEnabled(true);
    local layoutsize = cc.size(display.width, display.height)
    layout:setContentSize(layoutsize);
    layout:setName("preOpen");
    self:addChild(layout);

    local bg = cc.LayerColor:create(cc.c4b(0,0,0, 180),display.width, layoutsize.height);
    layout:addChild(bg)

    local qx_btn = ccui.Button:create("bank/record_btn.jpg");
    qx_btn:setTitleText("取 消");
    qx_btn:setTitleColor(cc.c3b(0,0,0))
    qx_btn:setTitleFontSize(40);
    local btnsize = qx_btn:getContentSize();
    qx_btn:setPosition(display.cx, btnsize.height/2);
    qx_btn:addClickEventListener(function ( ... )
        -- body
        self:removeChildByName("preOpen");
    end)
    layout:addChild(qx_btn);

    local record_btn = ccui.Button:create("bank/record_btn.jpg");
    record_btn:setTitleText("发出的红包");
    record_btn:setTitleColor(cc.c3b(0,0,0))
    record_btn:setTitleFontSize(40);
    layout:addChild(record_btn);
    local btnsize = record_btn:getContentSize();
    record_btn:setPosition(display.cx, btnsize.height+  btnsize.height/2 + 2);
    record_btn:addClickEventListener(function ( ... )
        -- body
        if self.yk == 1 then
            self.yk = 2;
            self:getData();
        end
        self:removeChildByName("preOpen"); 
 
    end)

    local record_btn = ccui.Button:create("bank/record_btn.jpg");
    record_btn:setTitleText("收到的红包");
    record_btn:setTitleColor(cc.c3b(0,0,0))
    record_btn:setTitleFontSize(40);
    layout:addChild(record_btn);
    local btnsize = record_btn:getContentSize();
    record_btn:setPosition(display.cx, btnsize.height*2+  btnsize.height/2 + 4);
    record_btn:addClickEventListener(function ( ... )
        -- body
        if self.yk == 2 then
            self.yk = 1;
            self:getData();
        end 
        self:removeChildByName("preOpen"); 
    end)
end

function RedPackageRecordScene:createCenter(info)
	-- body
	if self.yk == 1 then 
        self.title:setString("收到的红包")
    else
        self.title:setString("发出的红包")
    end 

    if self.page ~= 1 then 
        if self.centerScroll then 
            local container = self.centerScroll:getInnerContainer()
            local x,y = container:getPosition()
            self.last_y = y;
        end 
    end 

    local titleHeight = 130
    local data = info.info
    -- 绘制info数据 
    if not self.centerScroll then 
        local start_y = display.height - titleHeight
        -- center
        local bottom_height = 0;
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
        self.centerScroll = ScrollView_2;
    else
        self.centerScroll:removeAllChildren();
    end 

    local ScrollView_2 = self.centerScroll;
    self.cur_info = data; 
    local topheight = 580;
    -- 添加滚动元素 
    local listdata = self.rows;
    local offy = 5; 
    local cellbg = display.newSprite("redpackageRecord/cell.jpg");
    local cellbgsize = cellbg:getContentSize();

    local scrollsize = ScrollView_2:getContentSize();
    local height = scrollsize.height;

    local realheight = (cellbgsize.height + offy) * # listdata + topheight
    if realheight > height then 
        height = realheight;
    end 

    local start_y = height;

     --tx 
    local tx = display.newSprite("head/" .. MyInfo.avatar .. ".jpg");
    ScrollView_2:addChild(tx);
    local txsize = tx:getContentSize()
    tx:setPosition(display.cx,  start_y- txsize.height/2 - 70)

    if self.yk == 1 then -- 收到的红包
        --nm 
        local nm = cc.Label:createWithSystemFont(MyInfo.nickName .. "共收到" , "Arial", 35)
        nm:setTextColor(cc.c3b(0,0,0));
        ScrollView_2:addChild(nm)
        local nmsize = nm:getContentSize()
        nm:setPosition(display.cx, start_y - txsize.height - 100 - nmsize.height/2)

         -- 金币
        local jb = cc.Label:createWithSystemFont((data.receive_total_gold or 0) ..  "金币", "Arial", 60)
        jb:setTextColor(cc.c3b(0, 0, 0));
        jb:setPosition(display.cx, start_y - 300);
        ScrollView_2:addChild(jb); 

        -- 红包个数 
        start_y = start_y - 420
        local  hbsl= cc.Label:createWithSystemFont((data.total or 0), "Arial", 38)
        hbsl:setTextColor(cc.c3b(0, 0, 0));
        hbsl:setPosition(display.cx - 160, start_y );
        ScrollView_2:addChild(hbsl);

        local  slms = cc.Label:createWithSystemFont("收到红包", "Arial", 38)
        slms:setTextColor(cc.c3b(0, 0, 0));
        slms:setPosition(display.cx - 160, start_y -40 );
        ScrollView_2:addChild(slms);

        -- 运气最佳
        local  zjsl= cc.Label:createWithSystemFont((data.receive_total_luck or 0), "Arial", 38)
        zjsl:setTextColor(cc.c3b(0, 0, 0));
        zjsl:setPosition(display.cx + 160, start_y );
        ScrollView_2:addChild(zjsl);

        local  zjms = cc.Label:createWithSystemFont("手气最佳", "Arial", 38)
        zjms:setTextColor(cc.c3b(0, 0, 0));
        zjms:setPosition(display.cx + 160, start_y -40);
        ScrollView_2:addChild(zjms);
    else --发出的红包 
        --nm 
        local nm = cc.Label:createWithSystemFont(MyInfo.nickName .. "共发出" , "Arial", 35)
        nm:setTextColor(cc.c3b(0,0,0));
        ScrollView_2:addChild(nm)
        local nmsize = nm:getContentSize()
        nm:setPosition(display.cx, start_y - txsize.height - 100 - nmsize.height/2)

         -- 金币
        local jb = cc.Label:createWithSystemFont((data.send_total_gold or 0)..  "金币", "Arial", 60)
        jb:setTextColor(cc.c3b(0, 0, 0));
        jb:setPosition(display.cx, start_y - 320);
        ScrollView_2:addChild(jb); 

        -- 红包个数 
        start_y = start_y - 430
        local  hbsl= cc.Label:createWithSystemFont("发出红包" ..  (data.total or 0) .. "个", "Arial", 38)
        hbsl:setTextColor(cc.c3b(0, 0, 0));
        hbsl:setPosition(display.cx, start_y );
        ScrollView_2:addChild(hbsl);
    end 

    -- 绘制列表 
    local start_y = height - topheight;
    
    for i,v in ipairs(listdata)do 
        local item = self:createCenterItem(v); 
        if not itemsize then 
            itemsize = item.size;
        end
        item:setPosition(display.cx, start_y - i * (itemsize.height + offy)); 
        ScrollView_2:addChild(item)
    end 

    ScrollView_2:setInnerContainerSize(cc.size(display.width, height)); 
    if self.last_y then 
        local container = ScrollView_2:getInnerContainer()
        container:setPosition(0, self.last_y);
        self.last_y = nil;
    end

end

-----------------------------
-- 绘制列表元素
-- @param data = {}
function RedPackageRecordScene:createCenterItem( data )
	-- body
	local cellbg = display.newSprite("redpackageRecord/cell.jpg");
	local cellsize = cellbg:getContentSize()
	local layout = ccui.Layout:create()
	layout.size = cc.size(display.width, cellsize.height)
	layout:setAnchorPoint(cc.p(0, 0));
	layout:setContentSize(layout.size);
    cellbg:setPosition(0, cellsize.height/2)

    if self.yk ==  1 then -- 收到的红包 
        local nm = cc.Label:createWithSystemFont(data.pl2_nickName, "Arial", 40);
        local nmsize = nm:getContentSize();
        nm:setColor(cc.c3b(0, 0, 0));
        cellbg:addChild(nm); 
        nm:setPosition(nmsize.width/2  + 10 , cellsize.height/2 + nmsize.height/2 + 5);

        local sj = cc.Label:createWithSystemFont(data.receive_date_str, "Arial", 30);
        local sjsize = sj:getContentSize();
        sj:setColor(cc.c3b(0, 0, 0));
        cellbg:addChild(sj); 
        sj:setPosition(sjsize.width/2  + 10 , cellsize.height/2 - sjsize.height/2 - 5);

        local je = cc.Label:createWithSystemFont(data.rpr_money .. "金币", "Arial", 40);
        local jesize = je:getContentSize();
        je:setColor(cc.c3b(0, 0, 0));
        cellbg:addChild(je); 
        je:setPosition(display.width  - 10 - jesize.width/2 , cellsize.height/2 + jesize.height/2 + 5);

    else
        local config = {
            [1] = "100金币群",
            [5] = "500金币群",
            [10] = "1000金币群",
            [50] = "5000金币群",
            [100] = "1w金币群",
            [500] = "5w金币群",
            [1000] = "10w金币群",
            
        } 
        
        -- 通过房间登记 获取房间名称
        local nm = cc.Label:createWithSystemFont(config[data.rm_level], "Arial", 40);
        local nmsize = nm:getContentSize();
        nm:setColor(cc.c3b(0, 0, 0));
        cellbg:addChild(nm); 
        nm:setPosition(nmsize.width/2  + 10 , cellsize.height/2 + nmsize.height/2 + 5);

        local sj = cc.Label:createWithSystemFont(data.send_date_str, "Arial", 30);
        local sjsize = sj:getContentSize();
        sj:setColor(cc.c3b(0, 0, 0));
        cellbg:addChild(sj); 
        sj:setPosition(sjsize.width/2  + 10 , cellsize.height/2 - sjsize.height/2 - 5);

        local je = cc.Label:createWithSystemFont(data.rp_redPacketMoney .. "金币", "Arial", 40);
        local jesize = je:getContentSize();
        je:setColor(cc.c3b(0, 0, 0));
        cellbg:addChild(je); 
        je:setPosition(display.width  - 10 - jesize.width/2 , cellsize.height/2 + jesize.height/2 + 5);
    end 
	layout:addChild(cellbg);   
	return layout;
end

return RedPackageRecordScene


