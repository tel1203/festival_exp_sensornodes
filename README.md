# festival_exp_sensornodes

- node1
ruby pollen_monitor.rb 192.168.101.2 60 Osaka001 /run/shm/sensor festival.ckp.jp 1883 stationsensors/stationsensors_osaka001/pollen

- node2: pm2.5
ruby pm25_monitor.rb [IP Addres] [Location] [Data Dir]
ex: ruby pm25_monitor.rb 192.168.101.3 Kameoka /run/shm/sensor
ex: ruby pm25_monitor.rb 192.168.101.4 Maya /run/shm/sensor

- node3: barometer
ruby barometer_monitor.rb [Location] [Data Dir]
ex: ruby barometer_monitor.rb Maya /run/shm/sensor

PYTHONPATH=/home/pi/GrovePi/Software/Python/grove_barometer_sensors/barometric_sensor_bmp180/ python barometer_read.py

- node4: accelerometer
ruby accelerometer_monitor.rb [Location] [Data Dir]
ex: ruby accelerometer_monitor.rb Maya /run/shm/sensor

PYTHONPATH=/home/pi/GrovePi/Software/Python/grove_accelerometer_16g/ python accelerometer_read.py

- node7
ruby meshlium_monitor.rb [Location] [Data Dir] [Meshlium IP Addr] [DB user] [DB pw] [DB name]
ex: ruby meshlium_monitor.rb Maya /run/shm/sensor 192.168.100.100 root libelium2007 MeshliumDB

