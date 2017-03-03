require "socket"

def judge_pollen(p, s)
  v = 8.0 * p.to_f/255.0
  i = (p.to_f - s.to_f) / (p.to_f + s.to_f)
#  printf("%f %f\n", v, i)

  if (i > 0.2 and i < 0.3) then
    return (true) if (v > 2.0 and v < 8.0)
  end
  if (i > 0.3 and i < 0.5) then
    return (true) if (v > 1.5 and v < 8.0)
  end
  if (i > 0.5 and i < 0.6) then
    return (true) if (v > 2.0 and v < 8.0)
  end
  if (i > 0.6 and i < 0.7) then
    return (true) if (v > 3.0 and v < 8.0)
  end

  return (false)
end

server_ip = ARGV[0]
server_port = ARGV[1]

TCPSocket.open(server_ip, server_port) do |sock|
  while (true) do
    data = sock.recv(1024)
    c, p, s = data.strip.split(",")

    v = 8.0 * p.to_f/255.0
    i = (p.to_f - s.to_f) / (p.to_f + s.to_f)
    printf("%s : %s %s %f %f : %s\n", Time.now, p, s, v, i, judge_pollen(p, s))
  end
end
 
#1,157,090
#1,107,171
#1,032,006
#1,049,054
#1,074,095

