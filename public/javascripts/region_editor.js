(function($){  
  $.fn.RegionEditor = function(options) {  
    var editor = this;
    var defaults = {
      regions : [],
      selected_region_id: 0,
      vertices: [],
      map_options: {
        zoom: 14,
        mapTypeControl: false,
        streetViewControl: false,
        scaleControl: false,
        mapTypeId: google.maps.MapTypeId.ROADMAP
      },
      colors : [
        {dark: '#4572a7', light: '#9fb5d0'}, // blue
        {dark: '#aa4643', light: '#d19f9e'} // red
      ]
    };
    
    var options = $.extend(defaults, options);
    var map = initialize_google_map();
    add_regions();
    
    return this.each(function() {
      obj = $(this);
    });
    
    
    // Initialize Google Map
    function initialize_google_map() {
      var map_container = $('<div id="google_map" style ="'+options.map_style+'"></div>');
      editor.append(map_container);
      
      if(options.center != null) {
        options.map_options.center = new google.maps.LatLng(options.center.lat, options.center.lng);
      }
      var map = new google.maps.Map(map_container.get(0), options.map_options);
      render_controls(map);
      return map;
    }
    
    
    // Adds regions to the map
    function add_regions() {
      $.each(options.regions, function(index, region){
        
        var coordinates = new Array();
        $.each(region.points, function(){
          coordinates.push(new google.maps.LatLng(this[0], this[1]));
        });
        
        if(region.id == options.selected_region_id) {
          var polygon = new google.maps.Polygon({
            paths: coordinates,
            strokeColor: "#FF0000",
            strokeOpacity: 0.8,
            strokeWeight: 2,
            fillColor: "#FF0000",
            fillOpacity: 0.35,
            region_id: region.id,
            region_index: index,
            is_selected: true
          });
          prepare_for_edit(polygon);
          options.selected_polygon = polygon;
        } else {
          var polygon = new google.maps.Polygon({
            paths: coordinates,
            strokeColor: "#0000FF",
            strokeOpacity: 0.8,
            strokeWeight: 2,
            fillColor: "#6666FF",
            fillOpacity: 0.1,
            region_id: region.id,
            region_index: index,
            is_selected: false
          });
        }
        polygon.setMap(map);
      });
    }

    // Add handlers to a polygon so it can be edited
    function prepare_for_edit(polygon) {
      polygon.binder = new MVCArrayBinder(polygon.getPath());

      delete_vertices();
      polygon.getPath().forEach(function(latlng, index){
        options.vertices.push(new VertexWidget(map, polygon, index));
      });
    }
    
    function delete_vertices(){
      for (v in options.vertices) {
        options.vertices[v].marker.setMap(null);
      }
      options.vertices = new Array();
    }
    
    function render_controls(map){
      // --- Save changes ---
      save_btn = new_map_control('Save changes');
        
      google.maps.event.addDomListener(save_btn, 'click', function() {
        save_changes(options.selected_polygon);
      });
      
      map.controls[google.maps.ControlPosition.TOP_RIGHT].push(save_btn);

      // --- Reset polygon ---
      reset_btn = new_map_control('Reset polygon');
        
      google.maps.event.addDomListener(reset_btn, 'click', function() {
        reset_polygon(options.selected_polygon);
      });
      
      map.controls[google.maps.ControlPosition.TOP_RIGHT].push(reset_btn);
    }
    
    function new_map_control(title){
      return $('<div>' + title + '</div>')
        .css('font', '12px/12px Arial,sans-serif')
        .css('background', '#fff')
        .css('border', 'solid #000 2px')
        .css('margin', '5px')
        .css('padding', '2px 4px')
        .css('cursor', 'pointer')
        .get(0);
    }
    
    function reset_polygon(polygon) {
      var coordinates = new Array();
      $.each(options.regions[polygon.region_index].points, function(){
        coordinates.push(new google.maps.LatLng(this[0], this[1]));
      });
      polygon.setPath(coordinates);
      prepare_for_edit(polygon);
    }

    // Saves the changes on the selected polygon
    function save_changes(polygon) {
      coordinates = new Array();
      polygon.getPath().forEach(function(point, index){
        coordinates.push([point.lat(), point.lng()]);
      });
      
      $.post(options.update_url, {
        authenticity_token: options.authenticity_token,
        areas: [
          {
            id: polygon.region_id, 
            coordinates: coordinates
          }
        ]
      });
    }

  };
})(jQuery);


/* --------------------------------------------------------------
 * Creates a draggable marker and binds it to a vertext in a polygon
 * @params 
 *    {google.maps.Map} map: The map on which to attach the vertex widget. *
 *    {google.maps.Polygon} polygon: The polygon to which this vertex marker will bind to
 *    {int} index: The index of the point on the polygon to bind to
 --------------------------------------------------------------*/
function VertexWidget(map, polygon, index) {
  this.set('map', map);
  this.set('position', polygon.getPath().getAt(index));
  
  var marker = new google.maps.Marker({
    draggable: true,
    title: 'Move me!'
  });
  this.set('marker', marker);

  // Bind the marker map property to the VertexWidget map property
  marker.bindTo('map', this);

  // Bind the marker position property to the polygon binder
  marker.bindTo('position', polygon.binder, index.toString());
}
VertexWidget.prototype = new google.maps.MVCObject();



/* --------------------------------------------------------------
 * Use bindTo to allow dynamic drag of markers to refresh poly.
 --------------------------------------------------------------*/
function MVCArrayBinder(mvcArray){
  this.array_ = mvcArray;
}
MVCArrayBinder.prototype = new google.maps.MVCObject();
MVCArrayBinder.prototype.get = function(key) {
  if (!isNaN(parseInt(key))){
    return this.array_.getAt(parseInt(key));
  } else {
    this.array_.get(key);
  }
}
MVCArrayBinder.prototype.set = function(key, val) {
  if (!isNaN(parseInt(key))){
    this.array_.setAt(parseInt(key), val);
  } else {
    this.array_.set(key, val);
  }
}
