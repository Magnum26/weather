$('document').ready ->
  `var skycons`

  error = (err) ->
    document.getElementById('loading').innerHTML = 'ERROR(' + err.code + '): ' + err.message
    return

  success = (pos) ->
    crd = pos.coords
    coordinates = crd.latitude + ',' + crd.longitude
    $.ajax(
      method: 'GET'
      url: 'https://maps.googleapis.com/maps/api/geocode/json'
      data:
        key: 'AIzaSyA1Bu8-7_MDfT9oncmZ1KCjoz_2xdrTMFA'
        latlng: coordinates).done (data) ->
      document.getElementById('currently-location').innerHTML = data.results['0'].address_components[3].short_name + ', ' + data.results['0'].address_components[5].short_name
      return
    # Make API call to darksky to get weather temp and  description
    $.ajax(
      method: 'GET'
      dataType: 'jsonp'
      url: "https://api.darksky.net/forecast/907160cda3c3fe28b8a7a2525b827ecc/" + coordinates + '?units=uk2'

      ).done (msg) ->
      skycons.add document.getElementById('currently-icon'), msg.currently.icon
      skycons.play()
      roundTemp = parseFloat(msg.currently.temperature).toFixed(0)
      document.getElementById('currently-summary').innerHTML = msg.currently.summary
      document.getElementById('minutely-summary').innerHTML = msg.minutely.summary
      document.getElementById('hourly-summary').innerHTML = msg.hourly.summary
      document.getElementById('daily-summary').innerHTML = msg.daily.summary
      document.getElementById('currently-temperature').innerHTML = roundTemp
      document.getElementById('currently-temperature').style.display = 'inline'
      document.getElementById('currently-temp-unit').style.display = 'inline'
      document.getElementById('currently-icon').style.display = 'inline'
      document.getElementById('currently-summary').style.display = 'block'
      document.getElementById('minutely-summary').style.display = 'inline'
      document.getElementById('hourly-summary').style.display = 'block'
      document.getElementById('daily-summary').style.display = 'block'
      document.getElementById('currently-location').style.display = 'block'
      document.getElementById('loading').style.display = 'none'

  # Set some global variables that are used throughout
  coordinates = undefined
  roundTemp = '0'
  skycons = new Skycons('color': 'black')
  # Check if geolocation is available in browser
  if 'geolocation' of navigator
    options =
      enableHighAccuracy: true
      timeout: 5000
      maximumAge: 0
    # Gets position from browser with multiple callbacks to handle errors
    navigator.geolocation.getCurrentPosition success, error, options
  else

    ### geolocation IS NOT available ###

    alert 'Sorry, your browser isn\'t providing a location.'
  return
