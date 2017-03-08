#!/usr/bin/python

import smbus
import RPi.GPIO as GPIO
#import grovepi
from grove_i2c_barometic_sensor_BMP180 import BMP085

bmp = BMP085(0x77, 1)

rev = GPIO.RPI_REVISION
if rev == 2 or rev == 3:
    bus = smbus.SMBus(1)
else:
    bus = smbus.SMBus(0)

temp = bmp.readTemperature()
pressure = bmp.readPressure()

print "%.2f %.2f" % (temp, pressure / 100.0)

