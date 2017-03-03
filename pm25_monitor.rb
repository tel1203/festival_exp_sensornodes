#
# pm25_monitor.rb : getting measurement data about PM2.5 from Sinnei sensor
#
# Usage:
#   $ ruby pm25_monitor.rb 192.168.101.3 Kameoka /run/shm/sensor
#   $ ruby pm25_monitor.rb 192.168.101.4 Maya    /run/shm/sensor
#

require "./lib_sinnei_pm25.rb"
require "./lib_sensornode.rb"
STDOUT.sync = true

if (ARGV[2] != nil) then
  dir = ARGV[2]
else
  dir = "./"
end
check_dir(dir)

# READ DATA
# measurement time (sec)
# mass concentration (ug/m^3)
# temprature (Celcius)
# humidty (%rh)
# PM_AD value

s = Sensor_pm25.new(ARGV[0], 10001)

begin
  data = make_data("pm25", ARGV[1], s.send_RD()[1])
  save_sensordata(data, dir)

  # MQTT publish
  host = "210.156.3.153" # festival.ckp.jp
#  host = "test.mosquitto.org"
  port = 1883
  value = data["value"]
  if (ARGV[1] == "Maya") then
    # Old topic
    topic = "stationsensors/stationsensors_MAYA/pm25"
    mqtt_publish(host, port, topic, value)
    # New topic @ 2017/03/03
    topic = "stationsensors/stationsensors_hyogo001/pm25"
    mqtt_publish(host, port, topic, value)
  end

  if (ARGV[1] == "Kameoka") then
    # Old topic
    topic = "stationsensors/stationsensors_KAMEOKA/pm25"
    mqtt_publish(host, port, topic, value)
    # New topic @ 2017/03/03
    topic = "stationsensors/stationsensors_kyoto001/pm25"
    mqtt_publish(host, port, topic, value)
  end

rescue
end  

