package studyspotter;

import java.io.IOException;
import java.util.Arrays;
import java.util.Set;
import java.util.HashSet;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/add-place")
public class AddPlaceServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    @Override
    protected void doPost(
            HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");

        // Step 1: Check whether the user is logged in
        HttpSession session = request.getSession(false);

        if (session == null || session.getAttribute("email") == null) {
            response.sendRedirect(
                request.getContextPath() + "/pages/login.jsp"
            );
            return;
        }

        // Step 2: Retrieve form inputs
        String name = request.getParameter("name");
        String category = request.getParameter("category");
        String address = request.getParameter("address");
        String latitudeInput = request.getParameter("latitude");
        String longitudeInput = request.getParameter("longitude");

        String[] amenities = request.getParameterValues("amenities");

        // Step 3: Validate required fields
        if (name == null || name.trim().isEmpty()
                || category == null || category.trim().isEmpty()
                || address == null || address.trim().isEmpty()) {

            response.sendError(
                HttpServletResponse.SC_BAD_REQUEST,
                "Please complete all required fields."
            );
            return;
        }

        name = name.trim();
        address = address.trim();

        if (name.length() > 255 || address.length() > 255) {
            response.sendError(
                HttpServletResponse.SC_BAD_REQUEST,
                "Name or address is too long."
            );
            return;
        }

        // Step 4: Validate category
        Set<String> validCategories = new HashSet<>(
            Arrays.asList("Cafe", "Library", "Park", "Classroom")
        );

        if (!validCategories.contains(category)) {
            response.sendError(
                HttpServletResponse.SC_BAD_REQUEST,
                "Invalid category."
            );
            return;
        }

        // Step 5: Validate coordinates
        double latitude;
        double longitude;

        try {
            latitude = Double.parseDouble(latitudeInput);
            longitude = Double.parseDouble(longitudeInput);

            if (!Double.isFinite(latitude)
                    || !Double.isFinite(longitude)
                    || latitude < -90 || latitude > 90
                    || longitude < -180 || longitude > 180) {

                throw new NumberFormatException();
            }

        } catch (NumberFormatException | NullPointerException e) {

            response.sendError(
                HttpServletResponse.SC_BAD_REQUEST,
                "Please select a valid location on the map."
            );
            return;
        }

        // Step 6: Validate selected amenity IDs
        Set<Integer> amenityIds = new HashSet<>();

        if (amenities != null) {
            try {
                for (String amenity : amenities) {
                    int id = Integer.parseInt(amenity);

                    if (id <= 0) {
                        throw new NumberFormatException();
                    }

                    amenityIds.add(id);
                }

            } catch (NumberFormatException e) {
                response.sendError(
                    HttpServletResponse.SC_BAD_REQUEST,
                    "Invalid amenity selection."
                );
                return;
            }
        }

        // Step 7: Temporary output for testing
        System.out.println("=== NEW STUDY SPOT ===");
        System.out.println("Name: " + name);
        System.out.println("Category: " + category);
        System.out.println("Address: " + address);
        System.out.println("Latitude: " + latitude);
        System.out.println("Longitude: " + longitude);
        System.out.println("Amenities: " + amenityIds);

        // Database insertion will be implemented next.
        response.setContentType("text/plain;charset=UTF-8");

        response.getWriter().println(
            "Form received successfully! "
            + "Database insertion is not implemented yet."
        );
    }
}