-- 銀行记录

local BankRecordScene = class("BankRecordScene", cc.load("mvc").ViewBase)
-- local json = require("framework.json");
function BankRecordScene:onCreate()
    self.yk = 1; --收礼记录，2，送礼记录
    self.page = 1;

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
    self.titlesize = title_bgsize;

    -- add title
    local title = cc.Label:createWithSystemFont("银行记录", "Arial", 40)
    title:setPosition(display.cx, display.height - title_bgsize.height/2)
    title:enableShadow(cc.c4b(0, 0, 0), cc.size(1,1), 1) -- 启动阴影 
    title:enableOutline(cc.c4b(0,0,0), 1) -- 启动描边
    self:addChild(title); 

    local fh_wz = ccui.Text:create("< 银行", "Arial" , 40)
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
                require("app.MyApp"):create():enterScene("BankScene", "moveinl");
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

    self:createTop();

    self:createBottom();
end

function BankRecordScene:getData( page)
    -- body
    local page = page or 1
    local param = ""
    local _type = 205 -- 存款記錄
    if self.yk == 2 then 
        _type = 206 --取款疾苦
    end 

    param = param .. "uniqueId=" .. tonumber(MyInfo.uniqueId) .. "&" .. "page=" .. page .. "&limit=15&type=" .. _type; 
    -- local cs = json.encode(param)
    Utils.requestHttp( "http://39.108.68.45:8080/", "chess/logBankRecord/listForGame", function ( data )
        -- body
        if data.readyState == 4 and (data.status >= 200 and data.status < 207) then
            print(data.response);
            local info = json.decode(data.response);
            print("1111111111")
            print(table.tostring(info));
            self.page = page;
            self:createCenter(info);
        end
    end, param);
end

-- 绘制顶部
function BankRecordScene:createTop( ... )
    -- body
    local layout = ccui.Layout:create();
    self:addChild(layout);
    layout:setAnchorPoint(cc.p(0, 0));
    

    local get_btn =  ccui.Button:create("giftRecord/nochose.png", "giftRecord/nochose.png");
    local btnsize = get_btn:getContentSize(); 
    get_btn:setTitleText("存款记录")
    get_btn:setTitleFontSize(40);
    get_btn:setPosition(btnsize.width/2, btnsize.height/2);
    get_btn:addClickEventListener(function ( ... )
        -- body
        -- self:removeChildByName("openpanel");
        if self.yk == 2 then 
            self.yk = 1;
            self:updateChose(); 
        end
    end)

    local chose_img = display.newSprite("giftRecord/chose.png");
    chose_img:setPosition(btnsize.width/2, btnsize.height/2)
    get_btn:addChild(chose_img);
    self.chose_img1 = chose_img;
    local ms = cc.Label:createWithSystemFont("存款记录", "Arial", 40);
    chose_img:addChild(ms);
    ms:setPosition(btnsize.width/2, btnsize.height/2)
    layout:setContentSize(cc.size(display.width, btnsize.height))
    layout:addChild(get_btn);



    local out_btn =  ccui.Button:create("giftRecord/nochose.png", "giftRecord/nochose.png");
    local btnsize = out_btn:getContentSize(); 
    out_btn:setTitleText("取款记录")
    out_btn:setTitleFontSize(40);
    out_btn:setPosition(btnsize.width + btnsize.width/2, btnsize.height/2);
    out_btn:addClickEventListener(function ( ... )
        -- body
        -- self:removeChildByName("openpanel");
        if self.yk == 1 then 
            self.yk = 2;
            self:updateChose(); 
        end
    end)
    layout:addChild(out_btn);
    local chose_img = display.newSprite("giftRecord/chose.png");
    chose_img:setPosition(btnsize.width/2, btnsize.height/2)
    out_btn:addChild(chose_img);

    local ms = cc.Label:createWithSystemFont("取款记录", "Arial", 40);
    chose_img:addChild(ms);
    self.chose_img2 = chose_img;
    ms:setPosition(btnsize.width/2, btnsize.height/2)
    layout:setPosition(0, display.height -  self.titlesize.height - btnsize.height);


    -- 绘制title 
    local offx = display.width/4

    local offy = 60
    local y = display.height -  self.titlesize.height - btnsize.height -  offy /2
    local time = cc.Label:createWithSystemFont("时间", "Arial", 35);
    time:setColor(cc.c3b(0, 0, 0));
    self:addChild(time)
    time:setPosition(offx /2, y);

    local name = cc.Label:createWithSystemFont("昵称", "Arial", 35);
    self:addChild(name)
    name:setColor(cc.c3b(0, 0, 0));
    name:setPosition(offx /2 + offx, y);

    local id = cc.Label:createWithSystemFont("ID", "Arial", 35);
    self:addChild(id)
    id:setPosition(offx /2 + offx * 2, y);
    id:setColor(cc.c3b(0, 0, 0));


    local sl = cc.Label:createWithSystemFont("金币数量", "Arial", 35);
    self:addChild(sl)
    sl:setPosition(offx /2 + offx * 3, y);
    sl:setColor(cc.c3b(0, 0, 0));
    self.start_y = y - offy/2;
    self:updateChose();
end

function BankRecordScene:updateChose( ... )
    -- body
    if self.yk == 1 then 
        self.chose_img1:show()
        self.chose_img2:hide();
    else 
        self.chose_img1:hide()
        self.chose_img2:show();
    end 

    -- 刷新数据  
    self:getData();
end

-- 绘制底部
function BankRecordScene:createBottom( ... )
    -- body 
    local layout = ccui.Layout:create();
    self:addChild(layout);
    layout:setAnchorPoint(cc.p(0, 0));


    local bottom_bg = display.newSprite("redpackage/bottom.jpg");
    layout:addChild(bottom_bg)
    local bottom_bgsize = bottom_bg:getContentSize();
    bottom_bg:setScaleX(display.width/ bottom_bgsize.width);
    bottom_bg:setAnchorPoint(cc.p(0,0))
    bottom_bg:setPosition(0, 0)
    self.bottomsize = bottom_bgsize;
    layout:setContentSize(cc.size(display.width, bottom_bgsize.height))

    -- 绘制当前页数
    local ms =  cc.Label:createWithSystemFont("0/0页", "Arial", 35); 
    ms:setColor(cc.c3b(0, 0, 0));
    layout:addChild(ms);
    ms:setPosition(bottom_bgsize.width/2, bottom_bgsize.height/2);
    self.ms = ms; 

    -- 绘制上一页按钮 
    local pre_btn =  ccui.Button:create("giftRecord/next.png");
    local btnsize = pre_btn:getContentSize(); 
    pre_btn:setTitleText("上一页")
    pre_btn:setTitleFontSize(30);
    pre_btn:setPosition(bottom_bgsize.width/2 - btnsize.width/2 - 90, bottom_bgsize.height/2);
    pre_btn:addClickEventListener(function ( ... )
        -- body
        if self.centerInfo then 
            if  self.page > 1 then 
                local page = self.page -1 
                self:getData(page);
            end
        end 
    end)
    layout:addChild(pre_btn);

    -- 绘制下一页按钮 
    local next_btn =  ccui.Button:create("giftRecord/next.png");
    next_btn:setTitleText("下一页")
    next_btn:setTitleFontSize(30);
    local btnsize = next_btn:getContentSize(); 
    next_btn:setPosition(bottom_bgsize.width/2 + btnsize.width/2 + 90, bottom_bgsize.height/2);
    next_btn:addClickEventListener(function ( ... )
        -- body
        -- self:removeChildByName("openpanel");
        if self.centerInfo then 
            if  self.page < math.ceil(self.centerInfo.total/15) then 
                local page = self.page + 1 
                self:getData(page);
            end
        end 
    end)
    layout:addChild(next_btn);

    -- 绘制第一页按钮
    local r_x = bottom_bgsize.width/2 + btnsize.width + 30
    local l_x = bottom_bgsize.width/2 - btnsize.width - 30 
    local fir_btn =  ccui.Button:create("giftRecord/last.png");
    local btnsize = fir_btn:getContentSize(); 
    fir_btn:setPosition(40 + btnsize.width/2, bottom_bgsize.height/2);
    fir_btn:addClickEventListener(function ( ... )
        -- body
        if self.centerInfo then 
            if self.centerInfo.total > 0 then 
                self:getData(1);
            end 
        end 
    end)
    fir_btn:setScaleX(-1)
    layout:addChild(fir_btn);

    --  绘制最后一页按钮
    local last_btn =  ccui.Button:create("giftRecord/last.png");
    local btnsize = last_btn:getContentSize(); 
    last_btn:setPosition(display.width - 40 - btnsize.width/2, bottom_bgsize.height/2);
    last_btn:addClickEventListener(function ( ... )
        -- body
        if self.centerInfo then 
            local totalpage =  math.ceil(self.centerInfo.total/15)
            if totalpage > 0 then 
                self:getData(totalpage);
                
            end 
        end 
    end)
    layout:addChild(last_btn);
end


function BankRecordScene:createCenter(info)
    -- body
    -- 更新数据 
    self.centerInfo = info.info;
    if info.info.total > 0 then 
        self.ms:setString(self.page .. "/" .. math.ceil(info.info.total/15) .. "页"); 
    else 
        self.ms:setString("0/0页"); 
    end 

    if not self.centerScroll then 
        local start_y = self.start_y 
        -- center
        local bottom_height = self.bottomsize.height;
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
    -- 添加滚动元素 
    local listdata = info.info.rows;
    local itemsize
    local offy = 5; 
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
            v:setPosition(0, height - i * (itemsize.height + offy)); 
        end
    end 
    ScrollView_2:setInnerContainerSize(cc.size(display.width, height)); 
end

-----------------------------
-- 绘制列表元素
-- @param data = {}
function BankRecordScene:createCenterItem( data )
    -- body
    local cellbg = display.newSprite("giftRecord/cell.jpg");
    local cellsize = cellbg:getContentSize()
    local layout = ccui.Layout:create()
    layout.size = cc.size(display.width, cellsize.height)
    layout:setAnchorPoint(cc.p(0, 0));
    layout:setContentSize(layout.size);

    layout:addChild(cellbg);
    cellbg:setPosition(cellsize.width/2, cellsize.height/2);
    local offx = display.width/4
    local size = 28
    local y = cellsize.height/2
    local time = cc.Label:createWithSystemFont(data.record_date_str, "Arial", size-4);
    time:setWidth(offx - 20)
    time:setMaxLineWidth(offx - 20)
    time:setHorizontalAlignment(1);
    time:setVerticalAlignment(1);
    time:setColor(cc.c3b(0, 0, 0));
    layout:addChild(time)
    time:setPosition(offx /2, y);

    local name = cc.Label:createWithSystemFont(data.pl_nickName, "Arial", size);
    layout:addChild(name)
    name:setColor(cc.c3b(0, 0, 0));
    name:setPosition(offx /2 + offx, y);

    local id = cc.Label:createWithSystemFont(data.pl_unique_id, "Arial", size);
    layout:addChild(id)
    id:setPosition(offx /2 + offx * 2, y);
    id:setColor(cc.c3b(0, 0, 0));


    local sl = cc.Label:createWithSystemFont(math.abs(data.before_gold - data.after_gold), "Arial", size);
    layout:addChild(sl)
    sl:setPosition(offx /2 + offx * 3, y);
    sl:setColor(cc.c3b(0, 0, 0));
    
    return layout;
end

return BankRecordScene


