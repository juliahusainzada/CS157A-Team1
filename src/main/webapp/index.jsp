<%@ page import="java.util.List" %>
<%@ page import="studyspotter.Place" %>
<%@ page import="studyspotter.PlaceDAO" %>

<html>
<head>
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
			
			<a href="${pageContext.request.contextPath}/pages/add-place.jsp">
			    Add a Spot
			</a>
			
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

	<section class='search-section'>
		<h2>Find a Study Spot</h2>

		<form class="search-form">
			<label>
				Location:
				<input type="text" placeholder="City or ZIP">
			</label>

			<button type="button" class="btn-search">Search</button>
		</form>
		
		<%
			String noise = request.getParameter("noise");
			String outlets = request.getParameter("outlets");
			String wifi = request.getParameter("wifi");
		%>
		
		<form class="filter-form" method="GET">

			<div class="search-filters">
				<select>
					<option>Radius: 5 miles</option>
					<option>Radius: 10 miles</option>
					<option>Radius: 15 miles</option>
				</select>
	
				<select name ="noise">
					<option value="">Noise: Any</option>
					<option value="Quiet">Noise: Quiet</option>
					<option value="Moderate">Noise: Moderate</option>
					<option value="Loud">Noise: Loud</option>
				</select>
	
				<select name="outlets">
					<option value="">Outlets: Any</option>
					<option value="Some">Outlets: Few</option>
					<option value="Plenty">Outlets: Plenty</option>
				</select>
	
				<select name="wifi">
					<option value="">Wi-Fi: Any</option>
					<option value="Basic">Wi-Fi: Basic</option>
					<option value="Strong">Wi-Fi: Strong</option>
				</select>
	
				<select>
					<option>Sort: Highest rated</option>
					<option>Sort: Nearest</option>
				</select>
				
				<button type="submit">Apply Filters</button>
			</div>
		
		</form>
	</section>

	<!-- Results loaded dynamically from MySQL -->
	<section class='results-section'>
		<h2>Nearby Spots</h2>

		<%
			PlaceDAO placeDAO = new PlaceDAO();
			List<Place> places = placeDAO.getFilteredPlaces(noise, outlets, wifi);

			for (Place place : places) {
		%>

			<article class="spot-card">
			    <div class="spot-info">
			        <div class="spot-header">
			            <h3><%= place.getName() %></h3>
			            <span class="rating">
			                <%= place.getAvgStarRating() == 0
			                    ? "Not yet rated"
			                    : String.format("%.1f", place.getAvgStarRating()) %>
			            </span>
			        </div>
			        <p class="spot-meta">
			            <%= place.getCategory() %>
			        </p>
			        <p class="spot-address">
			            <%= place.getAddress() %>
			        </p>
			        <p class="spot-tags">
			            Noise: <%= place.getAvgNoiseLevel() %> &middot;
			            Outlets: <%= place.getAvgOutletDensity() %> &middot;
			            Wi-Fi: <%= place.getAvgWifiSpeed() %>
			        </p>
			    </div>
			</article>

		<%
			}
		%>

	</section>

</body>
</html>