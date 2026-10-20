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
	
		<form class="">
			<label>
				Email:
				<input type="text" placeholder="Email">
			</label>
			<label>
				New Password:
				<input type="text" placeholder="Password">
			</label>
			<input type="checkbox" id="student" name="student" value="yes">
			<label for="student">I am a student</label>
			

			<button type="button" class="">Sign Up</button>
		</form>
	
	</section>
	
</body>
</html>