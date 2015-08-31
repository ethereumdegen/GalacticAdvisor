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


    def self.collect_data
      puts "collecting data from crest "
      puts self.getNextDataPage

      jsondata = RestClient.get('https://api.github.com/users/admazzola/repos')
      marketdata = JSON.parse(jsondata)

      puts marketdata[0]["id"]

    end


#use https://github.com/rest-client/rest-client


end
