class AreasController < ApplicationController

  def index
    @areas = Area.closest_from(Area.first.center, 400)
  end
end
