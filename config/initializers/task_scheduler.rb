require 'rufus-scheduler'

#do this on boot
CrestDatum.collect_tags

scheduler = Rufus::Scheduler.new


scheduler.every("10s") do
  if( CrestDatum.collectingMarketData )
  CrestDatum.collect_item_types
  end
end



scheduler.every("1d") do
  CrestDatum.collect_tags
end
