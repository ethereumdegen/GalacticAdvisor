class CrestInterfaceController < ApplicationController

    def setCollectData
      collect = params['collect']


      CrestDatum.setCollectMarketData( collect == 'true' )

      #render text: collect
       redirect_to_back
    end

    def redirect_to_back(default = root_url)
       if !request.env["HTTP_REFERER"].blank? and request.env["HTTP_REFERER"] != request.env["REQUEST_URI"]
         redirect_to :back
       else
         redirect_to default
       end
     end

end
