local mt = getmetatable("String")

--[[
	Library «Strings», v2.0
	Custom strings methods 

	Author: Cosmo
	VK: vk.me/cosui
	TG: t.me/cosmo_way
	BH: blast.hk/members/217639
]]

function mt.__index:insert(implant, pos)
	if pos == nil then
		return self .. implant
	end
	return self:sub(1, pos) .. implant .. self:sub(pos + 1)
end

function mt.__index:extract(pattern)
	self = self:gsub(pattern, "")
	return self
end

function mt.__index:array()
	local array = {}
	for s in self:gmatch(".") do
		array[#array + 1] = s
	end
	return array
end

function mt.__index:isEmpty()
	return self:find("%S") == nil
end

function mt.__index:isDigit()
	return self:find("%D") == nil
end

function mt.__index:isAlpha()
	return self:find("[%d%p]") == nil
end

function mt.__index:split(sep, plain)   
	local result, pos = {}, 1
	repeat
		local s, f = self:find(sep or " ", pos, plain)
		local t = self:sub(pos, s and s - 1)
		if t ~= "" then
			result[#result + 1] = t
		end
		pos = f and f + 1
	until pos == nil
	return result
end

local orig_lower = string.lower
function mt.__index:lower()
	for i = 192, 223 do
		self = self:gsub(string.char(i), string.char(i + 32))
	end
	self = self:gsub(string.char(168), string.char(184))
	return orig_lower(self)
end

local orig_upper = string.upper
function mt.__index:upper()
	for i = 224, 255 do
		self = self:gsub(string.char(i), string.char(i - 32))
	end
	self = self:gsub(string.char(184), string.char(168))
	return orig_upper(self)
end

function mt.__index:isSpace()
	return self:find("^[%s%c]*$") ~= nil
end

function mt.__index:isUpper()
	return self:upper() == self
end

function mt.__index:isLower()
	return self:lower() == self
end

function mt.__index:isSimilar(str)
	return self == str
end

function mt.__index:isTitle()
	local p = self:find("[A-zÀ-ÿ¨¸]")
	local let = self:sub(p, p)
	return let:isSimilar(let:upper())
end

function mt.__index:startsWith(str)
	return self:sub(1, #str):isSimilar(str)
end

function mt.__index:endsWith(str)
	return self:sub(#self - #str + 1, #self):isSimilar(str)
end

function mt.__index:capitalize()
	local cap = self:sub(1, 1):upper()
	self = self:gsub("^.", cap)
	return self
end

function mt.__index:tabsToSpace(count)
	local spaces = (" "):rep(count or 4)
	self = self:gsub("\t", spaces)
	return self
end

function mt.__index:spaceToTabs(count)
	local spaces = (" "):rep(count or 4)
	self = self:gsub(spaces, "\t")
	return self
end

function mt.__index:center(width, char)
	local len = width - #self
	local s = string.rep(char or " ", len) 
	return s:insert(self, math.ceil(len / 2))
end

function mt.__index:count(search, p1, p2)
	local area = self:sub(p1 or 1, p2 or #self)
	local count, pos = 0, p1 or 1
	repeat
		local s, f = area:find(search, pos, true)
		count = s and count + 1 or count
		pos = f and f + 1
	until pos == nil
	return count
end

function mt.__index:trimEnd()
	self = self:gsub("%s*$", "")
	return self
end

function mt.__index:trimStart()
	self = self:gsub("^%s*", "")
	return self
end

function mt.__index:trim()
	self = self:match("^%s*(.-)%s*$")
	return self
end

function mt.__index:swapCase()
	local result = {}
	for s in self:gmatch(".") do
		if s:isAlpha() then
			s = s:isLower() and s:upper() or s:lower()
		end
		result[#result + 1] = s
	end
	return table.concat(result)
end

function mt.__index:splitEqually(width)
	assert(width > 0, "Width less than zero")
	if width >= self:len() then
		return { self }
	end

	local result, i = {}, 1
	repeat
		if #result == 0 or #result[#result] >= width then
			result[#result + 1] = ""
		end
		result[#result] = result[#result] .. self:sub(i, i)
		i = i + 1
	until i > #self
	return result
end

function mt.__index:rFind(pattern, pos, plain)
	local i = pos or #self
	repeat
		local result = { self:find(pattern, i, plain) }
		if next(result) ~= nil then
			return table.unpack(result)
		end
		i = i - 1
	until i <= 0
	return nil
end

function mt.__index:wrap(width)
	assert(width > 0, "Width less than zero")
	assert(width < self:len(), "Width is greater than the string length")
	local pos = 1
	self = self:gsub("(%s+)()(%S+)()", function(sp, st, word, fi)
		if fi - pos > (width or 72) then
			pos = st
			return "\n" .. word
		end
	end)
	return self
end

function mt.__index:levDist(str)
	if #self == 0 then
		return #str
	elseif #str == 0 then
		return #self
	elseif self == str then
		return 0
	end
	
	local cost = 0
	local matrix = {}
	for i = 0, #self do matrix[i] = {}; matrix[i][0] = i end
	for i = 0, #str do matrix[0][i] = i end
	for i = 1, #self, 1 do
		for j = 1, #str, 1 do
			cost = self:byte(i) == str:byte(j) and 0 or 1
			matrix[i][j] = math.min(
				matrix[i - 1][j] + 1,
				matrix[i][j - 1] + 1,
				matrix[i - 1][j - 1] + cost
			)
		end
	end
	return matrix[#self][#str]
end

function mt.__index:getSimilarity(str)
	local dist = self:levDist(str)
	return 1 - dist / math.max(#self, #str)
end

function mt.__index:empty()
	return ""
end

function mt.__index:toCamel()
	local arr = self:array()
	for i, let in ipairs(arr) do
		arr[i] = (i % 2 == 0) and let:lower() or let:upper()
	end
	return table.concat(arr)
end

function mt.__index:unplain()
	local arr = self:array()
	for i, let in ipairs(arr) do
		if let:find("().%+-*?[]^$", 1, true) then
			arr[i] = "%" .. let
		end
	end
	return table.concat(arr)
end

function mt.__index:shuffle(seed)
	math.randomseed(seed or os.time())
	local arr = self:array()
	for i = #arr, 2, -1 do
	    local j = math.random(i)
	    arr[i], arr[j] = arr[j], arr[i]
	end
	return table.concat(arr)
end

function mt.__index:cutLimit(max_len, symbol)
	assert(max_len > 0, "Maximum length cannot be less than or equal to 1")
	if #self > 0 and #self > max_len then
		symbol = symbol or ".."
		self = self:sub(1, max_len) .. symbol
	end
	return self
end

function mt.__index:switchLayout()
	local result = ""
	local b = self:find("^[%s%p]*%a") ~= nil
	local t = {
		{"à", "f"}, {"á", ","}, {"â", "d"}, 
		{"ã", "u"}, {"ä", "l"}, {"å", "t"}, 
		{"¸", "`"}, {"æ", ";"}, {"ç", "p"}, 
		{"è", "b"}, {"é", "q"}, {"ê", "r"}, 
		{"ë", "k"}, {"ì", "v"}, {"í", "y"}, 
		{"î", "j"}, {"ï", "g"}, {"ð", "h"}, 
		{"ñ", "c"}, {"ò", "n"}, {"ó", "e"}, 
		{"ô", "a"}, {"õ", "["}, {"ö", "w"}, 
		{"÷", "x"}, {"ø", "i"}, {"ù", "o"}, 
		{"ü", "m"}, {"û", "s"}, {"ú", "]"}, 
		{"ý", "'"}, {"/", "."}, {"ÿ", "z"}, 
		{"À", "F"}, {"Á", "<"}, {"Â", "D"}, 
		{"Ã", "U"}, {"Ä", "L"}, {"Å", "T"}, 
		{"¨", "~"}, {"Æ", ":"}, {"Ç", "P"}, 
		{"È", "B"}, {"É", "Q"}, {"Ê", "R"}, 
		{"Ë", "K"}, {"Ì", "V"}, {"Í", "Y"}, 
		{"Î", "J"}, {"Ï", "G"}, {"Ð", "H"}, 
		{"Ñ", "C"}, {"Ò", "N"}, {"Ó", "E"}, 
		{"Ô", "A"}, {"Õ", "{"}, {"Ö", "W"}, 
		{"×", "X"}, {"Ø", "I"}, {"Ù", "O"}, 
		{"Ü", "M"}, {"Û", "S"}, {"Ú", "}"}, 
		{"Ý", "\""}, {"Þ", ">"}, {"ß", "Z"}
	}

	for l in self:gmatch(".") do
		local fined = false
		for _, v in ipairs(t) do
			if l == v[b and 2 or 1] then
				l = v[b and 1 or 2]
				fined = true
				break
			end
		end
		if not fined then
			for _, v in ipairs(t) do
				if l == v[b and 1 or 2] then
					l = v[b and 2 or 1]
					break
				end
			end
		end
		result = (result .. l)
	end
	return result
end