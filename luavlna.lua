-- Module luavlna
-- code originally created by Patrick Gundlach
-- http://tex.stackexchange.com/q/27780/2891
-- The code was adapted for plain TeX and added some more features
-- 1. It is possible to turn this functionality only for some letters
-- 2. Code now works even for single letters after brackets etc.
--
local M = {}
local utf_match = unicode.utf8.match
local utf_char  = unicode.utf8.char
local alpha = string.char(37).."a" -- alpha class, entering 
-- percent char directly caused error
local alphas = {}
local match_char = function(x) return utf_match(x,alpha) end
local match_table = function(x, chars)
  local chars=chars or {} 
  return chars[x] 
end 
local singlechars = {} -- {a=true,i=true,z=true, v=true, u=true, o = true} 

local initials = {}

local debug = false
local tex4ht = false
-- Enable processing only for certain letters
-- must be table in the {char = true, char2=true} form
local set_singlechars= function(lang,c)
  --print("Set single chars lua")
  local lang = tonumber(lang)
  print("language: "..lang)
  -- for k,_ in pairs(c) do print(k) end
  singlechars[lang] = c
end

local set_initials = function(lang,c)
  local lang = tonumber(lang)
  initials[lang]=c
end

set_initials(16,{["Č"] =  true, F= true, G = true})

local debug_tex4ht = function(head,p)
  --[[ local w = node.new("glyph")
  w.lang = tex.lang
  w.font = font.current()
  w.char = 64
  ]]
  --node.remove(head,node.prev(p))
  local w = node.new("whatsit", "special")
  w.data = "t4ht=<span style='background-color:red;width:2pt;'> </span>"
  return w, head
end

local debug_node = function(head,p)
  local w
  if tex4ht then
    w, head = debug_tex4ht(head,p)
  else
    w = node.new("whatsit","pdf_literal")                          
    w.data = "q 1 0 1 RG 1 0 1 rg 0 0 m 0 5 l 2 5 l 2 0 l b Q"           
  end
  node.insert_after(head,head,w)                                       
  node.insert_after(head,w,p)                                          
  -- return w
end


local set_debug= function(x)
  debug = x
end

local set_tex4ht = function()
  tex4ht = true
end

local insert_space = function(head)
  local p = node.new("penalty")                                           
  p.penalty = 10000                                                       
  local debug = debug or false
  if debug then
    local w = debug_node(head,p)
  else
    node.insert_after(head,head,p) 
  end
  return head
end

local is_alpha = function(c)
  local status = alphas[c]
  if not status then 
    status = utf_match(c, alpha)
    alphas[c] = status
  end
  return status
end

-- find whether letter is uppercase
local up_table = {}
local is_uppercase= function(c)
  if not is_alpha(c) then return false end
  local status = up_table[c]
  if status ~= nil then
    return status
  end
  status = unicode.utf8.upper(c) == c
  up_table[c] = status
  return status
end

local init_buffer = ""
local is_initial = function(c, lang)
  local allowed_initials = initials[lang] or {}
  init_buffer = init_buffer .. c
  if is_uppercase(c) and init_buffer == c then
    return true --allowed_initials[init_buffer]
  else
    local status = allowed_initials[init_buffer]
    if not status then 
      --print ("Not allowed initials:".. init_buffer)
      init_buffer = ""
    end
    return status
  end
end


local prevent_single_letter = function (head)                                   
  local singlechars = singlechars  -- or {} 
  -- match_char matches all single letters, but this method is abbandoned
  -- in favor of using table with enabled letters. With this method, multiple
  -- languages are supported
  local test_fn = match_table -- singlechars and match_table or match_char
  local space = true
  local init = false
  while head do
    local id = head.id 
    local nextn = head.next
    if id == 10 then 
      space=true
      init = is_initial " " -- reset initials
    elseif space==true and id == 37 and utf_match(utf_char(head.char), alpha) then -- a letter 
      local lang = head.lang
      local char = utf_char(head.char)
      init = is_initial(char,lang)
      local s = singlechars[lang] or {} -- load singlechars for node's lang
      --[[
      for k, n in pairs(singlechars) do
      for c,_ in pairs(n) do
      --print(type(k), c)
      end
      end
      --]]
      if test_fn(char, s) and nextn.id == 10 then    -- only if we are at a one letter word
        head = insert_space(head)
      end                                                                       
      space = false
      -- handle initials
      -- uppercase letter followed by period (code 46)
    elseif init and head.id == 37 and head.char == 46 and nextn.id == 10 then 
      print ("Iniciála: " ..init_buffer)
      head = insert_space(head)
    elseif head.id == 37 then
      local char = utf_char(head.char)
      if init then print "Init true" end
      init = is_initial(char, head.lang)
    end                                                                         
    head = head.next                                                            
  end                                                                             return  true
end               

M.preventsingle = prevent_single_letter
M.singlechars = set_singlechars
M.initials    = set_initials
M.set_tex4ht  = set_tex4ht
M.debug = set_debug
return M
