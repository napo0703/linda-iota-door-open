# -*- coding: utf-8 -*-
#! /usr/bin/env/ruby

# dependencies
require 'rubygems'
require 'sinatra/rocketio/linda/client'
require 'sinatra'

require './lib/iota_door.rb'

url   =  "http://linda.masuilab.org"
space =  "iota"

door = Iota_door.new

linda = Sinatra::RocketIO::Linda::Client.new url
ts = linda.tuplespace[space]

last_at = Time.now

linda.io.on :connect do  ## RocketIO's "connect" event
  puts "Linda connect!! <#{linda.io.session}> (#{linda.io.type})"

  ts.watch ["door","open"] do |tuple|
    puts tuple
    door.open
    ts.write ["door","open","success!"] if last_at < Time.now+5
  end
end

linda.io.on :disconnect do
  puts "RocketIO disconnected.."
end

linda.wait

# GET API
get '/open' do
  door.open
end
