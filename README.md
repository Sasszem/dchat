# dchat

A simple example, a test of the modules that I want to use later.

It's quick and dirty, and veery basic.

To run: `dub run --build=release`

To connect with a telnet client: `telnet localhost 12345`

## Lua API:

The server calls the `messageCallback(id, message)` function whenever a client send a message.
The id is the sender's id

The `send(id, msg)` send the message to the client with the specified id.
IDs starts at 0
The maximum id can be obtained by the `getClientsCount()` function.
