<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.List,studyspotter.places.Place,studyspotter.places.PlaceDAO" %>
<%!
    private String escapeHtml(String value) {
        if (value == null) return "";
        return value.replace("&", "&amp;")
                    .replace("<", "&lt;")
                    .replace(">", "&gt;")
                    .replace("\"", "&quot;")
                    .replace("'", "&#39;");
    }

%>
<%
    if (!(session.getAttribute("userId") instanceof Integer)) {
        response.sendRedirect(request.getContextPath() + "/pages/login.jsp");
        return;
    }
    if (!"STUDENT".equals(session.getAttribute("role"))) {
        response.sendError(403, "Only students can access saved spots.");
        return;
    }
    boolean savedSpots = true;
    String loggedInEmail = (String) session.getAttribute("email");
    List<Place> places = java.util.Collections.emptyList();
    String savedError = null;
    try {
        places = new PlaceDAO().getSavedPlaces((Integer) session.getAttribute("userId"));
    } catch (java.sql.SQLException e) {
        application.log("Unable to load saved spots.", e);
        response.setStatus(500);
        savedError = "Unable to load saved spots right now. Please try again.";
    }
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Saved Spots - StudySpotter</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css?v=saved-spots-2">
</head>
<body>
    <header>
        <h1><a class="logo-link" href="${pageContext.request.contextPath}/index.jsp"><span class="logo-script">Study</span> <span class="logo-serif">Spotter</span></a></h1>
        <nav>
            <a href="${pageContext.request.contextPath}/index.jsp">Back to Spots</a>
            <details class="study-spots-menu">
                    <summary>Study Spots</summary>
                    <div class="study-spots-options">
                        <a href="${pageContext.request.contextPath}/pages/places/saved-spots.jsp">Saved Spots</a>
                        <a href="${pageContext.request.contextPath}/pages/places/add-place.jsp">Add a spot</a>
                    </div>
                </details>
            <a href="${pageContext.request.contextPath}/logout">Log Out</a>
        </nav>
    </header>
    <main class="results-section">
        <div class="results-heading">
            <div>
                <h2>Saved Spots</h2>
                <p class="results-count"><%= places.size() %> <%= places.size() == 1 ? "saved spot" : "saved spots" %></p>
            </div>
        </div>
        <% if ("1".equals(request.getParameter("removed"))) { %>
            <p role="status">Spot removed from your saved spots.</p>
        <% } %>
        <% if (savedError != null) { %>
            <p class="location-error"><%= escapeHtml(savedError) %></p>
        <% } else if (places.isEmpty()) { %>
            <p class="empty-results">You haven't saved any spots yet. <a href="${pageContext.request.contextPath}/index.jsp">Explore spots</a> and save your favorites from their details pages.</p>
        <% } %>
        <% for (Place place : places) { %>
            <article class="spot-card<%= savedSpots ? " saved-spot-card" : "" %>">
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
                        <%= escapeHtml(place.getCategory()) %>
                        <% if (!savedSpots) { %> &middot;
                        <%= String.format(java.util.Locale.US, "%.1f", place.getDistanceMiles()) %> miles away
                        <% } %>
                    </p>
                    <p class="spot-address">
                        <%= escapeHtml(place.getAddress()) %>
                    </p>
                    <p class="spot-tags">
                        Noise: <%= place.getAvgNoiseLevel() %> &middot;
                        Outlets: <%= place.getAvgOutletDensity() %> &middot;
                        Wi-Fi: <%= place.getAvgWifiSpeed() %>
                    </p>
                    
                <% if (savedSpots) { %>
                    <form action="${pageContext.request.contextPath}/bookmark" method="POST">
                        <input type="hidden" name="placeId" value="<%= place.getPlaceId() %>">
                        <input type="hidden" name="action" value="remove">
                        <input type="hidden" name="returnTo" value="saved">
                        <button type="submit">Unsave</button>
                    </form>
                <% } else if (loggedInEmail != null) { %>
                    <form action="${pageContext.request.contextPath}/report" method="POST">
                        <input type="hidden" name="placeId" value="<%= place.getPlaceId() %>">
                        <input type="text" name="reason" placeholder="Reason for reporting" maxlength="255" required>
                        <button type="submit">Report Spot</button>
                    </form>
                <% } %>
                </div>
            </article>
        <% } %>
    </main>
</body>
</html>
