import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="map"
export default class extends Controller {
  static values = {
    accessToken: String,
    latitude: { type: String, default: "54.130740" },
    longitude: { type: String, default: "-3.238913" },
    zoom: { type: Number, default: 4 },
    marker: { type: Boolean, default: false },
    geocoder: { type: Boolean, default: false }
  }

  static targets = [ "map" ]

  connect() {
    mapboxgl.accessToken = this.accessTokenValue;
    const map = new mapboxgl.Map({
      container: this.mapTarget, // Container ID
      style: 'mapbox://styles/mapbox/satellite-v8', // Map style to use
      center: [this.longitudeValue, this.latitudeValue], // Starting position [lng, lat]
      zoom: this.zoomValue // Starting zoom level
    });

    if (this.markerValue === true) {
      const marker = new mapboxgl.Marker() // initialize a new marker
        .setLngLat([this.longitudeValue, this.latitudeValue]) // Marker [lng, lat] coordinates
        .addTo(map); // Add the marker to the map
    }

    if (this.geocoderValue === true) {

      const geocoder = new MapboxGeocoder({
        accessToken: this.accessTokenValue, // Set the access token
        placeholder: "eg: Dragon's Bay",
        bbox: [-7.57216793459, 49.959999905, 1.68153079591, 58.6350001085], // Boundary for UK
        mapboxgl: mapboxgl, // Set the mapbox-gl instance
        marker: false // Do not use the default marker style
      });
    
      // Add the geocoder to the map
      map.addControl(geocoder);

      map.on('load', () => {
        map.addSource('single-point', {
          type: 'geojson',
          data: {
            type: 'FeatureCollection',
            features: []
          }
        });
      
        map.addLayer({
          id: 'point',
          source: 'single-point',
          type: 'circle',
          paint: {
            'circle-radius': 10,
            'circle-color': '#448ee4'
          }
        });

        map.on('click', (event) => {
          updateLocation(event.lngLat.lng, event.lngLat.lat)
        });

        geocoder.on('result', (event) => {
          updateLocation(event.result.geometry.coordinates[0], event.result.geometry.coordinates[1])
        });

        function updateLocation(lon, lat) {
          //updates the form fields for lat and lon
          document.querySelector('#spot_longitude').value = lon;
          document.querySelector('#spot_latitude').value = lat;
          //updates the location of the point on the map
          map.getSource('single-point').setData({
            coordinates: [lon, lat],
            type: 'Point'
          });
        }
      })
    }
  }
}



// this.marker = new mapboxgl.Marker();
// this.map.on('click', this.add_marker.bind(this));

// add_marker: function (event) {
//   var coordinates = event.lngLat;
//   console.log('Lng:', coordinates.lng, 'Lat:', coordinates.lat);
//   this.marker.setLngLat(coordinates).addTo(this.map);
// }


