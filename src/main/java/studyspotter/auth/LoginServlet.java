package studyspotter.auth;
import java.io.IOException;
import java.sql.SQLException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;


@WebServlet("/login")
public class LoginServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

        String email = request.getParameter("email");
        String password = request.getParameter("password");

        if (email == null || email.isBlank()
                || password == null || password.isBlank()) {

            response.sendRedirect(
                    request.getContextPath()
                    + "/pages/login.jsp?error=missing"
            );
            return;
        }

        try {
            UserDAO userDAO = new UserDAO();
            User user = userDAO.findByEmail(email);

            if (user == null || !PasswordUtil.verifyPassword( password, user.getPasswordHash())) {
                response.sendRedirect( request.getContextPath() + "/pages/login.jsp?error=invalid");
                return;
            }

            if (!"Active".equals(user.getStatus())) {
                response.sendRedirect(request.getContextPath() + "/pages/login.jsp?error=inactive");
                return;
            }

            /*
             * this is where the session is created
             */
            HttpSession session = request.getSession();

            // helps prevent session fixation
            request.changeSessionId();

            session.setAttribute("userId", user.getUserId());
            session.setAttribute("email", user.getEmail());
            session.setAttribute("role", user.getRole());

            
             // redirect based on the role ..
            if ("STUDENT".equals(user.getRole())) {
                response.sendRedirect(request.getContextPath() + "/index.jsp");

            } else if ("OWNER".equals(user.getRole())) {
                response.sendRedirect(request.getContextPath() + "/pages/auth/owner-dashboard.jsp");
            } else if ("ADMIN".equals(user.getRole())) {
                response.sendRedirect(request.getContextPath() + "/pages/auth/admin-dashboard.jsp");
            } else {
                response.sendRedirect(request.getContextPath() + "/pages/login.jsp?error=1");
            }

        } catch (SQLException e) {
            throw new ServletException("Login database error.", e);
        }
    }
}