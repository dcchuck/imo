class ItemsController < ApplicationController
  def show
    item = Item.find(params[:id])
    @props = {
      image_url: item.image_url
    }
  end
end
