module AreasHelper
  def draw_areas(areas)
    [areas].flatten.collect do |area|
      %{
        area_border = new google.maps.Polygon({
          paths: [#{area.border_coordinates}],
          strokeColor: "#FF0000",
          strokeOpacity: 0.8,
          strokeWeight: 2,
          fillColor: "#FF0000",
          fillOpacity: 0.35
        });
  
        area_border.setMap(map);
      }
    end.join
  end
end
