#!/usr/bin/env python

# ~/GrovePi/Software/Python/grove_i2c_temp_hum_sensor_mini/grove_i2c_temp_hum_mini.py

import time,sys
import RPi.GPIO as GPIO
import smbus

rev = GPIO.RPI_REVISION
if rev == 2 or rev == 3:
    bus = smbus.SMBus(1)
else:
    bus = smbus.SMBus(0)

class th02:
	def getTemperature(self):
		bus.write_i2c_block_data(0x40, 0x03, [0x11])
		time.sleep(.7)
		
		t_raw=bus.read_i2c_block_data(0x40, 0x01, 3)
		temperature = (t_raw[1]<<8|t_raw[2])>>2
		return (temperature/32.0)-50.0
		
	def getHumidity(self):
		bus.write_i2c_block_data(0x40, 0x03, [0x01])
		time.sleep(.7)
		
		t_raw=bus.read_i2c_block_data(0x40, 0x01, 3)
		humidity = (t_raw[1]<<8|t_raw[2])>>4
		return (humidity/16.0)-24.0

t=th02()
temp=t.getTemperature()
humi=t.getHumidity()
print "%.3f %.3f" %(temp, humi)
