-- langno.lua

kpse.set_program_name("luatex")

local M = {}

local tex = tex or {}

local format = tex.format or "luatex"

-- default language loader, language.dat file is parsed
local load_lang_dat = function()
  -- languages are saved in the file language.dat
  local lang_dat = kpse.find_file("language.dat")
  if not lang_dat then 
    return nil, "Cannot load file language.dat"
  end
  local f = io.open(lang_dat, "r")
  local i = 0
  local numlang = {} -- return language name 
  local langnum = {} -- return language number
  for line in f:lines() do
    -- match comment, equal sign and first word on a line
    local first, language = line:match("%s*([%%%=]?)([%a]*)")
    if first ~="%" then  -- ignore comments
      if first ~="=" then -- on lines starting with eq are language synonyms
        -- print(i, language)
        numlang[i] = language
        i = i + 1
      end
      langnum[language] = i
    end
  end
  return {numbers = numlang, names = langnum}
end

-- because different formats may use different ways to load languages
-- driver mechanism is provided.  
local drivers = {}
drivers["luatex"]  = load_lang_dat
drivers["default"] = load_lang_dat

local load_languages = function(name)
  local name = name or format or "default"
  local func =  drivers[name] 
  if not func then return nil, "Cannot find driver function "..name end
  return func()
end


local t = load_languages()
for k, v in pairs(t.numbers) do
  print(k,v)
end

print()

local loc = kpse.var_value('TEXMFLOCAL') .. "tex/generic/config/language.dat"
local f, msg = io.open(loc, "r")
f:read("*all")
