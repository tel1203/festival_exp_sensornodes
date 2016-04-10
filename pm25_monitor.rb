#
# pm25_read.rb : getting measurement data about PM2.5 from Sinnei sensor
#
# Usage:
#   $ ruby pm25_read.rb 192.168.101.3 Kameoka /run/shm
#   $ ruby pm25_read.rb 192.168.101.4 Maya    /run/shm
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
rescue
end  

