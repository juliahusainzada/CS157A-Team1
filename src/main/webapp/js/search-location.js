(function () {
  // Find the search form, location fields, and feedback elements.
  const form = document.getElementById("spot-search");
  const input = document.getElementById("search-location");
  const latitude = document.getElementById("search-latitude");
  const longitude = document.getElementById("search-longitude");
  const status = document.getElementById("location-status");
  const button = form.querySelector(".btn-search");

  // Use SJSU when the location field is empty.
  const defaultLocation = {
    latitude: 37.3352,
    longitude: -121.8811,
  };

  // Track the current lookup and allow submission after it succeeds.
  let pending = null;
  let readyToSubmit = false;

  // Check that both coordinates are present and within valid ranges.
  function validCoordinates(latitudeValue, longitudeValue) {
    if (latitudeValue === null || longitudeValue === null) {
      return false;
    }

    if (latitudeValue === "" || longitudeValue === "") {
      return false;
    }

    const numericLatitude = Number(latitudeValue);
    const numericLongitude = Number(longitudeValue);

    if (
      !Number.isFinite(numericLatitude) ||
      !Number.isFinite(numericLongitude)
    ) {
      return false;
    }

    if (numericLatitude < -90 || numericLatitude > 90) {
      return false;
    }

    if (numericLongitude < -180 || numericLongitude > 180) {
      return false;
    }

    return true;
  }

  // Populate the hidden coordinate fields submitted with the form.
  function setCoordinates(latitudeValue, longitudeValue) {
    latitude.value = latitudeValue;
    longitude.value = longitudeValue;
  }

  // Display location lookup feedback below the search field.
  function showStatus(message, error) {
    status.textContent = message;
    status.classList.toggle("location-error", error === true);
  }

  // Restore coordinates from the search URL after the page reloads.
  // The backend must still validate them before using them in a query.
  const parameters = new URLSearchParams(window.location.search);
  const savedLatitude = parameters.get("latitude");
  const savedLongitude = parameters.get("longitude");
  const savedLocation = input.value.trim();

  if (savedLocation !== "" && validCoordinates(savedLatitude, savedLongitude)) {
    setCoordinates(savedLatitude, savedLongitude);
    showStatus("Selected location: " + input.value);
  } else if (savedLocation === "") {
    setCoordinates(defaultLocation.latitude, defaultLocation.longitude);
    showStatus("No location selected. Using SJSU as the search center.");
  }

  // Clear the old coordinates when the user edits the location.
  input.addEventListener("input", function () {
    if (pending !== null) {
      pending.abort();
    }

    setCoordinates("", "");
    showStatus("");
  });

  // Resolve the entered city or ZIP before submitting the search form.
  form.addEventListener("submit", function (event) {
    // Allow the second submission after coordinates have been resolved.
    if (readyToSubmit) {
      return;
    }

    event.preventDefault();

    // Avoid starting another lookup while one is already running.
    if (pending !== null) {
      return;
    }

    const query = input.value.trim();

    if (query === "") {
      setCoordinates(defaultLocation.latitude, defaultLocation.longitude);
      readyToSubmit = true;
      form.requestSubmit();
      return;
    }

    // Mapbox accepts at most 256 characters and 20 words, without semicolons.
    const wordCount = query.split(/\s+/).length;

    if (query.includes(";") || query.length > 256 || wordCount > 20) {
      showStatus(
        "Enter a city or ZIP using at most 20 words, without semicolons.",
        true,
      );
      input.focus();
      return;
    }

    const token = "YOUR_MAPBOX_PUBLIC_TOKEN"; //Replace with your Mapbox public access token

    if (!token) {
      showStatus(
        "Location lookup is unavailable. Please try again later, or clear the location to use SJSU.",
        true,
      );
      return;
    }

    // Cancel the request if it takes longer than ten seconds.
    const controller = new AbortController();
    pending = controller;

    const timeout = setTimeout(function () {
      controller.abort();
    }, 10000);

    button.disabled = true;
    button.textContent = "Searching…";
    showStatus("Looking up your location…");

    // Restore the form after either success or failure.
    function finishLookup() {
      clearTimeout(timeout);
      pending = null;
      button.disabled = false;
      button.textContent = "Search";

      if (readyToSubmit) {
        form.requestSubmit();
      }
    }

    function handleLookupError(error) {
      // Keep feedback relevant to the location still in the input.
      if (input.value.trim() === query) {
        if (error.name === "AbortError") {
          showStatus("Location lookup timed out. Please try again.", true);
        } else {
          showStatus(
            "Could not look up that location. Check your connection and try again.",
            true,
          );
        }
      }
    }

    try {
      // Search near SJSU, while allowing locations outside that area.
      const url = new URL("https://api.mapbox.com/search/geocode/v6/forward");

      url.search = new URLSearchParams({
        q: query,
        access_token: token,
        autocomplete: "false",
        types: "place,postcode,locality,neighborhood,address",
        proximity: "-121.8811,37.3352",
        limit: "1",
      });

      fetch(url, {
        signal: controller.signal,
      })
        .then(function (response) {
          if (!response.ok) {
            throw new Error("Location lookup failed.");
          }

          return response.json();
        })
        .then(function (data) {
          if (!data.features || !data.features[0]) {
            showStatus(
              "No location found. Try a city with its state, or a ZIP code.",
              true,
            );
            return;
          }

          const feature = data.features[0];
          let coordinates;

          if (feature.geometry) {
            coordinates = feature.geometry.coordinates;
          }

          if (
            !coordinates ||
            !validCoordinates(coordinates[1], coordinates[0])
          ) {
            throw new Error("Invalid location coordinates.");
          }

          // Ignore results if the user changed the location during the lookup.
          if (controller.signal.aborted || input.value.trim() !== query) {
            return;
          }

          // Mapbox returns longitude first, followed by latitude.
          setCoordinates(coordinates[1], coordinates[0]);

          if (feature.properties && feature.properties.full_address) {
            input.value = feature.properties.full_address;
          } else {
            input.value = query;
          }

          showStatus("Selected location: " + input.value);
          readyToSubmit = true;
        })
        .catch(handleLookupError)
        .then(finishLookup);
    } catch (error) {
      handleLookupError(error);
      finishLookup();
    }
  });
})();
