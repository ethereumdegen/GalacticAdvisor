require 'rufus-scheduler'

scheduler = Rufus::Scheduler.new

scheduler.every("5s") do
  CrestDatum.collect_data
end
