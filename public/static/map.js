$(function() {
  $(window).unload( function () { GUnload(); } );
  var melbourne = new google.maps.LatLng(-37.813611, 144.963056);
  var mapOptions = {
    zoom: 12,
    center: melbourne,
    mapTypeId: google.maps.MapTypeId.ROADMAP
  }

  var map = new google.maps.Map(document.getElementById("map_canvas"), mapOptions);

  $.getJSON('/static/places.json', function(places) {
    var currentPlace = null;

    $(places).each(function() {
      var place = this;
      var point = new google.maps.LatLng(place.location.lat, place.location.lng);
      var icons = {
        'Restaurant': "http://google-maps-icons.googlecode.com/files/restaurant.png",
        'Shopping':   "http://google-maps-icons.googlecode.com/files/supermarket.png",
        'Gift':       "http://google-maps-icons.googlecode.com/files/gifts.png",
        'Fast Food':  "http://google-maps-icons.googlecode.com/files/fastfood.png",
        'Clothing':   "http://google-maps-icons.googlecode.com/files/shoes.png",
        'Market':     "http://google-maps-icons.googlecode.com/files/market.png"
      }
      var marker = new google.maps.Marker({
        position: point,
        map:      map,
        title:    place.name,
        icon:     icons[place.type]
      });
      google.maps.event.addListener(marker, 'click', function() {
        var clickedPlace = place;
        var info = $('#placeDetails');

        if (currentPlace) {
          info.animate(
            {right: "-345px"}, 
            {complete: function() {
              if (clickedPlace == currentPlace) {
                currentPlace = null;
              } else {
                currentPlace = clickedPlace;
                if (currentPlace.url) {
                  $('h1', info).empty().html($("<a></a>").attr('href', clickedPlace.url).text(clickedPlace.name));
                } else {
                  $('h1', info).html(clickedPlace.name);
                }
                $('p',  info).html(clickedPlace.description);
                $('.address',  info).text(clickedPlace.address);
                $('.phone',  info).text(clickedPlace.phoneNumber);
                info.animate({right: "0"});
              }
            }}
          )
        } else {
          currentPlace = clickedPlace;
                if (currentPlace.url) {
                  $('h1', info).empty().html($("<a></a>").attr('href', clickedPlace.url).text(clickedPlace.name));
                } else {
                  $('h1', info).html(clickedPlace.name);
                }
          $('p',  info).text(clickedPlace.description);
          $('.address',  info).text(clickedPlace.address);
          $('.phone',  info).text(clickedPlace.phoneNumber);
          info.animate({right: "0"});
        }
      });
    });
  });
});
