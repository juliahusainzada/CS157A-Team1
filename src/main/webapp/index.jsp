<%@ page import="java.util.List" %>
<%@ page import="studyspotter.Place" %>
<%@ page import="studyspotter.PlaceDAO" %>

<html>
<head>
	<title>StudySpotter</title>
	<nav>
		<button>Log In</button>
		<button>Sign Up</button>
	</nav>
</head>

<body>

	<h1>StudySpotter</h1>

	<section>
		<h2>Find a Study Spot</h2>

		<form>
			<label>
				Location:
				<input type="text" placeholder="City or ZIP">
			</label>

			<label>
				Radius:
				<select>
					<option>5 miles</option>
					<option>10 miles</option>
					<option>15 miles</option>
				</select>
			</label>

			<label>
				Noise Level:
				<select>
					<option>Any</option>
					<option>Quiet</option>
					<option>Moderate</option>
					<option>Loud</option>
				</select>
			</label>

			<label>
				Outlets:
				<select>
					<option>Any</option>
					<option>Few</option>
					<option>Plenty</option>
				</select>
			</label>

			<label>
				Wi-Fi:
				<select>
					<option>Any</option>
					<option>Basic</option>
					<option>Strong</option>
				</select>
			</label>

			<label>
				Sort by:
				<select>
					<option>Highest rated</option>
					<option>Nearest</option>
				</select>
			</label>

			<button type="button">Search</button>
		</form>
	</section>

	<!-- Results loaded dynamically from MySQL -->
	<section>
		<h2>Nearby Spots</h2>

		<%
			PlaceDAO placeDAO = new PlaceDAO();
			List<Place> places = placeDAO.getAllPlacesByRating();

			for (Place place : places) {
		%>

			<article>
				<h3><%= place.getName() %></h3>

				<p><%= place.getCategory() %></p>

				<p>Rating: <%= place.getOverallRating() %> / 5</p>

				<p>
					<%= place.getAddress() %>,
					<%= place.getCity() %>,
					<%= place.getState() %>
					<%= place.getZipCode() %>
				</p>

				<p>Noise: <%= place.getNoiseLevel() %></p>
				<p>Outlets: <%= place.getOutletLevel() %></p>
				<p>Wi-Fi: <%= place.getWifiLevel() %></p>
			</article>

		<%
			}
		%>

	</section>

</body>
</html>