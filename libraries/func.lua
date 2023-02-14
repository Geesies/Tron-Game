require('string')
function split(s, delimiter)
	result = {}
	for match in (s..delimiter):gmatch("(.-)"..delimiter) do
		table.insert(result, match)
	end
	return result
end
function check(itm,tab)
	for i,v in ipairs(tab) do
	  return v == itm
	  end
end
function find_str(str,tbl)
    for i, v in ipairs(tbl) do    
        return(string.find(string.lower(str),string.lower(v)))
    end
end
function table.contains(table, element)
	for _, value in pairs(table) do
	  if value == element then
		return true
	  end
	end
	return false
end
function boolToString(bool)
	if bool == false then
		string = "false"
	else
		string = "true"
	end
	return string
end
