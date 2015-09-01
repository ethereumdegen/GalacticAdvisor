class ItemTypeController < ApplicationController


  def data

    items = ItemType.offset(params[:offset]).limit(params[:limit])

    if(params[:search] && params[:search].length > 0)
      items = ItemType.where("name LIKE ?", params[:search])
    end

    if(params[:sort] && params[:sort].length > 0)
      items = items.order(params[:sort] + " " + params[:order])
    end

    output = {:total => ItemType.all.length, :rows => items}

  #render json: output
    render json: output


  end



end
