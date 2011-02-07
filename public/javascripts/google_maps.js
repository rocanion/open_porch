var map = null;
var center_marker = null;
var geocoder = new google.maps.Geocoder();
var regions = new Array()
var colors = {
  red: '#aa4643',
  blue: '#4572a7'
}

function initialize_gmap(id, center_lat, center_lng, options, bounds) {
  var defaults = {
    zoom: 14,
    center: new google.maps.LatLng(center_lat, center_lng),
    mapTypeControl: false,
    streetViewControl: false,
    scaleControl: false,
    mapTypeId: google.maps.MapTypeId.ROADMAP
  }
  var options = $.extend(defaults, options);
  
  map = new google.maps.Map(id, options);
  
  // Adjusting the zoom level if bounds were provided
  if (bounds != null) {
    console.log(bounds)
    map.fitBounds(new google.maps.LatLngBounds(
      new google.maps.LatLng(bounds[0][0], bounds[0][1]),
      new google.maps.LatLng(bounds[1][0], bounds[1][1])
    ));
  }
}

function add_marker(lat, lng, title, options){
  var defaults = {
    position: new google.maps.LatLng(lat, lng), 
    map: map, 
    title: title
  }
  var options = $.extend(defaults, options);
  
  return new google.maps.Marker(options);
}

function delete_marker(marker) {
  if (marker) {
    marker.setMap(null);
    marker = null;
  }
}

function pan_to(lat, lng) {
  delete_marker(center_marker);
  center_marker = add_marker(lat, lng);
  map.panTo(new google.maps.LatLng(lat, lng));
}

function pan_to_address(address) {
  geocoder.geocode( { 'address': address }, function(results, status) {
    if (status == google.maps.GeocoderStatus.OK) {
      pan_to(results[0].geometry.location.lat(), results[0].geometry.location.lng());
    } else {
      alert("Geocode was not successful for the following reason: " + status);
    }
  });
}

function add_region(region_id, coordinates, style) {
  switch(style) {
    case 'selected':
      var polygon = new google.maps.Polygon({
        paths: coordinates,
        strokeColor: colors.red,
        strokeOpacity: 0.8,
        strokeWeight: 2,
        fillColor: colors.red,
        fillOpacity: 0.35,
        region_id: region_id,
        area_selected: true
      });
      break;
    default:
      var polygon = new google.maps.Polygon({
        paths: coordinates,
        strokeColor: colors.blue,
        strokeOpacity: 0.8,
        strokeWeight: 2,
        fillColor: colors.blue,
        fillOpacity: 0.1,
        region_id: region_id,
        area_selected: false
      });
  }
  regions.push(polygon);
  polygon.setMap(map);
  
  // Activate
  google.maps.event.addListener(polygon, 'mouseover', function() {
    if(polygon.area_selected == false) {
      mouseover_region(polygon);
    }
  });

  // Deactivate
  google.maps.event.addListener(polygon, 'mouseout', function() {
    if(polygon.area_selected == false) {
      mouseout_region(polygon);
    }
  });

  // Select
  google.maps.event.addListener(polygon, 'click', function() {
    select_region(polygon.region_id)
  });
}

function mouseover_region(polygon) {
  polygon.setOptions({
    strokeColor: colors.red,
    strokeOpacity: 0.8,
    strokeWeight: 2,
    fillColor: colors.red,
    fillOpacity: 0.35,
  });
  $('#area_' + polygon.region_id).addClass('hover');
}


function mouseout_region(polygon) {
  polygon.setOptions({
    strokeColor: colors.blue,
    strokeOpacity: 0.8,
    strokeWeight: 2,
    fillColor: colors.blue,
    fillOpacity: 0.1
  });
  $('#area_' + polygon.region_id).removeClass('hover');
}


function select_region(region_id) {
  $.each(regions, function(){
    if(this.region_id == region_id) {
      this.setOptions({area_selected: true});
      mouseover_region(this);
    } else {
      this.setOptions({area_selected: false});
      mouseout_region(this);
    }
  });
  
  $('ul.areas li').removeClass('selected');
  $('#area_' + region_id).addClass('selected');
  $('#user_area_id').val(region_id);
}
