--
-- created with TexturePacker (http://www.codeandweb.com/texturepacker)
--
-- $TexturePacker:SmartUpdate:f0a806c87e25585e2777a82487ab4651:1/1$
--
-- local sheetInfo = require("mysheet")
-- local myImageSheet = graphics.newImageSheet( "mysheet.png", sheetInfo:getSheet() )
-- local sprite = display.newSprite( myImageSheet , {frames={sheetInfo:getFrameIndex("sprite")}} )
--

local SheetInfo = {}

SheetInfo.sheet =
{
    frames = {
    
        {
            -- star1
            x=28,
            y=38,
            width=2,
            height=2,

            sourceX = 18,
            sourceY = 25,
            sourceWidth = 40,
            sourceHeight = 50
        },
        {
            -- star2
            x=2,
            y=38,
            width=24,
            height=24,

            sourceX = 7,
            sourceY = 14,
            sourceWidth = 40,
            sourceHeight = 50
        },
        {
            -- star3
            x=2,
            y=2,
            width=34,
            height=34,

            sourceX = 2,
            sourceY = 9,
            sourceWidth = 40,
            sourceHeight = 50
        },
        {
            -- star4
            x=2,
            y=38,
            width=24,
            height=24,

            sourceX = 7,
            sourceY = 14,
            sourceWidth = 40,
            sourceHeight = 50
        },
        {
            -- star5
            x=28,
            y=38,
            width=2,
            height=2,

            sourceX = 18,
            sourceY = 25,
            sourceWidth = 40,
            sourceHeight = 50
        },
    },
    
    sheetContentWidth = 64,
    sheetContentHeight = 64
}

SheetInfo.frameIndex =
{

    ["star1"] = 1,
    ["star2"] = 2,
    ["star3"] = 3,
    ["star4"] = 4,
    ["star5"] = 5,
}

function SheetInfo:getSheet()
    return self.sheet;
end

function SheetInfo:getFrameIndex(name)
    return self.frameIndex[name];
end

SheetInfo.sequenceData = {
    {
    name="star",
    frames={1,2,3,2,1},
    time=2000,
    loopCount=0,
    }
}

function SheetInfo:getSequenceData()
    return self.sequenceData;
end

return SheetInfo
