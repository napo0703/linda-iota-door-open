#!/usr/bin/env ruby
require 'rubygems'
require 'eventmachine'
require 'em-rocketio-linda-client'
require 'arduino_firmata'
$stdout.sync = true

EM::run do
  arduino = ArduinoFirmata.connect ENV["ARDUINO"], :eventmachine => true
  url   =  ENV["LINDA_BASE"]  || ARGV.shift || "http://linda.masuilab.org"
  space =  ENV["LINDA_SPACE"] || "iota"
  puts "connecting.. #{url}"
  linda = EM::RocketIO::Linda::Client.new url
  ts = linda.tuplespace[space]

  linda.io.on :connect do  ## RocketIO's "connect" event
    puts "Linda connect!! <#{linda.io.session}> (#{linda.io.type})"
    last_at = Time.now

    ts.watch ["door","open"] do |tuple|
      p tuple
      next if tuple.size != 2
      next if last_at + 5 > Time.now
      arduino.servo_write 9, 90
      sleep 1
      arduino.servo_write 9, 20
      sleep 1
      arduino.servo_write 9, 90
      tuple << "success"
      ts.write tuple
      last_at = Time.now
    end

    ts.watch ["door","close"] do |tuple|
      p tuple
      next if tuple.size != 2
      next if last_at + 5 > Time.now
      arduino.servo_write 9, 90
      sleep 1
      arduino.servo_write 9, 160
      sleep 1
      arduino.servo_write 9, 90
      tuple << "success"
      ts.write tuple
      last_at = Time.now
    end
  end

  linda.io.on :disconnect do
    puts "RocketIO disconnected.."
  end
end
