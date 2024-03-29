if (!google.maps.Polygon.prototype.getBounds) {

  google.maps.Polygon.prototype.getBounds = function(latLng) {

    var bounds = new google.maps.LatLngBounds();
    var paths = this.getPaths();
    var path;

    for (var p = 0; p < paths.getLength(); p++) {
      path = paths.getAt(p);
      for (var i = 0; i < path.getLength(); i++) {
        bounds.extend(path.getAt(i));
      }
    }
    return bounds;
  }
}


function detectBrowser() {
  var useragent = navigator.userAgent;
  var mapdiv = document.getElementById("map_canvas");

  if (useragent.indexOf('iPhone') != -1 || useragent.indexOf('Android') != -1 ) {
    mapdiv.style.width = '100%';
    mapdiv.style.height = '100%';
  } else {
    mapdiv.style.width = '600px';
    mapdiv.style.height = '600px';
  }
}

function ResetControl(controlDiv, map, center) {
 
  // Set CSS styles for the DIV containing the control
  // Setting padding to 5 px will offset the control
  // from the edge of the map
  controlDiv.style.padding = '5px';
 
  // Set CSS for the control border
  var controlUI = document.createElement('DIV');
  controlUI.style.backgroundColor = 'white';
  controlUI.style.borderStyle = 'solid';
  controlUI.style.borderWidth = '2px';
  controlUI.style.cursor = 'pointer';
  controlUI.style.textAlign = 'center';
  controlUI.title = 'Click to reset the map';
  controlDiv.appendChild(controlUI);
 
  // Set CSS for the control interior
  var controlText = document.createElement('DIV');
  controlText.style.fontFamily = 'Arial,sans-serif';
  controlText.style.fontSize = '12px';
  controlText.style.paddingLeft = '4px';
  controlText.style.paddingRight = '4px';
  controlText.innerHTML = '<b>Reset</b>';
  controlUI.appendChild(controlText);
 
  // Setup the click event listeners: simply set the map to the center
  google.maps.event.addDomListener(controlUI, 'click', function() {
    map.setCenter(center);
    map.setZoom(6);
  });
}

function ToggleFullScreen(controlDiv, map) {
  // Set CSS styles for the DIV containing the control
  // Setting padding to 5 px will offset the control
  // from the edge of the map
  controlDiv.style.padding = '5px';

  // Set CSS for the control border
  var controlUI = document.createElement('DIV');
  controlUI.style.cursor = 'pointer';
  controlUI.style.textAlign = 'center';
  controlUI.title = 'Toggle fullscreen.';
  controlDiv.appendChild(controlUI);

  var fullscreenIcon = document.createElement('IMG');
  fullscreenIcon.src = '/images/icons/fullscreen.png';
  fullscreenIcon.style.paddingLeft = '0px';

  controlUI.appendChild(fullscreenIcon);

  // Setup the click event listeners
  google.maps.event.addDomListener(controlUI, 'click', function() {
    var div = $('#map').parent()[0];
    // if the class is empty (not fullscreen) 
    // store the #map div's parent's
    if (!$('#map_canvas').prop("class").match(/fullscreen/) ) { // toggle fullscreen on
      jQuery.data(div, 'map_parent_height', $('#map').parent().height() );
      jQuery.data(div, 'map_parent_width', $('#map').parent().width() );
      $('#map').css({height: $(window).height(), width: $(document).width()});
    }
    else { // toggle fullscreen off
      // set the map and its parent's width and height from stored data
      var h = jQuery.data(div, 'map_parent_height');
      var w = jQuery.data(div, 'map_parent_width');
      $('#map').parent().height(h);
      $('#map').parent().width(w);
      $('#map').height(h);
      $('#map').width(w);
    }
    $('#map_canvas').toggleClass("fullscreen");
    google.maps.event.trigger(map, 'resize'); // refreshes the map
  });
}

function renderJSONEvent(obj){
  // console.log(obj);
  title = obj["title"];
  description = obj["description"];
  distributions = ''
  address = obj["address"];
  updated_at = obj["updated_at"];

  for (var i=0; i < obj['distributions'].length; i++) {
    distributions += '<li>' + obj['distributions'][i] + '</li>';
  }

  if (distributions != '') {
    distributions = '<ul>'+distributions+'</ul>';
  }

  var useragent = navigator.userAgent;
  html = "";
  if (useragent.indexOf('iPhone') != -1 || useragent.indexOf('Android') != -1 ) 
  {
     //do not add enlarge view
  }
  else
  {
    href='/projects/'+obj["project_id"]+'/events/'+obj["id"]+'?zoombox=true'
    html= "<a class='zoombox' href='" + href + "' >Enlarge View</a>";
  }

   html = html +  "<h3>"+title+"</h3>"+
    "<strong class='label'>Address:</strong> " + address +
    "<p>"
    if (distributions != '') {
      html += "<strong class='label'>Distributions:</strong>" + distributions + "</br>" 
    }
    html += "<strong class='label'>Description:</strong>" + description + "</br>"
    html += "  <span class='infowindow_updated_at'><strong class='label'>Updated at:</strong> <span id='datetime'>" + updated_at + "</span></span>"
    html += "</p>";
  return(html);

}

function renderJSON(obj) {
  var keys = []
  var retValue = ""

  for (var key in obj) {
    if (typeof obj[key] == 'object') {
      retValue += "<div class='tree'>" + key
      retValue += renderJSON(obj[key])
      retValue += "</div>"
    }
    else {
      retValue += "<div class='tree'>" + key + ": " + obj[key] + "</div>"
    }
    keys.push(key)
  }

  return retValue
}

function getElevationForLatLon(lat, lon) {
  var elevator = new google.maps.ElevationService();
  var positionalRequest = {
      'locations': [new google.maps.LatLng(lat, lon)]
  }

  elevator.getElevationForLocations(positionalRequest,
  function(results, status) {
    if (status == google.maps.ElevationStatus.OK) {
      // Retrieve the first result
      if (results[0]) {
        return results[0].elevation;
      } else {
        return null;
      }
    } else {
      return null;
    }
  });
}
