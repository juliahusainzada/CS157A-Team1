package studyspotter.places;

import java.io.IOException;
import java.sql.SQLException;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/bookmark")
public class BookmarkServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    @Override
    protected void doPost(HttpServletRequest request,
                          HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);

        if (session == null || !(session.getAttribute("userId") instanceof Integer)) {
            response.sendRedirect(request.getContextPath() + "/pages/login.jsp");
            return;
        }

        if (!"STUDENT".equals(session.getAttribute("role"))) {
            response.sendError(403, "Only students can bookmark study spots.");
            return;
        }

        int userId = (Integer) session.getAttribute("userId");
        int placeId;

        try {
            placeId = Integer.parseInt(request.getParameter("placeId"));
            if (placeId <= 0) {
                throw new NumberFormatException();
            }
        } catch (NumberFormatException e) {
            response.sendError(400, "Invalid place ID.");
            return;
        }

        String action = request.getParameter("action");
        if (!"save".equals(action) && !"remove".equals(action)) {
            response.sendError(400, "Invalid bookmark action.");
            return;
        }

        try {
            PlaceDAO placeDAO = new PlaceDAO();
            if (placeDAO.getPlaceById(placeId) == null) {
                response.sendError(404, "This study spot could not be found.");
                return;
            }

            if ("save".equals(action)) {
                placeDAO.saveBookmark(userId, placeId);
            } else {
                placeDAO.removeBookmark(userId, placeId);
            }

            response.sendRedirect(
                request.getContextPath() + "/pages/places/place-details.jsp?placeId=" + placeId
            );
        } catch (SQLException e) {
            throw new ServletException("Unable to update bookmark.", e);
        }
    }
}
