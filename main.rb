#!/usr/bin/env ruby
require 'rubygems'
require 'sinatra/rocketio/linda/client'
require File.expand_path 'lib/iota_door', File.dirname(__FILE__)

url   =  ENV["LINDA_BASE"]  || ARGV.shift || "http://linda.masuilab.org"
space =  ENV["LINDA_SPACE"] || "iota"

linda = Sinatra::RocketIO::Linda::Client.new url
ts = linda.tuplespace[space]
door = IotaDoor.new

working = false

linda.io.on :connect do  ## RocketIO's "connect" event
  puts "Linda connect!! <#{linda.io.session}> (#{linda.io.type})"
  ts.watch ["door","open"] do |tuple|
    next if working
    next if tuple.size != 2
    working = true
    door.open
    sleep 2
    ts.write ["door","open","success"]
    working = false
  end
end

linda.io.on :disconnect do
  puts "RocketIO disconnected.."
end

linda.wait
