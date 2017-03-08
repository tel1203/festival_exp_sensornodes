#! /usr/bin/python

from adxl345 import ADXL345
import time

adxl345 = ADXL345()
 
for i in range(0,60):
	axes = adxl345.getAxes(True)
	print "%.3f , %.3f , %.3f" %(axes['x'] , axes['y'] , axes['z'])
	time.sleep(1)
 
