require 'rufus-scheduler'

#do this on boot
CrestDatum.collect_tags

scheduler = Rufus::Scheduler.new

scheduler.every("5s") do
  CrestDatum.collect_data
end


scheduler.every("1d") do
  CrestDatum.collect_tags
end
