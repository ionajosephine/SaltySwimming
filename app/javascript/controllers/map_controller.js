import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="map"
export default class extends Controller {
  static values = {
    accessToken: String,
    latitude: Number,
    longitude: Number
  }

  static targets = [ "map" ]

  connect() {
    mapboxgl.accessToken = this.accessTokenValue;
    const map = new mapboxgl.Map({
      container: this.mapTarget, // Container ID
      style: 'mapbox://styles/mapbox/satellite-v8', // Map style to use
      center: [this.longitudeValue, this.latitudeValue], // Starting position [lng, lat]
      zoom: 12, // Starting zoom level
    });

    const marker = new mapboxgl.Marker() // initialize a new marker
      .setLngLat([this.longitudeValue, this.latitudeValue]) // Marker [lng, lat] coordinates
      .addTo(map); // Add the marker to the map
  }
}


