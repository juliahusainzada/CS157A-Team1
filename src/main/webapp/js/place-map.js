// Replace with your Mapbox public access token
mapboxgl.accessToken = "YOUR_MAPBOX_PUBLIC_TOKEN";

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
	
	// Find the address associated with the dropped pin
	const url = "https://api.mapbox.com/search/geocode/v6/reverse"
	    + "?longitude=" + longitude
	    + "&latitude=" + latitude
	    + "&access_token=" + mapboxgl.accessToken;
	
	fetch(url)
	    .then(response => {
	        if (!response.ok) {
	            throw new Error("Reverse geocoding failed");
	        }
	        return response.json();
	    })
	    .then(data => {
	        if (data.features && data.features.length > 0) {
	            const properties = data.features[0].properties;
	            const address =
	                properties.full_address ||
	                properties.name ||
	                "";

	            document.getElementById("address").value = address;
	            document.getElementById("selected-location").textContent =
	                "Selected location: " + address;
	        }
	    })
	    .catch(error => {
	        console.error("Reverse geocoding error:", error);
	    });
});

// Initialize Mapbox location search
const searchBox = new mapboxsearch.MapboxSearchBox();

// Use the same public token as the map
searchBox.accessToken = mapboxgl.accessToken;

// Search for addresses and points of interest
searchBox.options = {
    types: "poi,address",
    proximity: {
        lng: -121.8811,
        lat: 37.3352
    }
};

// Add search box to our form
document.getElementById("location-search-container")
    .appendChild(searchBox);

// When a user selects a location
searchBox.addEventListener("retrieve", function(event) {

    const feature = event.detail.features[0];

    if (!feature) {
        return;
    }

    const coordinates = feature.geometry.coordinates;

    const longitude = coordinates[0];
    const latitude = coordinates[1];

    // Move map to selected location
    map.flyTo({
        center: [longitude, latitude],
        zoom: 17
    });

    // Remove previous marker
    if (marker !== null) {
        marker.remove();
    }

    // Add marker at selected location
    marker = new mapboxgl.Marker({
        color: "#D9C48A"
    })
        .setLngLat([longitude, latitude])
        .addTo(map);

    // Populate hidden coordinate fields
    document.getElementById("latitude").value =
        latitude.toFixed(8);

    document.getElementById("longitude").value =
        longitude.toFixed(8);

    // Populate the address field
    const properties = feature.properties || {};

    const address =
        properties.full_address ||
        properties.place_formatted ||
        properties.name ||
        "";

    document.getElementById("address").value = address;

    // Populate spot name if empty
    const nameInput = document.getElementById("name");

    if (!nameInput.value.trim()) {
        nameInput.value = properties.name || "";
    }

    // Display selected location
    document.getElementById("selected-location").textContent =
        "Selected location: " + address;

    console.log("Selected place:", feature);
});
