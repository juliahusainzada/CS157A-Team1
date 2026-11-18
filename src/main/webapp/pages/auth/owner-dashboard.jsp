<%@ page import="java.util.List" %>
<%@ page import="studyspotter.places.Place" %> 
<%@ page import="studyspotter.places.PlaceDAO" %>
<%@ page import="java.sql.SQLException" %>
<%@ page import="studyspotter.places.ClaimDAO" %>
<%@ page import="studyspotter.places.ClaimDAO.PendingClaim" %>
<%@ page import="studyspotter.places.ClaimDAO.ApprovedBusiness" %>

<%
    Object userIdObject = session.getAttribute("userId");

    if (!(userIdObject instanceof Integer)) {
        response.sendRedirect(request.getContextPath() + "/pages/login.jsp");
        return;
    }

    int ownerId = (Integer) userIdObject;

    List<PendingClaim> pendingClaims;
    List<ApprovedBusiness> approvedBusinesses;

    try {
        ClaimDAO claimDAO = new ClaimDAO();
        pendingClaims = claimDAO.getPendingClaims(ownerId);
        approvedBusinesses = claimDAO.getApprovedBusinesses(ownerId);

    } catch (SQLException e) {
        throw new jakarta.servlet.ServletException(
            "Unable to load owner dashboard...", e
        );
    }
%>


<html>
<head>
    <meta name="viewport" content="width=device-width, initial-scale=1">
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
                String loggedInEmail = (String) session.getAttribute("email");

                String role = (String) session.getAttribute("role");
            %>

            <a href="${pageContext.request.contextPath}/pages/places/add-place.jsp">
                Add a Spot
            </a>
            
                <a href="${pageContext.request.contextPath}/">
                    Home
                </a>
            
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
        	<% if ("OWNER".equals(role)) { %>
                

        		<section class="dashboard-section">
                
                <h1>Your Business: </h1>
			    <% if (approvedBusinesses.isEmpty()) { %>
			        <p>You do not have any approved businesses yet.</p>
			    <% } else { %>
			
			        <% for (ApprovedBusiness business : approvedBusinesses) { %>
			            <div class="business-card">
			                <h3><%= business.getName() %></h3>
			                <p>
			                    <strong>Category:</strong>
			                    <%= business.getCategory() %>
			                </p>
			                <p>
			                    <strong>Address:</strong>
			                    <%= business.getAddress() %>
			                </p>
			                <p>
			                    <strong>Rating:</strong>
			                    <%= business.getRating() %>
			                </p>
			                <a href="${pageContext.request.contextPath}/pages/places/place-details.jsp?placeId=<%= business.getPlaceId() %>">
			                    View Business
			                </a>
			            </div>
			        <% } %>
			    
				
				    <% } %>
				</section>
				<section class="dashboard-section">
				    
				
				    <% if (pendingClaims.isEmpty()) { %>
				        <p>You do not have any pending claim requests.</p>
				    <% } else { %>
				
				        <% for (PendingClaim claim : pendingClaims) { %>
				        <h2>Your Pending Businesses: </h2>
				            <div class="business-card">
				                <h3><%= claim.getPlaceName() %></h3>
				                <p>
				                    <strong>Address:</strong>
				                    <%= claim.getAddress() %>
				                </p>
				
				                <p>
				                    <strong>Status:</strong>
				                    <%= claim.getStatus() %>
				                </p>
				
				                <p>
				                    <strong>Submitted:</strong>
				                    <%= claim.getCreatedAt() %>
				                </p>
				
				                <p>
				                    Your request is waiting for approval! Hang tight!
				                </p>
				            </div>
				        <% } %>
				
				    <% } %>
				</section>
                <br>
                
                
            <% } else {%>
            
            <p> You are not a business owner. </p>
            
            <% } %>
        
        </body>
        </html>