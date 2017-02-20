function sendToAll(msg)
for i=1,getClientsCount(), 1
do
send(i,msg)
end
end


function messageCallback(id, message)
print("["..tostring(id).."]"..message)
sendToAll("["..id.."]"..message)
end
