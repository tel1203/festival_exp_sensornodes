#
# pm25.rb : getting measurement data about PM2.5 from Sinnei sensor
#
# Usage:
#   $ ruby pm25_init.rb 192.168.101.4 10001 [interval(min): "00"|"01"|"05"|"10"|"15"|"30"|"60"]
#


require "./lib_sinnei_pm25.rb"
STDOUT.sync = true

s = Sensor_pm25.new(ARGV[0], ARGV[1].to_i)

if (ARGV[2] == nil) then
  p s.send_ST
  p s.send_TR
else
end

