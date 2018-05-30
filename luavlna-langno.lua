-- langno.lua
-- library for working with luatex's language numbers
-- glyph nodes have numerical lang field, but the language names for
-- these numbers aren't saved. 
--
-- this library tries to find language names by parsing `language.dat` file
-- 

local M = {}

local tex = tex or {}

local format = tex.formatname -- or "luatex"

-- languages object
local lang_obj = function(names, numbers)
	local obj = {}
	obj.__index = obj
	local self = setmetatable({},obj)
	self.names = names
	self.numbers = numbers
	-- get language name by number
	self.get_name = function(self, number)
		return self.numbers[number]
	end
	-- get language number by name
	self.get_number = function(self, name)
		return self.names[name]
	end
	return self
end


-- default language loader, language.dat file is parsed
local load_lang_dat = function(start)
  -- languages are saved in the file language.dat
  local lang_dat = kpse.find_file("language.dat")
  if not lang_dat then 
    return nil, "Cannot load file language.dat"
  end
  local f = io.open(lang_dat, "r")
  local i = start or 0
  local numlang = {} -- return language name 
  local langnum = {} -- return language number
  for line in f:lines() do
    -- match comment, equal sign and first word on a line
    local first, language = line:match("%s*([%%%=]?)([%a]*)")
    if first ~="%" then  -- ignore comments
      langnum[language] = i
      if first ~="=" then -- on lines starting with eq are language synonyms
        --print(i, language)
        numlang[i] = language
        i = i + 1
      end
    end
  end
  return lang_obj(langnum, numlang)--{numbers = numlang, names = langnum}
end

local load_lang_dat_lualatex = function()
  return load_lang_dat(1)
end

local load_csplain= function()
	local l = require "luavlna-csplain-langs"
	local langnum = {}
	local numlang = {}
	for k, v in pairs(l) do
		local first = k:gsub(" *;.*","")
		--print(first)
		langnum[first] = v
		for _,i in ipairs(v) do
			numlang[i] = first
		end
	end
	return lang_obj(langnum, numlang)
end


-- because different formats may use different ways to load languages
-- driver mechanism is provided.  
local drivers = {}
drivers["lualatex"] = load_lang_dat_lualatex
drivers["luatex"]  = load_lang_dat
drivers["default"] = load_lang_dat
drivers["csplain"] = load_csplain
drivers["pdfcsplain"] = load_csplain
drivers["luaplain"] = load_csplain

local load_languages = function(name)
  local name = name or format
	print ("Load driver: "..name)
  local func =  drivers[name] or drivers["default"]
  if not func then return nil, "Cannot find driver function "..name end
  return func()
end

-- only load_languages function is provided to the outside world
M.load_languages = load_languages

return M
--[[

-- sample usage:
local j = load_languages()
print(j:get_name(16))
print(j:get_number("slovak"))
for k, v in pairs(j.numbers) do
  print(k,v)
end
--]]

-- this may be used in future, if I find a way how does local language.dat
-- affect language loading
-- load local language.dat
--[[
local loc = kpse.var_value('TEXMFLOCAL') .. "tex/generic/config/language.dat"
local f, msg = io.open(loc, "r")
f:read("*all")
--]]
