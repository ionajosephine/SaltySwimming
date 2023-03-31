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
      });
    
      // Add the geocoder to the map
      map.addControl(geocoder);

      // Populate the lat/lon form inputs automatically from the result of the user's map search
      map.on('load', () => {
        geocoder.on('result', (event) => {
          document.querySelector('#spot_longitude').value = event.result.geometry.coordinates[0]
          document.querySelector('#spot_latitude').value = event.result.geometry.coordinates[1]
        });
      })
    }
  }
}


