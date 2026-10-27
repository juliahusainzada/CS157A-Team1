<%@ page import="java.util.List" %>
<%@ page import="studyspotter.places.Place" %> 
<%@ page import="studyspotter.places.PlaceDAO" %>
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
        
        <h1>Your Business</h1>
        <p>Under Review</p>
        </body>
        </html>