class CrestDatum < ActiveRecord::Base
  require 'rest-client'

  #using self is a lot like using static in java

  @totalMarketPages = 20
  @currentMarketPage = 0




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
      itemTypesURL = crestURLs["itemTypes"]["href"]

      jsondata = RestClient.get(regionsURL)  #there are 100 regions
      regionData = JSON.parse(jsondata)

      jsondata = RestClient.get(itemTypesURL)   #there are 27243 items
      itemTypesData = JSON.parse(jsondata)
      jsondatapages = itemTypesData["pageCount"]

      jsondata = RestClient.get itemTypesURL, {:params => {:page => 2}}  #collect page 2 of the item types data also

      p itemTypesData

    end


    def self.collect_data
      puts "collecting data from crest "
      puts self.getNextDataPage



      #keep incrementing these IDs.. they get collected from collect_tags
      #can sent a request every 30th of a second if you want
      #there are 86400 seconds in a day
      regionId = 10000002
      itemId = 34


      jsondata = RestClient.get('https://public-crest.eveonline.com/market/'+regionId.to_s+'/types/'+itemId.to_s+'/history/')
      marketData = JSON.parse(jsondata)

      p marketData


    end


#use https://github.com/rest-client/rest-client


end
