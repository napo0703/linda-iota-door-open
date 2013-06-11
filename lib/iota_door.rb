# -*- coding:utf-8 -*-
#! /usr/bin/env/ruby

require 'arduino_firmata'


class Iota_door
  arduino = ArduinoFirmata.connect

  def open
    puts "90 -> 0"
    90.downto(0) do |i|
      arduino.servo_write 10, i
      sleep 0.01
    end

    sleep 7

    puts "0 -> 180"
    0.upto(180) do |i|
      arduino.servo_write 10, i
      sleep 0.01
    end

    sleep 1

    puts "180 -> 90"
    180.downto(90) do |i|
      arduino.servo_write 10, i
      sleep 0.01
    end
  end
end
