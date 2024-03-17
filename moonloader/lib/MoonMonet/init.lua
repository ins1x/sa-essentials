local ffi = require 'ffi'
local MoonMonet = {}

MoonMonet._VERSION = 1.0

local libPath = getWorkingDirectory() .. [[\lib\MoonMonet\moonmonet_rs]]

ffi.cdef[[
    typedef struct {
        uint32_t color_0;
        uint32_t color_10;
        uint32_t color_50;

        uint32_t color_100;
        uint32_t color_200;
        uint32_t color_300;

        uint32_t color_400;
        uint32_t color_500;
        uint32_t color_600;

        uint32_t color_700;
        uint32_t color_800;
        uint32_t color_900;

        uint32_t color_1000;
    } SubColors;

    typedef struct {
        SubColors accent1;
        SubColors accent2;
        SubColors accent3;

        SubColors neutral1;
        SubColors neutral2;
    } Colors;

    Colors moonmonet_build_colors(float chroma_multiplier, uint32_t color, bool accurate_shades);
]]

local lib = ffi.load(libPath)

function MoonMonet.buildColors(color, chroma_multiplier, accurate_shades)
    if type(chroma_multiplier) ~= "number" then chroma_multiplier = 1.0 end
    if type(accurate_shades) ~= "boolean" then accurate_shades = true end
    return lib.moonmonet_build_colors(chroma_multiplier, color, accurate_shades)
end

return MoonMonet
