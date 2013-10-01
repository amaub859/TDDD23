application =
{
	content =
	{
		fps = 60,			-- Desired frame rate 
		width = 320,		-- Desired width of the application
		height = 480,		-- Desired height of the application
		
		-- Scaling mode, should the screen not fit the width and height exactly
		scale = "letterbox",
		--[[
		Other options include:
		"none"			no dynamic content scaling
		"letterbox"		uniform scaling of content with black bars surrounding content
		"zoomEven"		scaling of content to fill screen while preserving aspect ratio (some content may be offscreen)
		"zoomStretch"	scaling of content to fill screen by stretching to fit height and width (results in distorted imagery)
		--]]
		
		--Suffixes for images so that the right image can loaded according to platform
		imageSuffix =
        {
            ["@1-5x"] = 1.5, -- Various Android phones.
            ["@2x"] = 2,    -- iPhone 4 and higher, iPod touch, iPad1, and iPad2
            ["@3x"] = 3,    -- Various Android tablets
            ["@4x"] = 4,    -- iPad 3+
        }
	
	},
}
-- For more, see http://developer.anscamobile.com/content/configuring-projects