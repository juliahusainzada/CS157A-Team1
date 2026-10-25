<%@ page import="java.util.List" %>

<html>
<head>
	<title>Login - StudySpotter</title>
	<link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>

<body>
	<header>
		<h1>
			<span class="logo-script">Study</span>
			<span class="logo-serif">Spotter</span>
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
		
		    <button type="submit">Login</button>
		</form>
	
	</section>
	
</body>
</html>