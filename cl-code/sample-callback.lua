local glyph_id = node.id("glyph")
local glue_id  = node.id("glue")

-- Převede pole nódu char na znak
local char = unicode.utf8.char 

local function mycallback(head)
	local text = {}
	for n in node.traverse(head) do
		if n.id == glyph_id then
			table.insert(text, char(n.char))
		elseif n.id == glue_id then
			table.insert(text, " ")
		end
	end
	print(table.concat(text, ", " ))
	return true
end

return mycallback
