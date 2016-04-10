# festival_exp_sensornodes

- node1

- node2: pm2.5
ruby pm25_monitor.rb [IP Addres] [Location] [Data Dir]
ex: ruby pm25_monitor.rb 192.168.101.3 Kameoka /run/shm/sensor
ex: ruby pm25_monitor.rb 192.168.101.4 Maya /run/shm/sensor

- node3: barometer
ruby barometer_monitor.rb [Location] [Data Dir]
ex: ruby barometer_monitor.rb Maya /run/shm/sensor

- node4: accelerometer
ruby accelerometer_monitor.rb [Location] [Data Dir]
ex: ruby accelerometer_monitor.rb Maya /run/shm/sensor

- node5

- node6

- node7

