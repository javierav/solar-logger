#!/usr/bin/env ruby

$stdout.sync = true

require "bundler/inline"

gemfile do
  source "https://rubygems.org"

  gem "huawei_solar", "0.0.2"
  gem "sequel"
  gem "sqlite3"
end

KEYS = %i[
  inverter_pv1_voltage inverter_pv1_current inverter_pv2_voltage inverter_pv2_current
  inverter_input_power inverter_output_voltage inverter_output_current inverter_output_power
  inverter_power_factor inverter_efficiency inverter_temperature inverter_daily_energy
  inverter_grid_frequency meter_grid_voltage meter_grid_current meter_grid_power meter_power_factor
  meter_grid_frequency
].freeze

def perform
  data = HuaweiSolar.new("192.168.0.110", 502).read(KEYS)
  db = Sequel.sqlite("db/solar.db")

  hash = KEYS.map.with_index do |key, index|
    [key, data[index]]
  end.to_h

  # DB.create_table :archive do
  #   primary_key :id
  #   Time :time
  #   keys.each { |k| Float k }
  # end

  id = db[:archive].insert(hash.merge(time: Time.now))

  puts "#{Time.now} - #{id} - #{hash.inspect} \n\n"

  sleep 10
rescue StandardError => e
  puts "Error rescued #{e}"
end

loop do
  perform
end
