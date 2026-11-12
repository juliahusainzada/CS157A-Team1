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
			<button onclick="window.location.href='login.jsp'">Log In</button>
			<button >   Sign Up</button>
		</nav>
	</header>
	<section>
	
		<form method="post" action="${pageContext.request.contextPath}/register">
			<div>
			    <label>Email:</label>
			    <input type="email" name="email"  required>
			</div>
			<div>
		    <label>Password:</label>
		    <input type="password"  name="password" required>
		</div>
		
	    <div>
	        <label for="accountType">Account type:</label>

			<select id="accountType" name="accountType" required>
			    <option value="">Select account type</option>
			    <option value="STUDENT">Student</option>
			    <option value="OWNER">Business Owner</option>
			</select>
			
			<div id="studentFields" hidden>
			    <label for="studentId">Student ID:</label>
			    <input type="text" id="studentId" name="studentId">
			
			    <label for="institution">Institution:</label>
			    <input type="text" id="institution" name="institution">
			</div>
			
			<div id="ownerFields" hidden>
			    <label for="businessName">Business name:</label>
			    <input type="text" id="businessName" name="businessName">
			</div>
			
			<script>
			    const accountType = document.getElementById("accountType");
			    const studentFields = document.getElementById("studentFields");
			    const ownerFields = document.getElementById("ownerFields");
			
			    const studentId = document.getElementById("studentId");
			    const institution = document.getElementById("institution");
			    const businessName = document.getElementById("businessName");
			
			    function updateFields() {
			        const selectedType = accountType.value;
			
			        const isStudent = selectedType === "STUDENT";
			        const isOwner = selectedType === "OWNER";
			
			        studentFields.hidden = !isStudent;
			        ownerFields.hidden = !isOwner;
			
			        studentId.required = isStudent;
			        institution.required = isStudent;
			        businessName.required = isOwner;
			
			        if (!isStudent) {
			            studentId.value = "";
			            institution.value = "";
			        }
			
			        if (!isOwner) {
			            businessName.value = "";
			        }
			    }
			
			    accountType.addEventListener("change", updateFields);
			    updateFields();
			</script>
	    </div>
		    <!-- <div>
		        <label>Business proof:</label>
		        <input type="file" name="businessProof">
		        <p> Will add file option eventually, does not work for now.</p>
		    </div> -->
		
		    <button type="submit">Create Account</button>
		    
		</form>
	
	</section>
	<%
	    String registrationError = request.getParameter("error");
	%>
	
	<%  if ("student_email".equals(registrationError)) { %>
	    <p class="error">Students must use a valid .edu email address.</p>
	<% } else if ("institution".equals(registrationError)) { %>
	    <p class="error">Please enter your institution.</p>
	<% } else if ("business".equals(registrationError)) { %>
	    <p class="error">Please enter your business name.</p>
	<% } else if ("duplicate".equals(registrationError)) { %>
	    <p class="error">An account with that email already exists.</p>
	<% } else if ("role".equals(registrationError)) { %>
	    <p class="error">Please select a valid account type.</p>
	<% } %>
	
</body>
</html>