#
# accelerometer_monitor.rb : getting measurement data about accelerometer from grovepi sensor
#
# Usage:
<<<<<<< HEAD
#   $ ruby accelerometer_monitor.rb Location Data_storage MQTT_server MQTT_port MQTT_topic
#   $ ruby accelerometer_monitor.rb Hyogo001 /run/shm/sensor festival.ckp.jp 1883 stationsensors/stationsensors_hyogo001/
#   $ ruby accelerometer_monitor.rb Kyoto001 /run/shm/sensor festival.ckp.jp 1883 stationsensors/stationsensors_kyoto001/
#
# Note:
# - Grove Accelerometer Sensor
#   Grove - 3 Axis Digital Accelerometer(±16g) (SKU 101020054)
#   http://wiki.seeed.cc/Grove-3-Axis_Digital_Accelerometer-16g/
#
# - Dextar Libraries for GrovePI is required:
#   $ git clone https://github.com/DexterInd/GrovePi.git
#
# - This not submit data on MQTT due to the lack of definition of MQTT value about multiple Acc data.
#

require "./lib_sensornode.rb"
STDOUT.sync = true

class Sensor_accelerometer
  def Sensor_accelerometer::readdata(int sensor_type)
#    if (type == "101020054") then
#    result = `cd /home/pi/accelerometer/ && python read_accelerometer.py`
#    end
#    if (type == "101020054") then
      result = `PYTHONPATH=/home/pi/GrovePi/Software/Python/grove_accelerometer_16g/ python accelerometer_read.py`
#    end

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
result = Sensor_accelerometer::readdata()

values = Array.new
result.each_line do |line|
  x,y,z = line.split(",")
  value = [x.to_f, y.to_f, z.to_f]
  values.push(value)
end

begin
  data = Hash.new
  data["type"] = "accelerometer"
  data["location"] = ARGV[0]
  data["measured_at"] = Time.now.to_i
  data["values"] = values

  save_sensordata(data, dir)
rescue
end  

