#
# Pollen monitoring with Pollen-sensor made by Shinei-Technology
#
# ruby pollen_monitor.rb Pollen_sensor Period Location Data_storage MQTT_server MQTT_port MQTT_topic
# ruby pollen_monitor.rb 192.168.101.2 60 Osaka001 /run/shm/sensor festival.ckp.jp 1883 stationsensors/stationsensors_osaka001/pollen
#

require "./lib_sensornode.rb"
require "json"
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

sensor_ip = ARGV[0]
period = ARGV[1].to_i # Duration time for measrement in Second
location = ARGV[2]
dir = ARGV[3]
mqtt_host = ARGV[4]
mqtt_port = ARGV[5]
mqtt_topic = ARGV[6]
type = "pollen"

begin_time = Time.now.to_i
count_pollen = 0
count_other = 0

Thread.new do
  TCPSocket.open(sensor_ip, 10001) do |sock|
    while (true) do
      data = sock.recv(1024)
      c, p, s = data.strip.split(",")

      v = 8.0 * p.to_f/255.0
      i = (p.to_f - s.to_f) / (p.to_f + s.to_f)
#    printf("%s : %s %s %f %f : %s\n", Time.now, p, s, v, i, judge_pollen(p, s))
      if (judge_pollen(p, s) == true) then
        count_pollen += 1
      else
        count_other += 1
      end
    end
  end
end

while (true) do
  break if (Time.now.to_i > begin_time + period)
  sleep(0.1)
end

values = Hash.new
values["pollen"] = count_pollen
values["other"] = count_other
values["period"] = period
data = make_data(type, location, values)

save_sensordata(data, dir)
mqtt_publish(mqtt_host, mqtt_port, mqtt_topic, count_pollen)

