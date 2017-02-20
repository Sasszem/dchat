module chat.client;

import core.thread;
import std.socket;
import std.stdio;
import chat.server;

ubyte[] greeting = cast(ubyte[]) "Hi there!";

class Client : Thread
{
public:

    this(Socket socket, byte id, Server ser)
    {
        sock = socket;
        assert(sock.blocking() == true);
        this.id = id;
        sv = ser;
        super(&run);
        debug writeln("[Client - ", id, "]", "A new client object successfully created!");
    }

    ubyte[] getBuffer()
    {
        return this.buffer[0 .. this.bufferSize];
    }

    int send(const(char)[] msg)
    {
        return cast(int) sock.send(msg);
    }

private:
    Socket sock;
    byte id;
    ubyte[1024] buffer;
    Server sv;
    ushort bufferSize;
    void run()
    {
        sock.send(greeting);
        while (sv.isRunning())
        {

            debug writeln("[Client - ", id, "]", "Waiting for incoming data...");
            auto ret = sock.receive(buffer);
            this.bufferSize = cast(ushort) ret;

            if (ret != Socket.ERROR)
            {
                if (ret == 0)
                {
                    break;
                }
                debug writeln("[Client - ", id, "]", "Calling receiving handler...");
                sv.receiveHandler(id);
            }
            else
            {
                debug writeln("[Client - ", id, "]", "Error in receiving!");
            }
            buffer[] = 0;

            debug writeln("[Client - ", id, "]", "Leaving run() loop");
        }
    }
}
