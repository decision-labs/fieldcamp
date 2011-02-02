function renderJSON(obj) {
  var keys = []
  var retValue = ""
  for (var key in obj) {
          if(typeof obj[key] == 'object') {
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
