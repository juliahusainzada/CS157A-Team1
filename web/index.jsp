<%@ page import="java.sql.*"%>
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
				<label>Location: <input type="text" placeholder="City or ZIP"></label>

				<label>Radius:
					<select>
						<option>5 miles</option>
						<option>10 miles</option>
						<option>15 miles</option>
					</select>
				</label>

				<label>Noise Level:
					<select>
						<option>Any</option>
						<option>Quiet</option>
						<option>Moderate</option>
						<option>Loud</option>
					</select>
				</label>

				<label>Outlets:
					<select>
						<option>Any</option>
						<option>Few</option>
						<option>Plenty</option>
					</select>
				</label>

				<label>Wi-Fi:
					<select>
						<option>Any</option>
						<option>Basic</option>
						<option>Strong</option>
					</select>
				</label>

				<label>Sort by:
					<select>
						<option>Highest rated</option>
						<option>Nearest</option>
					</select>
				</label>

				<button type="button">Search</button>
			</form>
		</section>

		<!-- results section (hard coded right now) -->
		<section>
			<h2>Nearby Spots</h2>

			<article>
				<h3>Sample Spot</h3>
				<p>Category</p>
				<p>Rating: 4.5 / 5</p>
				<p>Distance: 0.8 mi</p>
				<p>Quiet</p>
				<p>20+ Outlets</p>
			</article>
		</section>
	</main>

<table border="1">
  <tr>
    <td>ID</td>
    <td>EMAIL</td>
    <td>DATE_CREATED</td>
  </tr>
    <%
     String db = "studyspotter";
        String user;
          user = "root";
        String password = "your_password_here";
        try {
            java.sql.Connection con;
            Class.forName("com.mysql.jdbc.Driver");

            con = DriverManager.getConnection("jdbc:mysql://localhost:3306/studyspotter?autoReconnect=true&useSSL=false",user, password);

            out.println(db + " database successfully opened.<br/><br/>");

            out.println("Initial entries in table \"User\": <br/>");

            Statement stmt = con.createStatement();

            ResultSet rs = stmt.executeQuery("SELECT * FROM users");

            while (rs.next()) {
         out.println("<tr>" + "<td>" +  rs.getInt(1) + "</td>" + "<td>" +  rs.getString(2) + "</td>"+ "<td>" +    rs.getInt(3) + "</td>"+   "<td>" + rs.getDate(4) + "</td>"  + "</tr>");
            }
            rs.close();
            stmt.close();
            con.close();
        } catch(SQLException e) {
            out.println("SQLException caught: " + e.getMessage());
        }
    %>
</body>
</html>