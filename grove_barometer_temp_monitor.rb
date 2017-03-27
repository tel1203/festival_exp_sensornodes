#
# barometer_monitor.rb : getting measurement data about barometer from grovepi sensor
#
# Usage:
#   $ ruby grove_barometer_temp_monitor.rb Osaka001 /run/shm/sensor festival.ckp.jp 1883 stationsensors/stationsensors_osaka001/barometer
#

require "./lib_sensornode.rb"
STDOUT.sync = true

class Sensor_barometer
  def Sensor_barometer::readdata()
    result = `cd /home/pi/festival_exp_sensornodes && PYTHONPATH=/home/pi/GrovePi/Software/Python/grove_barometer_sensors/high_accuracy_hp206c_barometer python grove_barometer_temp_read.py
`
    return (result.strip)
  end
end

location = ARGV[0]
dir = ARGV[1]
mqtt_host = ARGV[2]
mqtt_port = ARGV[3]
mqtt_topic = ARGV[4]
type = "barometer"

# Read data
result = Sensor_barometer::readdata()
pressure, temperature = result.split(" ")

values = Hash.new
values["temperature"] = temperature
values["pressure"] = pressure
data = make_data(type, location, values)

save_sensordata(data, dir)
mqtt_publish(mqtt_host, mqtt_port, mqtt_topic, pressure)

