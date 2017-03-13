#
# pm25_monitor.rb : getting measurement data about PM2.5 from Sinnei sensor
#
# Usage:
# ruby pm25_monitor.rb.rb PM25_sensor Location Data_storage MQTT_server MQTT_port MQTT_topic
# ruby pm25_monitor.rb 192.168.102.4 Osaka001 /run/shm/sensor festival.ckp.jp 1883 stationsensors/stationsensors_osaka001/pm25
#

require "./lib_sinnei_pm25.rb"
require "./lib_sensornode.rb"
STDOUT.sync = true

sensor_ip = ARGV[0]
location = ARGV[1]
dir = ARGV[2]
mqtt_host = ARGV[3]
mqtt_port = ARGV[4]
mqtt_topic = ARGV[5]
type = "pm25"

# READ DATA
# measurement time (sec)
# mass concentration (ug/m^3)
# temprature (Celcius)
# humidty (%rh)
# PM_AD value

s = Sensor_pm25.new(sensor_ip, 10001)

values = Hash.new
values["pm25"] = s.send_RD()[1]
data = make_data(type, location, values)

save_sensordata(data, dir)
mqtt_publish(mqtt_host, mqtt_port, mqtt_topic, s.send_RD()[1])

p s.send_RD()

