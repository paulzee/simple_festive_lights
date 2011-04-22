simple_festive_lights
=====================
A simple Arduino festive lights project that repurposes a cheap < $5 basic string of basic LED lights and enhances them to provide PWM fade and flash routines.

The string used for the original project had 20 LED's, was originally operated off 2 x AA batteries, and had a simple on/ off switch with no other functions.

This project adds a bare bones Atmega328p-based Arduino board and a simple circuit containing a push button and N2222A transistor.
The original project used the [AnArduino kit](http://www.anatools.com/anarduino-kit/) from Anatools, purchased from [ebay](http://shop.ebay.com.au/anatools/m.html?_nkw=&_armrs=1&_from=&_ipg=&_trksid=p3686)

The sketch has ~10 settings/ routines, and the current setting is stored into EEPROM memory. This means the current setting is run on power on until it is changed.

The routines were adapted from the basic Arduino.cc exmaple sketches

Report bugs on our
[GitHub bug tracker](http://github.com/paulzee/simple_festive_lights/issues)

Copyright (C) 2010/11 by
[Paul Szymkowiak](http://twitter.com/#!/paulzee)

Released under the GPLv3 license
