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
  fullscreenIcon.style.paddingLeft = '29px';

  controlUI.appendChild(fullscreenIcon);

  // Setup the click event listeners: simply set the map to Chicago
  google.maps.event.addDomListener(controlUI, 'click', function() {
    $('#map').css({height: $(window).height(), width: $(document).width()});
    $('#map_canvas').toggleClass("fullscreen");
    google.maps.event.trigger(map, 'resize');
  });
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