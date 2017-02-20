import socket

sock=socket.socket()
sock.connect(("localhost",12345))
print(sock.recv(1024))
sock.send("Hi!".encode())
sock.send(str(input()).encode())
sock.shutdown(socket.SHUT_RDWR)
sock.close()
