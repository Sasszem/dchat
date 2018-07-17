

function sendToAll(msg)
   for i=1,getClientsCount(), 1 do
      send(i,msg)
   end
end

nicks = {}

function table.slice(tbl, first, last, step)
  local sliced = {}

  for i = first or 1, last or #tbl, step or 1 do
    sliced[#sliced+1] = tbl[i]
  end

  return sliced
end


function messageCallback(id, message)

    print("["..tostring(id).."]"..message)
       if not nicks[id] then nicks[id]=tostring(id) end
    if message:sub(0,1)=="!" then

        message = message:sub(2)
        print("received command: "..message)
        if message:sub(0,4)=="nick" then
            nick = message:sub(6,string.len(message)-2)
            print(nicks[id] .."'s new name is "..nick.."\n")
            sendToAll(nicks[id] .."'s new name is "..nick.."\n")
            nicks[id]=nick
        end
    else
        print("["..nicks[id].."]"..message)
        sendToAll("["..nicks[id].."]"..message)
    end
end

