#
# accelerometer_monitor.rb : getting measurement data about accelerometer from grovepi sensor
#
# Usage:
#   $ ruby grove_accelerometer_MMA7660.rb Osaka001 /run/shm/sensor
#

require "./lib_sensornode.rb"
STDOUT.sync = true

class Sensor_accelerometer
  def Sensor_accelerometer::readdata()
    result = `cd /home/pi/festival_exp_sensornodes && PYTHONPATH=/home/pi/GrovePi/Software/Python python grove_accelerometer_MMA7660.py`
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
p result

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

