<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="studyspotter.places.Place" %>
<%@ page import="studyspotter.places.PlaceDAO" %>
<%@ page import="studyspotter.places.MenuItem" %>
<%@ page import="studyspotter.places.Review" %>
<%@ page import="java.util.List" %>

<%!
    private String escapeHtml(String value) {
        if (value == null) return "";
        return value.replace("&", "&amp;")
                    .replace("<", "&lt;")
                    .replace(">", "&gt;")
                    .replace("\"", "&quot;")
                    .replace("'", "&#39;");
    }

    private String formatScore(double score) {
        if (score == 0) return "Not yet rated";
        return String.format(java.util.Locale.US, "%.1f / 5", score);
    }
%>

<%
    Place place = null;
    String detailsError = null;
    Integer userId = (Integer) session.getAttribute("userId");
    boolean isStudent = userId != null && "STUDENT".equals(session.getAttribute("role"));
    boolean bookmarked = false;
    List<MenuItem> menuItems = java.util.Collections.emptyList();
    List<Review> reviews = java.util.Collections.emptyList();
    List<String> amenities = java.util.Collections.emptyList();

    try {
        int placeId = Integer.parseInt(request.getParameter("placeId"));
        if (placeId <= 0) {
            throw new NumberFormatException();
        }

        PlaceDAO placeDAO = new PlaceDAO();
        place = placeDAO.getPlaceById(placeId);
        if (place == null) {
            response.setStatus(404);
            detailsError = "This study spot could not be found.";
        } else {
            menuItems = placeDAO.getMenuItems(placeId);
            reviews = placeDAO.getReviews(placeId);
            amenities = placeDAO.getAmenities(placeId);
            if (isStudent) {
                bookmarked = placeDAO.isBookmarked(userId, placeId);
            }
        }
    } catch (NumberFormatException e) {
        response.setStatus(400);
        detailsError = "Please select a valid study spot from the home feed.";
    } catch (java.sql.SQLException e) {
        application.log("Unable to load study spot details.", e);
        response.setStatus(500);
        detailsError = "Unable to load this spot right now. Please try again.";
    }
%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title><%= place == null ? "Spot Details" : escapeHtml(place.getName()) %> - StudySpotter</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body>
    <header>
        <h1>
            <a class="logo-link" href="${pageContext.request.contextPath}/index.jsp">
                <span class="logo-script">Study</span>
                <span class="logo-serif">Spotter</span>
            </a>
        </h1>
        <nav>
            <a href="${pageContext.request.contextPath}/index.jsp">Back to Spots</a>
        </nav>
    </header>

    <main class="place-details">
        <% if (detailsError != null) { %>
            <h2>Spot Details</h2>
            <p><%= escapeHtml(detailsError) %></p>
        <% } else { %>
            <section class="place-overview">
                <div class="place-overview-info">
                    <p class="spot-meta"><%= escapeHtml(place.getCategory()) %></p>
                    <h2><%= escapeHtml(place.getName()) %></h2>
                    <p class="spot-address"><%= escapeHtml(place.getAddress()) %></p>
                    <p class="rating">Overall rating: <%= formatScore(place.getAvgStarRating()) %></p>
                </div>
                <div class="place-overview-actions">
                    <% if (isStudent) { %>
                        <form action="${pageContext.request.contextPath}/bookmark" method="POST">
                            <input type="hidden" name="placeId" value="<%= place.getPlaceId() %>">
                            <input type="hidden" name="action" value="<%= bookmarked ? "remove" : "save" %>">
                            <button class="bookmark-button" type="submit"><%= bookmarked ? "Remove Bookmark" : "Bookmark" %></button>
                        </form>
                    <% } else if (userId == null) { %>
                        <a class="bookmark-button" href="${pageContext.request.contextPath}/pages/login.jsp">Log in to bookmark</a>
                    <% } else { %>
                        <p class="detail-placeholder">Bookmarks are available to student accounts.</p>
                    <% } %>
                </div>
            </section>

            <section class="place-detail-section">
                <h2>Scores</h2>
                <div class="place-scores">
                    <dl><dt>Noise</dt><dd><%= formatScore(place.getAvgNoiseLevel()) %></dd></dl>
                    <dl><dt>Outlets</dt><dd><%= formatScore(place.getAvgOutletDensity()) %></dd></dl>
                    <dl><dt>Wi-Fi</dt><dd><%= formatScore(place.getAvgWifiSpeed()) %></dd></dl>
                    <dl><dt>Seating</dt><dd><%= formatScore(place.getAvgSeatingAvailability()) %></dd></dl>
                    <dl><dt>Food quality</dt><dd><%= formatScore(place.getAvgFoodQuality()) %></dd></dl>
                    <dl><dt>Ambience</dt><dd><%= formatScore(place.getAvgAmbienceScore()) %></dd></dl>
                </div>
            </section>

            <section class="place-detail-section">
                <h2>Amenities</h2>
                <% if (amenities.isEmpty()) { %>
                    <p class="detail-placeholder">No amenities listed for this spot yet.</p>
                <% } else { %>
                    <ul class="place-amenities">
                        <% for (String amenity : amenities) { %>
                            <li><%= escapeHtml(amenity) %></li>
                        <% } %>
                    </ul>
                <% } %>
            </section>

            <section class="place-detail-section">
                <h2>Menu</h2>
                <% if (menuItems.isEmpty()) { %>
                    <p class="detail-placeholder">No menu items listed for this spot yet.</p>
                <% } else { %>
                    <% for (MenuItem item : menuItems) { %>
                        <article class="place-detail-entry">
                            <div class="detail-entry-heading">
                                <h3><%= escapeHtml(item.getName()) %></h3>
                                <span><%= item.getPrice() == null ? "Price unavailable" : "$" + item.getPrice().toPlainString() %></span>
                            </div>
                            <p><%= escapeHtml(item.getDescription()) %></p>
                            <% if (item.getDietaryFlags() != null && !item.getDietaryFlags().isBlank()) { %>
                                <p class="menu-dietary"><%= escapeHtml(item.getDietaryFlags()) %></p>
                            <% } %>
                        </article>
                    <% } %>
                <% } %>
            </section>

            <section class="place-detail-section">
                <h2>Reviews</h2>
                <% if (reviews.isEmpty()) { %>
                    <p class="detail-placeholder">No reviews for this spot yet.</p>
                <% } else { %>
                    <% for (Review review : reviews) { %>
                        <article class="place-detail-entry">
                            <div class="detail-entry-heading">
                                <h3>Student review</h3>
                                <span class="rating"><%= formatScore(review.getRating()) %></span>
                            </div>
                            <p class="review-date"><%= review.getCreatedAt().toLocalDate() %></p>
                            <p class="review-text"><%= escapeHtml(review.getReviewText()) %></p>
                            <div class="place-scores review-scores">
                                <dl><dt>Noise</dt><dd><%= formatScore(review.getNoiseLevel()) %></dd></dl>
                                <dl><dt>Outlets</dt><dd><%= formatScore(review.getOutletCount()) %></dd></dl>
                                <dl><dt>Wi-Fi</dt><dd><%= formatScore(review.getWifiSpeed()) %></dd></dl>
                                <dl><dt>Seating</dt><dd><%= formatScore(review.getSeating()) %></dd></dl>
                                <dl><dt>Food quality</dt><dd><%= formatScore(review.getFoodQuality()) %></dd></dl>
                                <dl><dt>Ambience</dt><dd><%= formatScore(review.getAmbiance()) %></dd></dl>
                            </div>
                        </article>
                    <% } %>
                <% } %>
            </section>
        <% } %>
    </main>
</body>
</html>
