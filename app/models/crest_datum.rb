class CrestDatum < ActiveRecord::Base
  require 'rest-client'

  #using self is a lot like using static in java

  @totalMarketPages = 20
  @currentMarketPage = 0

  @itemTypePageCount=0

  @itemTypeDiscoveryIndex = 0

  @itemTypesURL=''

  @currentItemTypesQuerying = nil

  @nextItemTypesPageIndex=0

#RestClient.get 'http://example.com/resource'

#RestClient.get 'http://example.com/resource', {:params => {:id => 50, 'foo' => 'bar'}}


    def self.getNextDataPage
      answer = @currentMarketPage;

      @currentMarketPage +=1

      return answer
    end


    def self.collect_tags

      jsondata = RestClient.get('https://public-crest.eveonline.com/')
      crestURLs = JSON.parse(jsondata)

      regionsURL = crestURLs["regions"]["href"]
      @itemTypesURL = crestURLs["itemTypes"]["href"]

      jsondata = RestClient.get(regionsURL)  #there are 100 regions
      regionData = JSON.parse(jsondata)

      jsondata = RestClient.get(@itemTypesURL)   #there are 27243 items
      itemTypesData = JSON.parse(jsondata)
    #  @totalItemTypeCount = itemTypesData["totalCount_str"].to_i
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

        if(existingEntry = ItemType.find(itemTypeID))

          existingEntry.name = itemTypeData["name"]
          existingEntry.description = itemTypeData["description"]
          existingEntry.save

        else

        o = ItemType.new
        o.id = itemTypeID
        o.name = itemTypeData["name"]
        o.description = itemTypeData["description"]
        o.save
        end

        #p itemTypeData
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



     @itemTypeDiscoveryIndex+=1
     
    end

    def self.collect_pricing
      puts "collecting data from crest "
      puts self.getNextDataPage



      #keep incrementing these IDs.. they get collected from collect_tags
      #can sent a request every 30th of a second if you want
      #there are 86400 seconds in a day
      regionId = 10000002
      itemId = 34


      jsondata = RestClient.get('https://public-crest.eveonline.com/market/'+regionId.to_s+'/types/'+itemId.to_s+'/history/')
      marketData = JSON.parse(jsondata)

      #p marketData


    end


#use https://github.com/rest-client/rest-client


end
