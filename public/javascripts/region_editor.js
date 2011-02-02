(function($){  
  $.fn.RegionEditor = function(options) {  
    var editor = this;
    var defaults = {
      regions : [],
      selected_region_id: 0,
      selected_polygon: null,
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
      
      // Right click to add a new point
      google.maps.event.addDomListener(map, 'rightclick', function(event) {
        if(confirm('Add new point?')) {
          add_new_point(event.latLng);
        }
      });
      return map;
    }
    
    
    // Adds controls to the map
    function render_controls(map){
      // --- Save changes ---
      options.save_btn = $('<div class="editor_button save disabled">Save changes</div>').css('margin-left', '5px');
      google.maps.event.addDomListener(options.save_btn.get(0), 'click', function() {
        if(!options.save_btn.hasClass('disabled')) {
          save_changes(options.selected_polygon);
        }
      });
      map.controls[google.maps.ControlPosition.TOP_RIGHT].push(options.save_btn.get(0));

      // --- Reset polygon ---
      options.reset_btn = $('<div class="editor_button reset disabled">Reset region</div>').css('margin-left', '5px');
      google.maps.event.addDomListener(options.reset_btn.get(0), 'click', function() {
        if(!options.save_btn.hasClass('disabled')) {
          reset_polygon(options.selected_polygon);
          prepare_for_edit(options.selected_polygon);
        }
      });
      map.controls[google.maps.ControlPosition.TOP_RIGHT].push(options.reset_btn.get(0));
    }

    
    // Adds regions to the map
    function add_regions() {
      $.each(options.regions, function(index, region){
        
        var coordinates = new Array();
        $.each(region.points, function(){
          coordinates.push(new google.maps.LatLng(this[0], this[1]));
        });
        
        var polygon = new google.maps.Polygon({
          paths: coordinates,
          strokeColor: "#0000FF",
          strokeOpacity: 0.8,
          strokeWeight: 2,
          fillColor: "#6666FF",
          fillOpacity: 0.1,
          region_id: region.id,
          region_index: index,
          is_selected: false,
          has_changed: false
        });
        polygon.setMap(map);

        if(region.id == options.selected_region_id) {
          prepare_for_edit(polygon);
        }
        
        // Polygon events
        google.maps.event.addListener(polygon, 'mouseover', function() {
          if(!polygon.is_selected) {
            mouseover_region(polygon);
          }
          $('.region_details').html($('<h4>'+ options.regions[polygon.region_index].name +'</h4>'))
        });
        google.maps.event.addListener(polygon, 'mouseout', function() {
          if(!polygon.is_selected) {
            mouseout_region(polygon);
          }
          $('.region_details').html();
        });
        google.maps.event.addListener(polygon, 'click', function() {
          console.log(options.selected_polygon.has_changed)
          if(options.selected_polygon.has_changed && confirm('The region has changed. Do you want to save changes?')) {
            save_changes(options.selected_polygon);
          }
          reset_polygon(options.selected_polygon);
          prepare_for_edit(polygon);
        });
        
      });
    }

    function mouseover_region(polygon) {
      polygon.setOptions({
        strokeColor: "#FF0000",
        strokeOpacity: 0.8,
        strokeWeight: 2,
      });
    }

    function mouseout_region(polygon) {
      polygon.setOptions({
        strokeColor: "#0000FF",
        strokeOpacity: 0.8,
        strokeWeight: 2,
        fillColor: "#6666FF",
        fillOpacity: 0.1
      });
    }

    // Adds handlers to each vertex of a polygon so it can be edited
    function prepare_for_edit(polygon) {
      polygon.binder = new MVCArrayBinder(polygon, options.save_btn, options.reset_btn);

      // Add vertex handlers to the polygon
      polygon.getPath().forEach(function(latlng, index){
        options.vertices.push(new VertexWidget(map, polygon, index));
      });
      
      // Change color
      polygon.setOptions({
        strokeColor: "#FF0000",
        strokeOpacity: 0.8,
        strokeWeight: 2,
        fillColor: "#FF0000",
        fillOpacity: 0.35,
        is_selected: true
      });
      options.selected_polygon = polygon;
    }
    
    // Deletes all the vertices from the map
    function delete_vertices(){
      for (v in options.vertices) {
        options.vertices[v].marker.setMap(null);
      }
      options.vertices = new Array();
    }
    
    // Returns a polygon to it's original coordinater
    function reset_polygon(polygon) {
      var coordinates = new Array();
      $.each(options.regions[polygon.region_index].points, function(){
        coordinates.push(new google.maps.LatLng(this[0], this[1]));
      });
      polygon.setPath(coordinates);
      delete_vertices();
      options.save_btn.addClass('disabled');
      options.reset_btn.addClass('disabled');
      polygon.has_changed = false;
      
      // Change color
      polygon.setOptions({
        strokeColor: "#0000FF",
        strokeOpacity: 0.8,
        strokeWeight: 2,
        fillColor: "#6666FF",
        fillOpacity: 0.1
      })
    }

    // Saves the changes on the selected polygon
    function save_changes(polygon) {
      new_points = new Array();
      polygon.getPath().forEach(function(point, index){
        new_points.push([point.lat(), point.lng()]);
      });
      
      $.post(options.update_url, {
        authenticity_token: options.authenticity_token,
        areas: [
          {
            id: polygon.region_id, 
            coordinates: new_points
          }
        ],
        success: function(){
          // Update the regions array witht the new saved coordinates
          options.regions[polygon.region_index].points = new_points;
          
          // Reset buttons state
          set_polygon_changed(polygon, false)
          
          // Notify the user
          obj.prepend($('<div class="flash_message notice">Saved!</div>'));
          setTimeout(function(){
            $('.flash_message.notice').fadeOut('slow', function(){$(this).remove()});
          }, 5000);
        }
      });
    }

    function add_new_point(latLng) {
      var polygon = options.selected_polygon;
      
      // Collect the distances between the new point and every polygon vertex
      var distances = new Array();
      polygon.getPath().forEach(function(poly_latLng, index){
        distances.push({
          index: index, 
          distance: google.maps.geometry.spherical.computeDistanceBetween(latLng, poly_latLng)
        });
      });
      // Sort the distances
      distances.sort(function(a,b){
        return a.distance - b.distance;
      });
      
      
      var coordinates = new Array();
      var added_new_coordinate = false;
      polygon.getPath().forEach(function(poly_latLng, index){
        coordinates.push(poly_latLng);
        if(!added_new_coordinate && (index == distances[0].index || index == distances[1].index)) {
          coordinates.push(latLng);
          added_new_coordinate = true;
        }
      });
      polygon.setPath(coordinates);
      set_polygon_changed(polygon, true)
      delete_vertices();
      prepare_for_edit(polygon)
    }
    
    function set_polygon_changed(polygon, changed) {
      if(changed) {
        polygon.has_changed = true;
        options.save_btn.removeClass('disabled');
        options.reset_btn.removeClass('disabled');
      } else {
        options.save_btn.addClass('disabled');
        options.reset_btn.addClass('disabled');
        polygon.has_changed = false;
      }
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
function MVCArrayBinder(polygon, save_btn, reset_btn){
  this.polygon_ = polygon;
  this.array_ = polygon.getPath();
  this.save_btn_ = save_btn;
  this.reset_btn_ = reset_btn;
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
  if(this.polygon_.has_changed == false) {
    this.polygon_.has_changed = true;
    this.save_btn_.removeClass('disabled');
    this.reset_btn_.removeClass('disabled');
  }
  if (!isNaN(parseInt(key))){
    this.array_.setAt(parseInt(key), val);
  } else {
    this.array_.set(key, val);
  }
}
