class ItemsController < ApplicationController
  def show
    item = Item.find(params[:id])
    item_props = %w(image_url description title)
    @props = item_props.inject({}) do |result, attribute|
      result.merge({attribute.to_sym => item.send(attribute)})
    end
  end
end
