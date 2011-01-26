var map = null;
var center_marker = null;
var geocoder = new google.maps.Geocoder();


function initialize(id, center_lat, center_lng) {
  map = new google.maps.Map(id, {
    zoom: 14,
    center: new google.maps.LatLng(center_lat, center_lng),
    mapTypeControl: false,
    streetViewControl: false,
    scaleControl: false,
    mapTypeId: google.maps.MapTypeId.ROADMAP
  });
}

function add_marker(lat, lng, title){
  return new google.maps.Marker({
    position: new google.maps.LatLng(lat, lng), 
    map: map, 
    title: title
  });
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

function add_region(coordinates, style) {
  switch(style) {
    case 'selected':
      var polygon = new google.maps.Polygon({
        paths: coordinates,
        strokeColor: "#FF0000",
        strokeOpacity: 0.8,
        strokeWeight: 2,
        fillColor: "#FF0000",
        fillOpacity: 0.35
      });
      break;
    default:
      var polygon = new google.maps.Polygon({
        paths: coordinates,
        strokeColor: "#0000FF",
        strokeOpacity: 0.8,
        strokeWeight: 2,
        fillColor: "#6666FF",
        fillOpacity: 0.1,
        mouseover: function(a, b, c){
          console.log(a)
          console.log(b)
          console.log(c)
        }
      });
  }

  polygon.setMap(map); 
}