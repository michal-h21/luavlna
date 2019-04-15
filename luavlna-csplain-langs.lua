local languages = {}
local function parse_language_lan(content)
  for name,  id in content:gmatch("preplang%s+.-%s+(.-)%s+.-%s(.-)%s+") do
    -- skip invalid languages
    if not name:match("%#") then
      languages[name] = id
    end
  end
end

local langfile = kpse.find_file("lua-hyphen.lan")
if langfile then
  local f = io.open(langfile, "r")
  local content = f:read("*all")
  parse_language_lan(content)
  f:close()
end


return languages

