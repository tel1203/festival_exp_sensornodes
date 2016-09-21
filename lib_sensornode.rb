#
# lib_sensor.rb : common functions for sensor nodes
#   2016/04 Teruaki Yokoyama
#

require "fileutils"
require "json"
require "mqtt"

def check_dir(dir)
  begin
    File::ftype(dir)
  rescue Errno::ENOENT
    FileUtils.mkdir_p(dir)
  end

  # check dir?
  raise if (FileTest::directory?(dir) != true)

end

# Save sensor data "data" into specific "dir"
def save_sensordata(data, dir="./")
  fname = sprintf("/Sensor-%s-%s.txt", data["type"], Time.now.strftime("%Y%m%d-%H%M%S"))
  
  f = open(dir + fname, "w")
  f.puts(data.to_json)
  f.close
end

# Make data structure
def make_data(type, location, value)
  data = Hash.new
  data["type"] = type
  data["location"] = location
  data["measured_at"] = Time.now.to_i
  data["value"] = value

  return (data)
end

def mqtt_publish(host, port, topic, message)
  MQTT::Client.connect(host: host,
                       port: port,
                      ) do |client|
    client.publish(topic, message)
  end
end
# mqtt_publish("test.mosquitto.org", 1883, "test", "From Ruby!")
# mqtt_publish("festival.ckp.jp", 1883, topic, value)

