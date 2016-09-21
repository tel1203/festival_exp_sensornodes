#
# barometer_monitor.rb : getting measurement data about barometer from grovepi sensor
#
# Usage:
#   $ ruby barometer_monitor.rb Kameoka /run/shm/sensor
#   $ ruby barometer_monitor.rb Maya    /run/shm/sensor
#

require "./lib_sensornode.rb"
STDOUT.sync = true

class Sensor_barometer
  def Sensor_barometer::readdata()
    result = `cd /home/pi/barometer/ && python read_barometer.py`
    return (result.strip)
  end
end


if (ARGV[1] != nil) then
  dir = ARGV[1]
else
  dir = "./"
end
check_dir(dir)

# Read data
result = Sensor_barometer::readdata()
temprature, pressure = result.split(" ")

begin
  data = Hash.new
  data["type"] = "barometer"
  data["location"] = ARGV[0]
  data["measured_at"] = Time.now.to_i
  data["temprature"] = temprature
  data["pressure"] = pressure

  save_sensordata(data, dir)

  # MQTT publish
  host = "festival.ckp.jp"
#  host = "test.mosquitto.org"
  port = 1883
  value = data["pressure"]
  if (ARGV[0] == "Maya") then
    topic = "stationsensors/stationsensors_MAYA/barometer"
    mqtt_publish(host, port, topic, value)
  end

  if (ARGV[0] == "Kameoka") then
    topic = "stationsensors/stationsensors_KAMEOKA/barometer"
    mqtt_publish(host, port, topic, value)
  end

rescue
end  

