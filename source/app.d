module chat.main;

import std.stdio;

import std.string : fromStringz, toStringz;
import derelict.lua.lua;
import chat.lua;

/*void main()
{
    luaInit();
    luaRun();
    luaExit();

}*/

import chat.server;

__gshared Server server;
void main()
{

    luaLoad();
    server = new Server(12345);

    luaRegister("send", &lua_sendMessage);
    luaRegister("getClientsCount", &lua_getNumClients);
    luaInit();

    server.callback(&luaCallback);
    server.mainloop();
}

extern (C)
{
    nothrow int lua_sendMessage(lua_State* L)
    {
        try
        {
            //In: id(num), message(str)
            byte id = cast(byte) lua_tonumber(L, -2);
            const(char)[] msg = fromStringz(lua_tostring(L, -1));
            lua_pushnumber(L, cast(double) server.sendTo(id, msg));
            return 1;
        }
        catch
        {
            return (0);
        }
    }

    nothrow int lua_getNumClients(lua_State* L)
    {

        try
        {
            debug writeln("clientscount");
            debug writeln(chat.main.server);
            lua_pushnumber(L, cast(double) server.getClientsCount());
            return 1;
        }
        catch
        {
            return 0;
        }
    }
}
