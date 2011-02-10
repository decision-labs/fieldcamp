// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults

// TODO: move to  maps.js

$(document).ready(function() {
  // body...
})

function getElevationForLatLon(lat,lon) {
  var elevator = new google.maps.ElevationService();
  var positionalRequest = {
    'locations': new google.maps.LatLng(lat,lon)
  }
  elevator.getElevationForLocations(positionalRequest, function(results, status) {
    if (status == google.maps.ElevationStatus.OK) {
      // Retrieve the first result
      if (results[0]) {
        return results[0].elevation;
      }else{
        return null;
      }
    }else{
      return null;
    }
  }) // elevator callback ends
}
