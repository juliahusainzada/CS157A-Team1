<%@ page import="java.util.List" %>
<%@ page import="studyspotter.places.Place" %> 
<%@ page import="studyspotter.places.PlaceDAO" %>
<%@ page import="studyspotter.auth.UserDAO" %>
<%@ page import="studyspotter.auth.User" %>
<%@ page import="studyspotter.places.ReportDAO" %>
<%@ page import="studyspotter.places.Report" %>
<%@ page import="java.util.List" %>

<%
    UserDAO userDAO = new UserDAO();
    List<User> unverifiedUsers = userDAO.getUnverifiedUsers();
    ReportDAO reportDAO = new ReportDAO();
    List<Report> reports = reportDAO.getOpenReports();
%>
<%!
    private String escapeHtml(String value) {
        if (value == null) return "";
        return value.replace("&", "&amp;")
                    .replace("<", "&lt;")
                    .replace(">", "&gt;")
                    .replace("\"", "&quot;")
                    .replace("'", "&#39;");
    }

    private String filterChoice(String value, String... allowed) {
        if (value == null) value = "";
        for (String choice : allowed) {
            if (choice.equals(value)) return value;
        }
        throw new IllegalArgumentException("Invalid filter selection. Please choose one of the listed options.");
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
                String loggedInEmail =
                        (String) session.getAttribute("email");

                String role =
                        (String) session.getAttribute("role");
            %>

        

            
                <a href="${pageContext.request.contextPath}/">
                    Home
                </a>
            
            <% if (loggedInEmail == null ) { %>

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
        	<% if ("ADMIN".equals(role)) { %>
                
                <h2>Unverified Users: </h2>
                
                <% for (User user : unverifiedUsers) { %>
				    <p><%= user.getEmail() %> - 
				    <%= user.getRole() %> 
				    </p>
				    
				    <!-- TODO: make detailed page to check studentIDs and institutions, 
				    business owners and their pending business claims, and then add an
				    option to verify them. -->
				<% } %>
                
                <h2>Reports: </h2>
	                <% for (Report report : reports) { %>
	                <article class="spot-card">
				    <div class="report-card">
				        <p><strong>Reason: </strong><%= report.getReason() %>
				        </p>
				
				        <p><strong>Reported by:</strong>
				            <%= report.getReporterEmail() %>
				        </p>
				
				        <p><strong>Status:</strong>
				            <%= report.getStatus() %>
				        </p>
				
				        <% if (report.getPlaceName() != null) { %>
				            <p><strong>Place:</strong>
				                <%= report.getPlaceName() %>
				            </p>
				        <% } %>
				        <% if (report.getReviewText() != null) { %>
				            <p><strong>Review:</strong>
				                <%= report.getReviewText() %>
				            </p>
				        <% } %>
				    </div>
				    </article>
				<% } %>
                
            <% } else {%>
            
            <p> You are not an admin. </p>
            
            <% } %>
        </body>
        </html>
        