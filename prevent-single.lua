-- Module prevent-single
-- code originally created by Patrick Gundlach
-- http://tex.stackexchange.com/q/27780/2891
-- The code was adapted for plain TeX and added some more features
-- 1. It is possible to turn this functionality only for some letters
-- 2. Code now works even for single letters after brackets etc.
--
local M = {}
local utf_match = unicode.utf8.match
local utf_char  = unicode.utf8.char
local match_char = function(x) return utf_match(x,"%a") end
local match_table = function(x, chars)local chars=chars or {}; return chars[x] end 
local singlechars = nil-- {a=true,i=true,z=true, v=true, u=true, o = true} 
local debug = false
-- Enable processing only for certain letters
-- must be table in the {char = true, char2=true} form
local set_singlechars= function(c)
	--print("Set single chars lua")
	--for k,_ in pairs(c) do print(k) end
	singlechars = c
end

local set_debug= function(x)
	debug = x
end

local prevent_single_letter = function (head)                                   
	local singlechars = singlechars 
	local test_fn = singlechars and match_table or match_char
	local space = true
	while head do
		local id = head.id 
		if id == 10 then 
			space=true
		elseif space==true and id == 37 and utf_match(utf_char(head.char), "%a") then -- a letter 
			if test_fn(utf_char(head.char), singlechars ) and head.next.id == 10 then    -- only if we are at a one letter word
				local p = node.new("penalty")                                           
				p.penalty = 10000                                                       
				if debug then
					local w = node.new("whatsit","pdf_literal")                          
					w.data = "q 1 0 1 RG 1 0 1 rg 0 0 m 0 5 l 2 5 l 2 0 l b Q"           
					node.insert_after(head,head,w)                                       
					node.insert_after(head,w,p)                                          
				else
					node.insert_after(head,head,p) 
				end
			end                                                                       
			space = false
		end                                                                         
		head = head.next                                                            
	end                                                                             return  true
end               

M.preventsingle = prevent_single_letter
M.singlechars = set_singlechars
M.debug = set_debug
return M

