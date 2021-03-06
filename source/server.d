module chat.server;
import chat.main;
import std.stdio;
import std.socket;
import std.string : fromStringz;
import chat.client;

//import derelict.lua.lua;

class Server
{
public:

    this(ushort port)
    {
        debug writeln("A new server is being created");
        this.sock = new TcpSocket();
        sock.setOption(SocketOptionLevel.SOCKET, SocketOption.REUSEADDR, true);
        Address[] localAddress = getAddress("localhost", port);
        sock.bind(localAddress[0]);
        sock.listen(5);

    }

    void mainloop()
    {
        debug writeln("mainloop");
        while (running)
        {

            Socket client = sock.accept();
            writeln("Got a new connection!");
            Client cl = new Client(client, lastid, this);

            clients[lastid] = cl;
            cl.start();
            lastid++;
            if (lastid == 5)
            {
                running = false;
            }
        }
        sock.close();
        writeln("Connection closed!");
    }

    Client getClient(byte id)
    {
        return clients[id];
    }

    void receiveHandler(byte id)
    {

        debug writeln("[Client - ", id, "]", cast(char[]) clients[id].getBuffer());
        this.callbackFunction(id, cast(char[]) clients[id].getBuffer());
        //debug writeln("[Client - ", id, "]", "Data printed, now back to receving!");
    }

    bool isRunning()
    {
        return running;
    }

    int sendTo(byte id, const(char)[] msg)
    {
        return clients[id].send(msg);
    }

    void callback(void function(byte, char[]) f)
    {
        this.callbackFunction = f;
        debug writeln("[SERVER]Callback registrated at ", this.callbackFunction);
    }

    int getClientsCount()
    {
        return lastid - 1;
    }

private:
    void function(byte, char[]) callbackFunction;
    Client[byte] clients;
    byte lastid = 1;
    Socket sock;
    bool running = true;

}
