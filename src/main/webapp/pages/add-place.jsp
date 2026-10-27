<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Add a Spot</title>
    <link rel="stylesheet"
          href="${pageContext.request.contextPath}/css/style.css">
</head>

<body>

    <header>
        <h1>
            <span class="logo-script">Study</span>
            <span class="logo-serif">Spotter</span>
        </h1>

        <nav>
            <a href="${pageContext.request.contextPath}/">
                Home
            </a>
        </nav>
    </header>

    <main class="add-spot-section">

        <h2>Add a New Study Spot</h2>

        <p>
            Know a great place to study?
            Share it with the StudySpotter community!
        </p>

        <form class="add-spot-form"
              action="${pageContext.request.contextPath}/add-place"
              method="POST">

            <!-- Location Search -->
            <label for="location-search">Search for a Location</label>

            <input
                type="text"
                id="location-search"
                placeholder="Search for a cafe, library, or address"
                autocomplete="off">

            <p>Can't find your location? You'll be able to drop a pin on the map.</p>

            <!-- Map placeholder -->
            <div class="map-placeholder">
                Interactive map coming soon!
            </div>

            <!-- Spot Name -->
            <label for="name">Spot Name</label>

            <input
                type="text"
                id="name"
                name="name"
                placeholder="e.g. MLK Library - 4th Floor"
                maxlength="255"
                required>

            <!-- Category -->
            <label for="category">Category</label>

            <select id="category" name="category" required>
                <option value="">Select a category</option>
                <option value="Cafe">Cafe</option>
                <option value="Library">Library</option>
                <option value="Park">Park</option>
                <option value="Classroom">Classroom</option>
            </select>

            <!-- Address -->
            <label for="address">Address</label>

            <input
                type="text"
                id="address"
                name="address"
                placeholder="Select a location or enter an address"
                maxlength="255"
                required>

            <!-- Coordinates: populated by map later -->
            <input type="hidden" id="latitude" name="latitude">
            <input type="hidden" id="longitude" name="longitude">

            <!-- Amenities -->
            <fieldset class="amenities-fieldset">

                <legend>Amenities</legend>

                <p>Select all that apply:</p>

                <label>
                    <input type="checkbox" name="amenities" value="1">
                    Free Wi-Fi
                </label>

                <label>
                    <input type="checkbox" name="amenities" value="2">
                    Power Outlets
                </label>

                <label>
                    <input type="checkbox" name="amenities" value="3">
                    Quiet Zone
                </label>

                <label>
                    <input type="checkbox" name="amenities" value="4">
                    Outdoor Seating
                </label>

                <label>
                    <input type="checkbox" name="amenities" value="5">
                    Study Tables
                </label>

                <label>
                    <input type="checkbox" name="amenities" value="6">
                    Coffee
                </label>

                <label>
                    <input type="checkbox" name="amenities" value="7">
                    Tea
                </label>

                <label>
                    <input type="checkbox" name="amenities" value="8">
                    Printing
                </label>

                <label>
                    <input type="checkbox" name="amenities" value="9">
                    Whiteboards
                </label>

                <label>
                    <input type="checkbox" name="amenities" value="10">
                    Natural Lighting
                </label>

            </fieldset>

            <button type="submit" class="btn-add-spot" disabled>
                Submit Spot
            </button>

            <p>Submission will be enabled after we connect the map and backend.</p>

        </form>

    </main>

</body>
</html>