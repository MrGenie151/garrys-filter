if file.Exists("garrys-filter","DATA") == false then
	file.CreateDir("garrys-filter")
end

if file.Exists("garrys-filter/filter.txt","DATA") == false then
	local txtToWrite = [[fuck,shit,bitch,dick,sex,intercourse,penis,pussy,cunt,cuck,damn,ass]]
	file.Write("garrys-filter/filter.txt",txtToWrite)
end

local bannedWords = string.Split(file.Read("garrys-filter/filter.txt","DATA"),",")

function createTagging(stringThing)
	local tagged = ""
	for i=1, string.len(stringThing) do
		tagged = tagged + "#" --a
	end
	return tagged
end

function compileTable(tbl,sep)
	sep = sep or " "
	local comstr = ""
	for i,v in pairs(tbl) do
		comstr = comstr + v
		--print(tostring(i) + "current index")
		--print(tostring(#tbl) + "lenght")
		--if not i == #tbl then
		comstr = comstr + sep
		--end
	end
	return comstr
end

hook.Add("PlayerSay","FilterStuff", function(sender,text,teamChat)
	local words = string.Split(text," ")
	for i,v in pairs(words) do
		for idx,word in pairs(bannedWords) do
			local wordLen = string.len(word)
			local counter = 0
			local lpos = 0
			--sender:ChatPrint(word)
			for idx2=1,wordLen do
				local letter = string.sub(word,idx2,idx2)
				--print(letter)
				local found = string.find(v,letter,lpos + 1)

				if found then
					--sender:ChatPrint("Found at string pos " + tostring(found))
					--sender:ChatPrint("Found at global string pos " + tostring(found + lpos))
					--sender:ChatPrint("What is lpos? " + tostring(lpos))
					--sender:ChatPrint("Is it farther? " + tostring(found > lpos))
				end

				if found and found > lpos then--and found == lpos then
					lpos = found
					--sender:ChatPrint("What is lpos again? " + tostring(lpos))
					counter = counter + 1
					--sender:ChatPrint(string.format("Found that %s!",letter))
				else
					break
				end

				--sender:ChatPrint("Counter: " + tostring(counter))
			end
			if counter == wordLen then
				--sender:ChatPrint("Word found! It was " + word)
				words[i] = createTagging(v)
			end
		end
	end
	--print(table.ToString(words),"Word Stuff")
	return compileTable(words)
end)

concommand.Add("gfilter_add_banned_word",function(plr, cmd, args)
	file.Append("garrys-filter/filter.txt","," + args[1])
	string.Split(file.Read("garrys-filter/filter.txt","DATA"),",")
	string.Split(file.Read("garrys-filter/filter.txt","DATA"),",")
end)

concommand.Add("gfilter_remove_banned_word",function(plr, cmd, args)
	file.Write("garrys-filter/filter.txt",string.gsub(file.Read("garrys-filter/filter.txt","DATA"),"," + args[1],""))
	string.Split(file.Read("garrys-filter/filter.txt","DATA"),",")
	string.Split(file.Read("garrys-filter/filter.txt","DATA"),",")
end)
