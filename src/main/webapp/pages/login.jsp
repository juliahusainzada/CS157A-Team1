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
	
		<form class="">
			<label>
				Email:
				<input type="text" placeholder="Email">
			</label>
			<label>
				Password:
				<input type="text" placeholder="Password">
			</label>

			<button type="button" class="">Login</button>
		</form>
	
	</section>
	
</body>
</html>