#
# meshlium_monitor.rb : getting measurement data from meshlium sensor
#
# Usage:
#   $ ruby meshlium_monitor.rb Kameoka /run/shm/sensor 192.168.100.100 root libelium2007 MeshliumDB
#   $ ruby meshlium_monitor.rb Maya    /run/shm/sensor 192.168.100.100 root libelium2007 MeshliumDB
#

require "mysql"
require "json"
require "./lib_sensornode.rb"
STDOUT.sync = true

def save_lastdata(values)
  f = open("_meshlium_lastdata.txt", "w")
  f.puts(values.to_json)
  f.close
end

def load_lastdata()
  begin
    f = open("_meshlium_lastdata.txt", "r")
    data = f.gets()
    f.close
    return (JSON.parse(data))
  rescue
    return (nil)
  end
end

if (ARGV[1] != nil) then
  dir = ARGV[1]
else
  dir = "./"
end
check_dir(dir)

# Read data
# pi@node7:~ $ mysql -h 192.168.100.100 -P 3306 -u root –p
# password: libelium2007
# IN_TEMP: 内部温度(Celsius)、TCA: 温度 (Celsius)
# HUMB: 湿度(%RH)、LUM: 照度 (Ohms)、MCP: 音量 (dBA)
# MCP, LUM, HUMB, IN_TEMP, TCA
# mysql> select id,value,timestamp from sensorParser where sensor="MCP" order by id desc limit 1;
# gem install ruby-mysql
# last_data table

#my = Mysql.connect('192.168.100.100', 'root', 'libelium2007', 'MeshliumDB')
my = Mysql.connect(ARGV[2], ARGV[3], ARGV[4], ARGV[5])

target_sensor = ["BAT", "HUMB", "HUMA", "IN_TEMP", "LUM", "MCP", "TCA"]
#query = "select id,value,timestamp from sensorParser where sensor='MCP' order by id desc limit 1"
query = "select * from last_data"
result = my.query(query)

values_last = load_lastdata()
if (values_last == nil) then
flag_update = true
values_last = Hash.new
end

values = Hash.new
result.each do |record|
id_wasp, sensor, value, timestamp = record
  if (id_wasp == "SmartCity" and target_sensor.index(sensor) != nil) then
    values_last[sensor] = Array.new if (values_last[sensor] == nil)
#    p record
#    p sensor
#    p values_last[sensor]
    if (record[3] != values_last[sensor][1])
      values[record[1]] = [record[2], record[3]]
    end
  end
end

if (values.size > 0) then
#  puts("SAVE")
  save_lastdata(values)

  # Monitored data
  data = Hash.new
  data["type"] = "meshlium"
  data["location"] = ARGV[0]
  data["measured_at"] = Time.now.to_i
  data["value"] = values
  save_sensordata(data, dir)

  # MQTT publish
  host = "festival.ckp.jp"
#  host = "test.mosquitto.org"
  port = 1883
  if (ARGV[0] == "Maya") then
    value = data["value"]["IN_TEMP"][0]
    topic = "stationsensors/stationsensors_MAYA/temperature"
    mqtt_publish(host, port, topic, value)

    value = data["value"]["HUMB"][0]
    topic = "stationsensors/stationsensors_MAYA/humidity"
    mqtt_publish(host, port, topic, value)
  end

  if (ARGV[0] == "Kameoka") then
    value = data["value"]["TCA"][0]
    topic = "stationsensors/stationsensors_KAMEOKA/temperature"
    mqtt_publish(host, port, topic, value)

    value = data["value"]["HUMA"][0]
    topic = "stationsensors/stationsensors_KAMEOKA/humidity"
    mqtt_publish(host, port, topic, value)
  end

end

exit
