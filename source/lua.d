module chat.lua;
import chat.main;
import derelict.lua.lua;
public import derelict.lua.lua : lua_State;
import std.stdio;
import std.file;
import std.string;
import chat.client;

/*void receiveHandler(Server* sv,byte id)
{
writeln(*(sv).getClient(id).buffer);
}*/

__gshared lua_State* L;

void luaLoad()
{

    DerelictLua.load();

    L = luaL_newstate();

    luaL_openlibs(L);

}

extern (C) nothrow
{
    alias lua_CFunction = int function(lua_State*);

}

void luaRegister(string name, lua_CFunction f)
{
    lua_register(L, toStringz(name), f);

}

void luaInit()
{

    //lua_register(L, "read", &luaRegister);
    luaL_dofile(L, "source.lua");

}

void luaCallback(byte id, char[] msg)
{
    debug writeln("Inside callback");
    lua_getglobal(L, "messageCallback");
    debug writeln("Getglobal done");
    lua_pushnumber(L, id);
    debug writeln("Pushnumber done");
    lua_pushstring(L, msg.ptr);
    debug writeln("Pushstring done");
    lua_call(L, 2, 0);
    debug writeln("Left callback!");

}

void luaExit()
{
    lua_close(L);
}
