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
      map_style: 'width:100%;height:500px', 
      colors : {
        red: '#aa4643',
        blue: '#4572a7'
      }
    };
    
    var options = $.extend(defaults, options);
    var map = initialize_google_map();
    $.each(options.regions, add_region); // Add all the regions to the map
    if(options.selected_polygon == null) {
      switch_to_mode(CREATE_MODE);
      alert("Click on the map to add points to the region. When you're done close the region by clicking on the first marker")
    }
    
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
      options.map_options.center = new google.maps.LatLng(options.center.lat, options.center.lng);
      
      
      // Creating the map
      var map = new google.maps.Map(map_container.get(0), options.map_options);
      render_controls(map);

      // Adjusting the zoom level if bounds were provided
      if (options.bounds != null) {
        map.fitBounds(new google.maps.LatLngBounds(
          new google.maps.LatLng(options.bounds[0][0], options.bounds[0][1]),
          new google.maps.LatLng(options.bounds[1][0], options.bounds[1][1])
        ));
      }
      
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
            if(options.selected_polygon == null) {
              document.location = options.create_url;
            } else {
              switch_to_mode(EDIT_MODE);
              prepare_for_edit(options.selected_polygon);
            }
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
      google.maps.event.addListener(polygon, 'mouseover', function(event) {
        if(!polygon.is_selected && options.mode == EDIT_MODE) {
          set_polygon_style(polygon, 'mouseover');
        }
        $('.region_details').html(options.regions[polygon.region_index].name);
      });

      // mouseout event
      google.maps.event.addListener(polygon, 'mouseout', function() {
        if(!polygon.is_selected && options.mode == EDIT_MODE) {
          set_polygon_style(polygon, 'mouseout');
        }
        if(options.selected_polygon != null){
          $('.region_details').html(options.regions[options.selected_polygon.region_index].name)
        }
        
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
      // Add vertex handlers to the polygon
      polygon.getPath().forEach(function(latlng, index){
        var vertex = new BorderHandler(map, polygon, index, options);
        options.vertices.push(vertex);
        
        // Shift + click to delete this vertex
        google.maps.event.addDomListener(vertex.marker, 'click', function(event) {
          if(event.shiftKey) {
            delete_point(polygon, index);
          // [TODO] Finish region snap
          // } else {
          //   if(vertex.circle == null) {
          //     vertex.create_circle();
          //   } else {
          //     vertex.delete_circle();
          //   }
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
      if(polygon == null){
        return;
      }
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
        }
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
          document.location = options.create_url+'/'+region_id+'/edit_borders';
        },
        'json'
      );
    }


    
    // -------------------------
    // Adds a new point to the selected polygon
    // -------------------------
    function add_new_point_to_polygon(latLng) {
      var polygon = options.selected_polygon;
      var path = polygon.getPath();
      var distance = {value: 10000, points: null};
      var point_indexes = null;
      var poly = null;
      var flightPlanCoordinates = [
        path.getAt(0),
        path.getAt(1)
      ];

      // Collect the distances between the new point and every polygon vertex
      path.forEach(function(poly_latLng, index){
        points = [index, index + 1];
        if(index + 1 >= path.getLength()) {
          points = [index, 0];
        }
        p1 = path.getAt(points[0]);
        p2 = path.getAt(points[1]);
        d = dotLineLength(latLng.lat(), latLng.lng(), p1.lat(), p1.lng(), p2.lat(), p2.lng(), true);
        if(d < distance.value) {
          distance = {value: d, points: points};
        }
      });
      
      var coordinates = new Array();
      var added_new_coordinate = false;
      path.forEach(function(poly_latLng, index){
        coordinates.push(poly_latLng);

        points = [index, index + 1];
        if(index + 1 >= path.getLength()) {
          points = [index, 0];
        }
  
        if(!added_new_coordinate && (points[0] == distance.points[0] && points[1] == distance.points[1])) {
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
function BorderHandler(map, polygon, index, options) {
  var me = this;
  this.map = map;
  this.circle = null;
  this.set('map', map);
  this.set('position', polygon.getPath().getAt(index));
  this.set('marker', new google.maps.Marker({draggable: true,  title: 'index: '+index}));
  this.marker.bindTo('map', this);
  this.marker.bindTo('position', this)

  google.maps.event.addListener(this.marker, 'drag', function() {
    if(polygon.has_changed == false) {
      polygon.has_changed = true;
      options.save_btn.removeClass('disabled');
      options.reset_btn.removeClass('disabled');
    }
    // update the polygon vertex
    polygon.getPath().setAt(index, this.get('position'));
    
    // Update the center of the circle
    if(me.circle != null) {
      me.circle.set('center', this.get('position'))
    }
  });
}

BorderHandler.prototype = new google.maps.MVCObject();

BorderHandler.prototype.create_circle = function(){
  if(this.circle == null) {
    this.circle = new RadiusWidget();
    this.circle.bindTo('map', this);
    this.circle.bindTo('center', this, 'position');
    this.bindTo('distance', this.circle);
    this.bindTo('bounds', this.circle);
  }
}

BorderHandler.prototype.delete_circle = function(){
  if(this.circle != null) {
    this.circle.unbind('map');
    this.circle.circle.setMap(null);
    this.circle.sizer.setMap(null);
    this.circle = null;
  };
}


/* --------------------------------------------------------------
 * A radius widget that adds a circle to a map and centers on a marker.
 --------------------------------------------------------------*/
function RadiusWidget() {
  this.circle = new google.maps.Circle({
    strokeWeight: 2
  });
  this.set('distance', 1);
  this.bindTo('bounds', this.circle);
  this.circle.bindTo('center', this);
  this.circle.bindTo('map', this);
  this.circle.bindTo('radius', this);
  this.addSizer_();
}
RadiusWidget.prototype = new google.maps.MVCObject();

// Update the radius when the distance has changed.
RadiusWidget.prototype.distance_changed = function() {
  this.set('radius', this.get('distance') * 1000);
};

RadiusWidget.prototype.addSizer_ = function() {
  var me = this;
  this.sizer = new google.maps.Marker({
    draggable: true,
    title: 'Drag me!'
  });

  this.sizer.bindTo('map', this);
  this.sizer.bindTo('position', this, 'sizer_position');

  google.maps.event.addListener(this.sizer, 'drag', function() {
    var pos = me.get('sizer_position');
    var center = me.get('center');
    var distance = google.maps.geometry.spherical.computeDistanceBetween(center, pos) / 1000
    me.set('distance', distance);
  });
};

RadiusWidget.prototype.center_changed = function() {
  var bounds = this.get('bounds');

  // Bounds might not always be set so check that it exists first.
  if (bounds) {
    var lng = bounds.getNorthEast().lng();

    // Put the sizer at center, right on the circle.
    var position = new google.maps.LatLng(this.get('center').lat(), lng);
    this.set('sizer_position', position);
  }
};

dotLineLength = function(x, y, x0, y0, x1, y1, o){
  function lineLength(x, y, x0, y0){
    return Math.sqrt((x -= x0) * x + (y -= y0) * y);
  }
  if(o && !(o = function(x, y, x0, y0, x1, y1){
    if(!(x1 - x0)) return {x: x0, y: y};
    else if(!(y1 - y0)) return {x: x, y: y0};
    var left, tg = -1 / ((y1 - y0) / (x1 - x0));
    return {x: left = (x1 * (x * tg - y + y0) + x0 * (x * - tg + y - y1)) / (tg * (x1 - x0) + y0 - y1), y: tg * left - tg * x + y};
  }(x, y, x0, y0, x1, y1), o.x >= Math.min(x0, x1) && o.x <= Math.max(x0, x1) && o.y >= Math.min(y0, y1) && o.y <= Math.max(y0, y1))){
    var l1 = lineLength(x, y, x0, y0), l2 = lineLength(x, y, x1, y1);
    return l1 > l2 ? l2 : l1;
  }
  else {
    var a = y0 - y1, b = x1 - x0, c = x0 * y1 - y0 * x1;
    return Math.abs(a * x + b * y + c) / Math.sqrt(a * a + b * b);
  }
};
