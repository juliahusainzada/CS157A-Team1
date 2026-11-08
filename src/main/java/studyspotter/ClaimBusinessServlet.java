package studyspotter;

import java.io.IOException;
import java.sql.*;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

@WebServlet("/claim-business")
public class ClaimBusinessServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    @Override
    protected void doPost(HttpServletRequest request,
                          HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);

        if (session == null ||
            !"OWNER".equals(session.getAttribute("role")) ||
            !(session.getAttribute("userId") instanceof Integer)) {

            response.sendError(403, "Only business owners can submit claims.");
            return;
        }

        int userId = (Integer) session.getAttribute("userId");
        int placeId;

        try {
            placeId = Integer.parseInt(request.getParameter("placeId"));
            if (placeId <= 0) throw new NumberFormatException();
        } catch (NumberFormatException e) {
            response.sendError(400, "Invalid study spot.");
            return;
        }

        String verificationUrl = request.getParameter("verificationUrl");

        if (verificationUrl == null || verificationUrl.isBlank() || verificationUrl.length() > 255) {
            response.sendError(400, "A verification document URL is required (max 255 characters).");
            return;
        }

        String redirect = request.getContextPath()
                + "/pages/places/place-details.jsp?placeId=" + placeId;

        try (Connection conn = DatabaseConnection.getConnection()) {

            conn.setAutoCommit(false);

            try {
                // Lock the spot while checking ownership (ACID)
                String checkPlace = """
                    SELECT owner_user_id
                    FROM Places
                    WHERE place_id = ?
                    FOR UPDATE
                    """;

                try (PreparedStatement stmt = conn.prepareStatement(checkPlace)) {
                    stmt.setInt(1, placeId);

                    try (ResultSet rs = stmt.executeQuery()) {
                        if (!rs.next()) {
                            conn.rollback();
                            response.sendError(404, "Study spot not found.");
                            return;
                        }

                        if (rs.getObject("owner_user_id") != null) {
                            conn.rollback();
                            response.sendRedirect(redirect + "&claim=owned");
                            return;
                        }
                    }
                }

                // Check for an existing pending claim from same user
                String checkDuplicate = """
                    SELECT claim_id
                    FROM ClaimRequests
                    WHERE user_id = ?
                      AND place_id = ?
                      AND status = 'Pending'
                    LIMIT 1
                    """;

                try (PreparedStatement stmt = conn.prepareStatement(checkDuplicate)) {
                    stmt.setInt(1, userId);
                    stmt.setInt(2, placeId);

                    try (ResultSet rs = stmt.executeQuery()) {
                        if (rs.next()) {
                            conn.rollback();
                            response.sendRedirect(redirect + "&claim=duplicate");
                            return;
                        }
                    }
                }

                // Save the claim
                String insert = """
                    INSERT INTO ClaimRequests
                        (user_id, place_id, verification_document_url, status)
                    VALUES (?, ?, ?, 'Pending')
                    """;

                try (PreparedStatement stmt = conn.prepareStatement(insert)) {
                    stmt.setInt(1, userId);
                    stmt.setInt(2, placeId);
                    stmt.setString(3, verificationUrl);
                    stmt.executeUpdate();
                }

                conn.commit();
                response.sendRedirect(redirect + "&claim=success");

            } catch (SQLException e) {
                conn.rollback();
                throw e;
            }

        } catch (SQLException e) {
            throw new ServletException("Unable to submit business claim.", e);
        }
    }
}