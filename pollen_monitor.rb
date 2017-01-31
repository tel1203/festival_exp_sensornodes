require "socket"

server_ip = ARGV[0]
server_port = ARGV[1]
TCPSocket.open(server_ip, server_port){|s|
  print s.read
}

