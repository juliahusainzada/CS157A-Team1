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
			<button onclick="window.location.href='login.jsp'">Log In</button>
			<button >   Sign Up</button>
		</nav>
	</header>
	<section>
	
		<form method="post"
     	 	action="${pageContext.request.contextPath}/register">
		
		    <label>Email:</label>
		    <input type="email" name="email" required>
		    <label>Password:</label>
		    <input type="password" name="password" required>
		
		    <label>Account Type:</label>
		    <select name="accountType" required>
		        <option value="STUDENT">Student</option>
		        <option value="OWNER">Business Owner</option>
		    </select>
		
		    <button type="submit">Sign Up</button>
		</form>
	
	</section>
	
</body>
</html>