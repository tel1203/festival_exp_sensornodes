#
# Temp/Humi monitoring with Grove-sensor
#
# ruby grove_temp_humi_monitor.rb Location Data_storage MQTT_server MQTT_port MQTT_topic
# ruby grove_temp_humi_monitor.rb Osaka001 /run/shm/sensor festival.ckp.jp 1883 stationsensors/stationsensors_osaka001/temperature stationsensors/stationsensors_osaka001/humidity
#

require './lib_sensornode.rb'

location = ARGV[0]
dir = ARGV[1]
mqtt_host = ARGV[2]
mqtt_port = ARGV[3]
mqtt_topic1 = ARGV[4]
mqtt_topic2 = ARGV[5]
type = "grove_temp_humi"

result=`python grove_temp_humi_read.py`
temp,humi=result.split(" ")

values = Hash.new
values["temperature"] = temp
values["humidity"] = humi
data = make_data(type, location, values)

save_sensordata(data, dir)
mqtt_publish(mqtt_host, mqtt_port, mqtt_topic1, temp)
mqtt_publish(mqtt_host, mqtt_port, mqtt_topic2, humi)

