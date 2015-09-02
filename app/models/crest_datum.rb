class CrestDatum < ActiveRecord::Base
  require 'rest-client'

  #using self is a lot like using static in java

  @tradeRegionNames = ["Heimatar", "The Citadel", "The Forge", "Placid"]


  @collectMarketData = false

  @totalMarketPages = 20
  @currentMarketPage = 0

  @itemTypePageCount=0

  @itemTypeDiscoveryIndex = 0

  @itemTypesURL=''

  @currentItemTypesQuerying = nil

  @nextItemTypesPageIndex=0

#RestClient.get 'http://example.com/resource'

#RestClient.get 'http://example.com/resource', {:params => {:id => 50, 'foo' => 'bar'}}


  def self.tradeRegionNames
    return @tradeRegionNames
  end

    def self.setCollectMarketData(collect)
      @collectMarketData  = collect
    end


    def self.collectingMarketData
      return @collectMarketData
    end


    def self.collect_tags

      jsondata = RestClient.get('https://public-crest.eveonline.com/')
      crestURLs = JSON.parse(jsondata)

      regionsURL = crestURLs["regions"]["href"]
      @itemTypesURL = crestURLs["itemTypes"]["href"]

      jsondata = RestClient.get(regionsURL)  #there are 100 regions
      regionData = JSON.parse(jsondata)

      #add region items to db
      regionData["items"].each do |region|

        regionURL = region["href"]
        urlParts = regionURL.split("/")
        regionID = urlParts[-1].to_i

        regionName = region["name"]

        if(existingEntry = Region.find_by_id(regionID))

          existingEntry.name = regionName
          existingEntry.save

        else
          newEntry = Region.new
          newEntry.id = regionID
          newEntry.name = regionName
          newEntry.save
        end

      end




      jsondata = RestClient.get(@itemTypesURL)   #there are 27243 items
      itemTypesData = JSON.parse(jsondata)

      @itemTypePageCount = itemTypesData["pageCount"]
      @currentItemTypesQuerying = itemTypesData["items"]

    #  jsondata = RestClient.get @itemTypesURL, {:params => {:page => 2}}  #collect page 2 of the item types data also



    end


    #I store the parsed json of the current page (of 25 pages)
    #I iterate through every object in that large array of that page.. I turn the page when i reach the end


    def self.collect_item_types


     if(  @itemTypeDiscoveryIndex < @currentItemTypesQuerying.length)

        itemTypeQuerying = @currentItemTypesQuerying[@itemTypeDiscoveryIndex]


        itemTypeURL = itemTypeQuerying["href"]

        urlParts = itemTypeURL.split("/")
        itemTypeID = urlParts[-1].to_i

        p itemTypeURL

        begin
        jsondata = RestClient.get(itemTypeURL)   #there are 27243 items total
        itemTypeData = JSON.parse(jsondata)

        if(existingEntry = ItemType.find_by_id(itemTypeID))

          existingEntry.name = itemTypeData["name"]
          existingEntry.description = itemTypeData["description"]
          existingEntry.volume = itemTypeData["volume"]
          existingEntry.save

        else

        newEntry = ItemType.new
        newEntry.id = itemTypeID
        newEntry.name = itemTypeData["name"]
        newEntry.description = itemTypeData["description"]
        newEntry.volume = itemTypeData["volume"]
        newEntry.save

        end

        end

          @itemTypeDiscoveryIndex+=1

          itemType = ItemType.find_by_id(itemTypeID)

          #only collect market data if it is stale or doesnt exist
        if(itemType && (itemType.marketDataLastCollected == nil || (itemType.marketDataLastCollected - DateTime.now) > 1.week ) )

            if(itemTypeData["published"] == true && itemTypeData["volume"] && itemTypeData["volume"].to_i > 0 )
              self.collect_pricing( itemType   )
            end

        else
          p 'already have recent market data'
        end


     else
       #if we exhausted this page, go to the next one

       if(@nextItemTypesPageIndex < @itemTypePageCount )

       jsondata = RestClient.get@itemTypesURL, {:params => {:page => @nextItemTypesPageIndex}}
       @nextItemTypesPageIndex += 1
       itemTypesData = JSON.parse(jsondata)
       @currentItemTypesQuerying = itemTypesData["items"]

      else
       #do nothing - I am done
      end


     end





    end

    def self.collect_pricing(itemType)

      itemId = itemType.id

      tradeRegions = []

      Region.all.each do |region|

        if(@tradeRegionNames.include? ( region.name )   )
          tradeRegions << region
        end

      end


       tradeRegions.each do |tradeRegion|

        regionId = tradeRegion.id

        marketURL = 'https://public-crest.eveonline.com/market/'+regionId.to_s+'/types/'+itemId.to_s+'/history/'

        #p marketURL

        jsondata = RestClient.get(marketURL)
        marketData = JSON.parse(jsondata)


        RegionalItemPriceDatum.where(itemID: itemId).destroy_all  #remote the stale data

        history = marketData["items"]

        history.each do |entry|

          newPriceDatum = RegionalItemPriceDatum.new

          newPriceDatum.itemID = itemId
          newPriceDatum.regionID = regionId
          newPriceDatum.marketDate = entry["date"]

          newPriceDatum.volume = entry["volume"]
          newPriceDatum.avgPrice = entry["avgPrice"]
          newPriceDatum.lowPrice = entry["lowPrice"]
          newPriceDatum.highPrice = entry["highPrice"]
          newPriceDatum.orderCount = entry["orderCount"]

          newPriceDatum.save

          p 'saved market data'

        end

        itemType.marketDataLastCollected = DateTime.now
        itemType.save


        # p marketData
      end




    end


#use https://github.com/rest-client/rest-client


end
