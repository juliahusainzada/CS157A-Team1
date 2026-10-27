package studyspotter;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/report")
public class ReportServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    @Override
    protected void doPost(HttpServletRequest request,
                          HttpServletResponse response)
            throws ServletException, IOException {

        // Check whether user is logged in
        HttpSession session = request.getSession(false);

        if (session == null ||
                !(session.getAttribute("userId") instanceof Integer)) {
            response.sendRedirect(
                request.getContextPath() + "/pages/login.jsp"
            );
            return;
        }

        int userId = (Integer) session.getAttribute("userId");

        // Retrieve and validate form inputs
        String reason = request.getParameter("reason");
        int placeId;

        try {
            placeId = Integer.parseInt(request.getParameter("placeId"));

            if (placeId <= 0 || reason == null ||
                    reason.isBlank() || reason.length() > 255) {
                response.sendError(400, "Invalid report information.");
                return;
            }

        } catch (NumberFormatException e) {
            response.sendError(400, "Invalid place ID.");
            return;
        }

        // Insert report into MySQL
        String sql = """
            INSERT INTO Reports
                (reporter_id, place_id, reason, status)
            VALUES (?, ?, ?, 'Open')
            """;

        try (Connection connection = DatabaseConnection.getConnection();
             PreparedStatement statement = connection.prepareStatement(sql)) {

            statement.setInt(1, userId);
            statement.setInt(2, placeId);
            statement.setString(3, reason.trim());

            statement.executeUpdate();

            // Redirect to homepage after successful submission
            response.sendRedirect(
                request.getContextPath() + "/index.jsp?reported=1"
            );

        } catch (SQLException e) {
            throw new ServletException("Unable to submit report.", e);
        }
    }
}