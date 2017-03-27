#!/usr/bin/env python

import hp206c
h= hp206c.hp206c()

temp=h.ReadTemperature()
pressure=h.ReadPressure()

print("%.3f %.3f\n" %(pressure, temp))

