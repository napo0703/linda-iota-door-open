#!/usr/bin/env ruby
require 'arduino_firmata'

class IotaDoor

  def initialize
    @arduino = ArduinoFirmata.connect ENV["ARDUINO"]
    puts "Arduino connect!! (firmata version v#{@arduino.version})"
  end

  def open
    puts "90 -> 0"
    @arduino.servo_write 10, 90
    sleep 1

    @arduino.servo_write 10, 0
    sleep 7

    puts "0 -> 180"
    @arduino.servo_write 10, 180
    sleep 1

    puts "180 -> 90"
    @arduino.servo_write 10, 90
  end
end
