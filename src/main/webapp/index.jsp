<%@ page import="java.util.List" %>
<%@ page import="studyspotter.places.Place" %> 
<%@ page import="studyspotter.places.PlaceDAO" %>
<%!
    private String escapeHtml(String value) {
        if (value == null) return "";
        return value.replace("&", "&amp;")
                    .replace("<", "&lt;")
                    .replace(">", "&gt;")
                    .replace("\"", "&quot;")
                    .replace("'", "&#39;");
    }

    private String filterChoice(String value, String... allowed) {
        if (value == null) value = "";
        for (String choice : allowed) {
            if (choice.equals(value)) return value;
        }
        throw new IllegalArgumentException("Invalid filter selection. Please choose one of the listed options.");
    }

%>

<html>
<head>
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>StudySpotter</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>

<body>
    <header>
        <h1>
            <span class="logo-script">Study</span>
            <span class="logo-serif">Spotter</span>
        </h1>
        <nav>
            <%
                String loggedInEmail =
                        (String) session.getAttribute("email");

                String role =
                        (String) session.getAttribute("role");
            %>

            

            <% if ("OWNER".equals(role)) { %>
                <a href="${pageContext.request.contextPath}/pages/auth/owner-dashboard.jsp">
                    Owner Dashboard
                </a>
            <% } %>

            <% if ("ADMIN".equals(role)) { %>
                <a href="${pageContext.request.contextPath}/pages/auth/admin-dashboard.jsp">
                    Admin Dashboard
                </a>
            <% } %>
            <% if (loggedInEmail == null) { %>

                <a href="${pageContext.request.contextPath}/pages/login.jsp">
                    Log In
                </a>

                <a href="${pageContext.request.contextPath}/pages/register.jsp">
                    Sign Up
                </a>

            <% } else { %>
	            <a href="${pageContext.request.contextPath}/pages/places/add-place.jsp">
	                Add a Spot
	            </a>

                <span>Welcome, <%= loggedInEmail %></span>

                <a href="${pageContext.request.contextPath}/logout">
                    Log Out
                </a>

            <% } %>
        </nav>
    </header>

    <!-- Display confirmation after successfully adding a study spot -->
    <% if ("1".equals(request.getParameter("added"))) { %>
        <div class="success-message">
            Study spot added successfully!
        </div>
    <% } %>

    <!-- Confirmation after submitting a report -->

    <% if ("1".equals(request.getParameter("reported"))) { %>
        <div class="success-message">
            Your feedback has been shared.
        </div>
    <% } %>

    <%
        String noise = request.getParameter("noise");
        String outlets = request.getParameter("outlets");
        String wifi = request.getParameter("wifi");
        String location = request.getParameter("location");
        String radius = request.getParameter("radius");
        String dietary = request.getParameter("dietary");
        String vibe = request.getParameter("vibe");
        String minimumSeating = request.getParameter("minimumSeating");
        String sort = request.getParameter("sort");
        double searchLatitude = 37.3352;
        double searchLongitude = -121.8811;
        String searchError = null;
        List<Place> places = java.util.Collections.emptyList();

        try {
            noise = filterChoice(noise, "", "Quiet", "Moderate", "Loud");
            outlets = filterChoice(outlets, "", "Some", "Plenty");
            wifi = filterChoice(wifi, "", "Basic", "Strong");
            dietary = filterChoice(dietary, "", "Vegan", "Vegetarian", "Gluten-Free");
            vibe = filterChoice(vibe, "", "Outdoor Seating", "Natural Lighting", "Quiet Zone");
            minimumSeating = filterChoice(minimumSeating, "", "3", "4");
            radius = filterChoice(radius == null ? "5" : radius, "5", "10", "15");
            sort = filterChoice(sort == null ? "rating" : sort, "rating", "distance");

            // Blank searches use SJSU. Named locations require resolved coordinates.
            if (location != null && !location.isBlank()) {
                try {
                    searchLatitude = Double.parseDouble(request.getParameter("latitude"));
                    searchLongitude = Double.parseDouble(request.getParameter("longitude"));
                } catch (NumberFormatException | NullPointerException e) {
                    throw new IllegalArgumentException("Please search again to resolve your city or ZIP.");
                }

                if (!Double.isFinite(searchLatitude) || !Double.isFinite(searchLongitude)
                        || searchLatitude < -90 || searchLatitude > 90
                        || searchLongitude < -180 || searchLongitude > 180) {
                    throw new IllegalArgumentException("Invalid location coordinates. Please search again.");
                }
            }

            PlaceDAO placeDAO = new PlaceDAO();
            places = placeDAO.getFilteredPlaces(
                searchLatitude, searchLongitude, Integer.parseInt(radius),
                noise, outlets, wifi,
                minimumSeating.isEmpty() ? null : Integer.valueOf(minimumSeating),
                dietary, vibe, sort
            );
        } catch (IllegalArgumentException e) {
            response.setStatus(400);
            searchError = e.getMessage();
        } catch (java.sql.SQLException e) {
            application.log("Unable to search study spots.", e);
            response.setStatus(500);
            searchError = "Unable to load spots right now. Please try again.";
        }
    %>

    <section class="search-section">
        <h2>Find a Study Spot</h2>
        <form id="spot-search" method="GET" action="${pageContext.request.contextPath}/index.jsp">
            <div class="search-form">
                <label for="search-location">Location</label>
                <input id="search-location" type="text" name="location" value="<%= escapeHtml(location) %>" placeholder="City or ZIP" autocomplete="address-level2" maxlength="256">
                <button type="submit" class="btn-search">Search</button>
            </div>

            <input type="hidden" name="latitude" id="search-latitude" value="<%= searchLatitude %>">
            <input type="hidden" name="longitude" id="search-longitude" value="<%= searchLongitude %>">
            <p id="location-status" class="location-status" role="status"></p>
            <noscript><p>Enable JavaScript to look up a city or ZIP. Blank locations search around SJSU.</p></noscript>

            <div class="search-filters">
                <select name="radius">
                    <option value="5" <%= "5".equals(radius) ? "selected" : "" %>>Radius: 5 miles</option>
                    <option value="10" <%= "10".equals(radius) ? "selected" : "" %>>Radius: 10 miles</option>
                    <option value="15" <%= "15".equals(radius) ? "selected" : "" %>>Radius: 15 miles</option>
                </select>

                <select name="dietary">
                    <option value="" <%= "".equals(dietary) ? "selected" : "" %>>Dietary: Any</option>
                    <option value="Vegan" <%= "Vegan".equals(dietary) ? "selected" : "" %>>Dietary: Vegan</option>
                    <option value="Vegetarian" <%= "Vegetarian".equals(dietary) ? "selected" : "" %>>Dietary: Vegetarian</option>
                    <option value="Gluten-Free" <%= "Gluten-Free".equals(dietary) ? "selected" : "" %>>Dietary: Gluten-Free</option>
                </select>
                <select name="vibe">
                    <option value="" <%= "".equals(vibe) ? "selected" : "" %>>Vibe: Any</option>
                    <option value="Outdoor Seating" <%= "Outdoor Seating".equals(vibe) ? "selected" : "" %>>Vibe: Outdoor Seating</option>
                    <option value="Natural Lighting" <%= "Natural Lighting".equals(vibe) ? "selected" : "" %>>Vibe: Natural Lighting</option>
                    <option value="Quiet Zone" <%= "Quiet Zone".equals(vibe) ? "selected" : "" %>>Vibe: Quiet Zone</option>
                </select>
            </div>
            <fieldset class="workability-filters">
                <legend>Workability</legend>
                <div class="workability-row">
                    <select id="filter-noise" name="noise">
                        <option value="">Noise: Any</option>
                        <option value="Quiet" <%= "Quiet".equals(noise) ? "selected" : "" %>>Noise: Quiet</option>
                        <option value="Moderate" <%= "Moderate".equals(noise) ? "selected" : "" %>>Noise: Moderate</option>
                        <option value="Loud" <%= "Loud".equals(noise) ? "selected" : "" %>>Noise: Loud</option>
                    </select>
                    <select id="filter-outlets" name="outlets">
                        <option value="">Outlets: Any</option>
                        <option value="Some" <%= "Some".equals(outlets) ? "selected" : "" %>>Outlets: Few</option>
                        <option value="Plenty" <%= "Plenty".equals(outlets) ? "selected" : "" %>>Outlets: Plenty</option>
                    </select>
                    <select id="filter-wifi" name="wifi">
                        <option value="">Wi-Fi: Any</option>
                        <option value="Basic" <%= "Basic".equals(wifi) ? "selected" : "" %>>Wi-Fi: Basic</option>
                        <option value="Strong" <%= "Strong".equals(wifi) ? "selected" : "" %>>Wi-Fi: Strong</option>
                    </select>
                    <select id="filter-seating" name="minimumSeating">
                        <option value="" <%= "".equals(minimumSeating) ? "selected" : "" %>>Seating: Any</option>
                        <option value="3" <%= "3".equals(minimumSeating) ? "selected" : "" %>>Seating: Moderate or better</option>
                        <option value="4" <%= "4".equals(minimumSeating) ? "selected" : "" %>>Seating: Plenty</option>
                    </select>
                </div>
            </fieldset>
            <div class="filter-status">
                <a class="clear-filters" href="${pageContext.request.contextPath}/index.jsp">Clear all</a>
            </div>
        </form>
    </section>

    <section class="results-section">
        <div class="results-heading">
            <div>
                <h2>Nearby Spots</h2>
                <p class="results-count"><%= places.size() %> <%= places.size() == 1 ? "spot found" : "spots found" %></p>
            </div>
            <label class="sort-control" for="filter-sort">Sort by
                <select id="filter-sort" name="sort" form="spot-search" onchange="this.form.requestSubmit()">
                    <option value="rating" <%= "rating".equals(sort) ? "selected" : "" %>>Highest rated</option>
                    <option value="distance" <%= "distance".equals(sort) ? "selected" : "" %>>Nearest</option>
                </select>
            </label>
        </div>
        <% if (searchError != null) { %>
            <p class="location-error"><%= escapeHtml(searchError) %></p>
        <% } else if (places.isEmpty()) { %>
            <p class="empty-results">No spots match your filters. Try changing your selections.</p>
        <% } %>
        <%
            for (Place place : places) {
        %>

            <article class="spot-card">
                <div class="spot-info">
                    <div class="spot-header">
                        <h3>
                            <a class="spot-details-link" href="${pageContext.request.contextPath}/pages/places/place-details.jsp?placeId=<%= place.getPlaceId() %>">
                                <%= escapeHtml(place.getName()) %>
                            </a>
                        </h3>
                        <span class="rating">
                            <%= place.getAvgStarRating() == 0
                                ? "Not yet rated"
                                : String.format("%.1f", place.getAvgStarRating()) %>
                        </span>
                    </div>
                    <p class="spot-meta">
                        <%= place.getCategory() %> &middot;
                        <%= String.format(java.util.Locale.US, "%.1f", place.getDistanceMiles()) %> miles away
                    </p>
                    <p class="spot-address">
                        <%= place.getAddress() %>
                    </p>
                    <p class="spot-tags">
                        Noise: <%= place.getAvgNoiseLevel() %> &middot;
                        Outlets: <%= place.getAvgOutletDensity() %> &middot;
                        Wi-Fi: <%= place.getAvgWifiSpeed() %>
                    </p>
                    
				<% if (loggedInEmail != null) { %>
                    <form action="${pageContext.request.contextPath}/report"
                           method="POST">

                    <input type="hidden"
                           name="placeId"
                           value="<%= place.getPlaceId() %>">

                    <input type="text"
                           name="reason"
                           placeholder="Reason for reporting"
                           maxlength="255"
                           required>

                    <button type="submit">Report Spot</button>
                    <% } %>
                </form>
                </div>
            </article>

        <%
            }
        %>

    </section>

    <script src="${pageContext.request.contextPath}/js/search-location.js" defer></script>
    <script>
        setTimeout(function() {
            const message = document.querySelector(".success-message");
            if (message) {
                message.style.display = "none";
            }
        }, 4000);
    </script>

</body>
</html>
