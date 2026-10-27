// Replace with your Mapbox public access token
mapboxgl.accessToken = "<ADD YOUR TOKEN HERE>";

// SJSU coordinates
const sjsuCoordinates = [-121.8811, 37.3352];

// Initialize map
const map = new mapboxgl.Map({
    container: "map",
    style: "mapbox://styles/mapbox/streets-v12",
    center: sjsuCoordinates,
    zoom: 15
});

// Add zoom controls
map.addControl(new mapboxgl.NavigationControl());

// Store the currently selected marker
let marker = null;

// When the user clicks the map
map.on("click", function(event) {

    const longitude = event.lngLat.lng;
    const latitude = event.lngLat.lat;

    // Remove previous marker
    if (marker !== null) {
        marker.remove();
    }

    // Add new marker
    marker = new mapboxgl.Marker({
        color: "#D9C48A"
    })
        .setLngLat([longitude, latitude])
        .addTo(map);

    // Update hidden form inputs
    document.getElementById("latitude").value =
        latitude.toFixed(8);

    document.getElementById("longitude").value =
        longitude.toFixed(8);

    // Display selected coordinates
    document.getElementById("selected-location").textContent =
        "Selected location: " +
        latitude.toFixed(6) + ", " +
        longitude.toFixed(6);

    console.log("Latitude:", latitude);
    console.log("Longitude:", longitude);
});