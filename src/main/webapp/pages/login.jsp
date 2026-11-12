<%@ page import="java.util.List" %>

<html>
<head>
	<title>Login - StudySpotter</title>
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
			<button>Log In</button>
			<button onclick="window.location.href='register.jsp'">   Sign Up</button>
		</nav>
	</header>
	<section>
	
		<form method="post"
		      action="${pageContext.request.contextPath}/login">
		
		    <label>Email:</label>
		    <input type="email" name="email" required>
		
		    <label>Password:</label>
		    <input type="password" name="password" required>
		
		    <button type="submit">Log In</button>
		</form>
		
		<%
		    String loginError = request.getParameter("error");
		%>
		
		<% if ("invalid".equals(loginError)) { %>
		    <p class="error">Invalid email or password.</p>
		<% } else if ("inactive".equals(loginError)) { %>
		    <p class="error">This account is inactive or banned.</p>
		<% } else if ("database".equals(loginError)) { %>
		    <p class="error">A database error occurred. Please try again later.</p>
		<% } %>
	</section>
	
</body>
</html>