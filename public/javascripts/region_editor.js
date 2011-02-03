(function($){  
  $.fn.RegionEditor = function(options) {  
    var editor = this;
    var EDIT_MODE = 0;
    var CREATE_MODE = 1;
    var defaults = {
      mode: EDIT_MODE,
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
      colors : {
        red: '#aa4643',
        blue: '#4572a7'
      }
    };
    
    var options = $.extend(defaults, options);
    var map = initialize_google_map();
    $.each(options.regions, add_region); // Add all the regions to the map
    
    return this.each(function() {
      obj = $(this);
    });
    
    
    // -------------------------
    // Initialize Google Map
    // -------------------------
    function initialize_google_map() {
      var map_container = $('<div id="google_map" style ="'+options.map_style+'"></div>');
      editor.append(map_container);
      
      // Setting the center of the map
      if(options.center != null) {
        options.map_options.center = new google.maps.LatLng(options.center.lat, options.center.lng);
      }
      
      // Creating the map
      var map = new google.maps.Map(map_container.get(0), options.map_options);
      render_controls(map);
      
      // Right click to add a new point to the selected region (EDIT_MODE)
      google.maps.event.addDomListener(map, 'rightclick', function(event) {
        if(options.mode == EDIT_MODE) {
          if(confirm('Add new point?')) {
            add_new_point_to_polygon(event.latLng);
          }
        }
      });
      
      // Add the click event to add a point to a new region (CREATE_MODE)
      google.maps.event.addListener(map, 'click', function(event) {
        if(options.mode == CREATE_MODE) {
          add_point_to_new_region(event.latLng);
        }
      });
      
      return map;
    }
    
    // -------------------------
    // Adds controls to the map
    // -------------------------
    function render_controls(map){
      // --- Save changes ---
      options.save_btn = $('<div class="editor_button save disabled">Save changes</div>').css('margin-left', '5px');
      google.maps.event.addDomListener(options.save_btn.get(0), 'click', function() {
        if(!options.save_btn.hasClass('disabled')) {
          ajax_update(options.selected_polygon);
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

      // --- New region ---
      options.new_region_btn = $('<div class="editor_button reset">New region</div>').css('margin-left', '5px');
      google.maps.event.addDomListener(options.new_region_btn.get(0), 'click', function() {
        switch(options.mode) {
          case EDIT_MODE:
            if(options.selected_polygon.has_changed) {
              if(confirm('This region has changed. Discard changes?')) {
                switch_to_mode(CREATE_MODE);
              }
            } else {
              switch_to_mode(CREATE_MODE);
            }
            break;
          case CREATE_MODE:
            switch_to_mode(EDIT_MODE);
            prepare_for_edit(options.selected_polygon);
            break;
        }
      });
      map.controls[google.maps.ControlPosition.TOP_RIGHT].push(options.new_region_btn.get(0));
    }
    
    // -------------------------
    // Changes between edit and create modes
    // -------------------------
    function switch_to_mode(mode) {
      switch(mode) {
        
        case CREATE_MODE:
          reset_polygon(options.selected_polygon);
          options.new_region_btn.html('Cancel');
          options.mode = CREATE_MODE;
          // Create the temporary polyline that will hold the region coordinates
          options.tmp_poly = new google.maps.Polyline({
            strokeColor: options.colors.red,
            strokeOpacity: 1.0,
            strokeWeight: 3
          });
          options.tmp_poly.setMap(map);
          break;
        
        case EDIT_MODE:
          delete_vertices();
          options.tmp_poly.setMap(null);
          options.new_region_btn.html('New region');
          options.mode = EDIT_MODE;
          break;
      }
    }
    
    // -------------------------
    // Adds a new region to the map
    // -------------------------
    function add_region(index, region) {
      // Prepare the coordinates for the polygon
      var coordinates = new Array();
      $.each(region.points, function(){
        coordinates.push(new google.maps.LatLng(this[0], this[1]));
      });
      
      // Create the polygon
      var polygon = new google.maps.Polygon({
        paths: coordinates,
        region_id: region.id,
        region_index: index,
        is_selected: false,
        has_changed: false
      });
      polygon.setMap(map);
      set_polygon_style(polygon, 'mouseout');

      // Activate it if it's the seleted polygon
      if(region.id == options.selected_region_id) {
        prepare_for_edit(polygon);
        $('.region_details').html(options.regions[options.selected_polygon.region_index].name);
      }
      
      // mouseover event
      google.maps.event.addListener(polygon, 'mouseover', function() {
        if(!polygon.is_selected && options.mode == EDIT_MODE) {
          set_polygon_style(polygon, 'mouseover');
        }
        $('.region_details').html(options.regions[polygon.region_index].name)
      });
      // mouseout event
      google.maps.event.addListener(polygon, 'mouseout', function() {
        if(!polygon.is_selected && options.mode == EDIT_MODE) {
          set_polygon_style(polygon, 'mouseout');
        }
        $('.region_details').html(options.regions[options.selected_polygon.region_index].name)
      });
      // click event
      google.maps.event.addListener(polygon, 'click', function() {
        if(!polygon.is_selected && options.mode == EDIT_MODE) {
          if(options.selected_polygon.has_changed) {
            if(confirm('This region has changed. Discard changes?')) {
              reset_polygon(options.selected_polygon);
              prepare_for_edit(polygon);
            }
          } else {
            reset_polygon(options.selected_polygon);
            prepare_for_edit(polygon);
          }
        }
      });
    }

    // -------------------------
    // Changes the color of a polygon as well as any other options passed in style_options 
    // -------------------------
    function set_polygon_style(polygon, style, style_options) {
      switch(style) {
        case 'mouseout':
          defaults = {
            strokeColor: options.colors.blue,
            strokeOpacity: 0.8,
            strokeWeight: 2,
            fillColor: options.colors.blue,
            fillOpacity: 0.1
          }
          break;
        case 'mouseover':
          defaults = {
            strokeColor: options.colors.red, //"#FF0000",
            strokeOpacity: 0.8,
            strokeWeight: 2,
          }
          break;
        case 'selected':
          defaults = {
            strokeColor: options.colors.red, //"#FF0000",
            strokeOpacity: 0.8,
            strokeWeight: 2,
            fillColor: options.colors.red, //"#FF0000",
            fillOpacity: 0.35
          }
          break;
      }
      style_options = $.extend(defaults, style_options);
      polygon.setOptions(style_options);
    }

    // -------------------------
    // Adds handlers to each vertex of a polygon so it can be edited
    // -------------------------
    function prepare_for_edit(polygon) {
      polygon.binder = new MVCArrayBinder(polygon, options.save_btn, options.reset_btn);

      // Add vertex handlers to the polygon
      polygon.getPath().forEach(function(latlng, index){
        var vertex = new VertexWidget(map, polygon, index);
        options.vertices.push(vertex);
        
        // Shift + click to delete this vertex
        google.maps.event.addDomListener(vertex.marker, 'click', function(event) {
          if(event.shiftKey) {
            delete_point(polygon, index);
          }
        });
      });
      set_polygon_style(polygon, 'selected', { is_selected: true });
      options.selected_polygon = polygon;
    }
    
    // -------------------------
    // Deletes all the vertices from the map
    // -------------------------
    function delete_vertices(){
      for (v in options.vertices) {
        if(options.mode == EDIT_MODE) {
          options.vertices[v].marker.setMap(null);
        } else if(options.mode == CREATE_MODE) {
          options.vertices[v].setMap(null);
        }
      }
      options.vertices = new Array();
    }
    
    // -------------------------
    // Returns a polygon to it's original coordinates
    // -------------------------
    function reset_polygon(polygon) {
      var coordinates = new Array();
      $.each(options.regions[polygon.region_index].points, function(){
        coordinates.push(new google.maps.LatLng(this[0], this[1]));
      });
      polygon.setPath(coordinates);
      delete_vertices();
      set_polygon_changed_status(polygon, false)
      set_polygon_style(polygon, 'mouseout', { is_selected: false });
    }

    // -------------------------
    // Saves the changes on the selected polygon
    // -------------------------
    function ajax_update(polygon) {
      new_points = new Array();
      polygon.getPath().forEach(function(point, index){
        new_points.push([point.lat(), point.lng()]);
      });
      
      $.post(
        options.update_url, 
        {
          authenticity_token: $('meta[name=csrf-token]').attr('content'),
          areas: [
            {
              id: polygon.region_id, 
              coordinates: new_points
            }
          ]
        },
        function(){
          // Update the regions array with the new saved coordinates
          options.regions[polygon.region_index].points = new_points;
          
          // Reset buttons state
          set_polygon_changed_status(polygon, false)
          
          // Notify the user
          obj.prepend($('<div class="flash_message notice">Saved!</div>'));
          setTimeout(function(){
            $('.flash_message.notice').fadeOut('slow', function(){$(this).remove()});
          }, 5000);
        },
        'json'
      );
    }
    
    // -------------------------
    // Creates a new polygon
    // -------------------------
    function ajax_create(region_name) {
      var polyline = options.tmp_poly;
      new_points = new Array();
      polyline.getPath().forEach(function(point, index){
        new_points.push([point.lat(), point.lng()]);
      });
      
      $.post(
        options.create_url, 
        {
          authenticity_token: $('meta[name=csrf-token]').attr('content'),
          area: {
            coordinates: new_points,
            name: region_name
          }
        },
        function(region_id){
          switch_to_mode(EDIT_MODE);
          // Update the regions array with the new saved coordinates
          var length = options.regions.push({
            id: region_id,
            name: region_name,
            points: new_points
          });
          options.selected_region_id = region_id;
          add_region(length-1, options.regions[length-1]);
          
          // Notify the user
          obj.prepend($('<div class="flash_message notice">Saved!</div>'));
          setTimeout(function(){
            $('.flash_message.notice').fadeOut('slow', function(){$(this).remove()});
          }, 5000);
        },
        'json'
      );
    }

    // -------------------------
    // Adds a new point to the selected polygon
    // -------------------------
    function add_new_point_to_polygon(latLng) {
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
      set_polygon_changed_status(polygon, true)
      delete_vertices();
      prepare_for_edit(polygon)
    }
    
    // -------------------------
    // Deletes a point from a polygon
    // -------------------------
    function delete_point(polygon, index) {
      if(polygon.getPath().getLength() == 3) {
        alert('Cannot delete this point. A region must have at least 3 points.');
      } else if(confirm('Delete this point?')) {
        polygon.getPath().removeAt(index);
        delete_vertices(polygon);
        prepare_for_edit(polygon);
        set_polygon_changed_status(polygon, true)
      }
    }
    
    // -------------------------
    // Sets the changed status of a polygon and the control buttons
    // -------------------------
    function set_polygon_changed_status(polygon, changed) {
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
    
    function add_point_to_new_region(latLng) {
      options.tmp_poly.getPath().push(latLng);
      // Add a new marker at the new plotted point on the polyline.
      var marker = new google.maps.Marker({
        position: latLng,
        map: map,
        animation: google.maps.Animation.DROP,
        clickable: (options.vertices.length == 0)
      });
      console.log('-' + options.vertices.length);
      
      options.vertices.push(marker);
      
      // Click to delete this vertex
      google.maps.event.addDomListener(marker, 'click', function(event) {
        if(options.tmp_poly.getPath().getLength() < 3) {
          alert('Please add at least 3 points to the region before closing it.');
        } else {
          var region_name = prompt('Enter the name of the new region.');
          if(region_name == null) {
            switch_to_mode(EDIT_MODE);
            prepare_for_edit(polygon);
          } else {
            ajax_create(region_name);
          }
          
        }
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
 * Ref: http://code.google.com/apis/maps/articles/mvcfun.html
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
  marker.bindTo('rightclick', this);

  // Bind the marker position property to the polygon binder
  marker.bindTo('position', polygon.binder, index.toString());
}
VertexWidget.prototype = new google.maps.MVCObject();



/* --------------------------------------------------------------
 * Use bindTo to allow dynamic drag of markers to refresh poly.
 * Ref: http://code.google.com/apis/maps/articles/mvcfun.html
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
