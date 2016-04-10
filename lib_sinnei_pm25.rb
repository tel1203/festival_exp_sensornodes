#
# lib_sinnei_pm25.rb : library for getting measurement data about PM2.5 from Sinnei sensor
# 2016/03/29 : Teruaki Yokoyama
#

require "socket"

class Sensor_pm25
  def initialize(host, port)
    @host = host
    @port = port
  end
  
  def calc_chksum(cmd)
    sum=0
    for i in 0..cmd.length-1 do
      sum += cmd[i].ord
    end
    chkstr = sprintf("%X", sum%0x100)
  
    return (chkstr)
  end
  
  def make_cmdstr(cmd)
    chkstr = calc_chksum(cmd)
    output = cmd+chkstr+"\x03"
    result = send_cmd(output)
  
    return (result)
  end
  
  # CMD: Read STATUS
  def send_ST()
    cmd = "\x020130000ST"
    result = make_cmdstr(cmd)
  
    return (result)
  end
  
  # CMD: Read DATA
  # measurement time (sec)
  # mass concentration (ug/m^3)
  # temprature (Celcius)
  # humidty (%rh)
  # PM_AD value
  def send_RD()
    cmd = "\x020130000RD"
    result = make_cmdstr(cmd)
    return (result[11,16].unpack("SESSS"))
  end
  
  # CMD: Set Measuremet interval
  # time (min) : "00"|"01"|"05"|"10"|"15"|"30"|"60"
  def send_TS(time)
    cmd = "\x020150000TS"+time
    result = make_cmdstr(cmd)
    return (result)
  end
  
  # CMD: Read Measuremet interval
  def send_TR()
    cmd = "\x020130000TR"
    result = make_cmdstr(cmd)
    return (result)
  end
  
  def send_cmd(cmd)
    tcp = TCPSocket.open(@host, @port)
    tcp.write(cmd)
    result = tcp.recv(1024)
    tcp.close()
  
    return (result)
  end
  
end

