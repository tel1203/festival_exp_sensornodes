#!/usr/bin/env python

# MMA7660FC
# http://wiki.seeedstudio.com/wiki/Grove_-_I2C_3-axis_Accelerometer

import grovepi
import time
import smbus
import RPi.GPIO as GPIO
rev = GPIO.RPI_REVISION
if rev == 2 or rev == 3:
	bus = smbus.SMBus(1)
else:
	bus = smbus.SMBus(0)

def acc_xyz2():
	bus.write_i2c_block_data(0x04, 1, [20]+[0, 0, 0])

        time.sleep(.1)
	bus.read_byte(0x04)
	number = bus.read_i2c_block_data(0x04, 1)
        if number[1] > 32:
                number[1] = - (number[1] - 224)
        if number[2] > 32:
                number[2] = - (number[2] - 224)
        if number[3] > 32:
                number[3] = - (number[3] - 224)
        return (number[1], number[2], number[3])

for i in range(0,60):
	print "%.3f , %.3f , %.3f" %(grovepi.acc_xyz())
        time.sleep(1)


