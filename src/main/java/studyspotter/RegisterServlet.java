package studyspotter;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/register")
public class RegisterServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String email = request.getParameter("email");
        String password = request.getParameter("password");
        String accountType = request.getParameter("accountType");

        String studentId = request.getParameter("studentId");
        String institution = request.getParameter("institution");
        String businessName = request.getParameter("businessName");

        if (email == null || password == null
                || accountType == null
                || email.isBlank()
                || password.isBlank()) {

            response.sendRedirect(
                    request.getContextPath()
                    + "/pages/register.jsp?error=missing"
            );
            return;
        }

        if ("STUDENT".equals(accountType)
                && !email.toLowerCase().endsWith(".edu")) {

            response.sendRedirect(
                    request.getContextPath()
                    + "/pages/register.jsp?error=student_email"
            );
            return;
        }

        if ("STUDENT".equals(accountType)
                && (institution == null || institution.isBlank())) {

            response.sendRedirect(
                    request.getContextPath()
                    + "/pages/register.jsp?error=institution"
            );
            return;
        }

        if ("OWNER".equals(accountType)
                && (businessName == null || businessName.isBlank())) {

            response.sendRedirect(
                    request.getContextPath()
                    + "/pages/register.jsp?error=business"
            );
            return;
        }

        String passwordHash = PasswordUtil.hashPassword(password);

        String insertUser = """
            INSERT INTO Users
                (email, password_hash, status, is_verified)
            VALUES (?, ?, 'Active', FALSE)
            """;

        try (Connection connection =
                     DatabaseConnection.getConnection()) {

            connection.setAutoCommit(false);

            try {
                int userId;

                try (PreparedStatement statement =
                             connection.prepareStatement(
                                     insertUser,
                                     Statement.RETURN_GENERATED_KEYS
                             )) {

                    statement.setString(1, email);
                    statement.setString(2, passwordHash);
                    statement.executeUpdate();

                    try (ResultSet keys =
                                 statement.getGeneratedKeys()) {

                        if (!keys.next()) {
                            throw new SQLException(
                                    "Could not create user ID."
                            );
                        }

                        userId = keys.getInt(1);
                    }
                }

                if ("STUDENT".equals(accountType)) {
                    String insertStudent = """
                        INSERT INTO Student
                            (user_id, student_id, institution)
                        VALUES (?, ?, ?)
                        """;

                    try (PreparedStatement statement =
                                 connection.prepareStatement(
                                         insertStudent
                                 )) {
                        statement.setInt(1, userId);
                        statement.setString(2, studentId);
                        statement.setString(3, institution);
                        statement.executeUpdate();
                    }

                } else if ("OWNER".equals(accountType)) {
                    String insertOwner = """
                        INSERT INTO Owner
                            (user_id, certification, business_name)
                        VALUES (?, NULL, ?)
                        """;

                    try (PreparedStatement statement =
                                 connection.prepareStatement(
                                         insertOwner
                                 )) {
                        statement.setInt(1, userId);
                        statement.setString(2, businessName);
                        statement.executeUpdate();
                    }

                } else {
                    connection.rollback();

                    response.sendRedirect(
                            request.getContextPath()
                            + "/pages/register.jsp?error=role"
                    );
                    return;
                }

                connection.commit();

                response.sendRedirect(
                        request.getContextPath()
                        + "/pages/login.jsp?registered=1"
                );

            } catch (Exception e) {
                connection.rollback();
                throw e;
            }

        } catch (SQLException e) {
            if (e.getMessage() != null
                    && e.getMessage().contains("Duplicate")) {

                response.sendRedirect(
                        request.getContextPath()
                        + "/pages/register.jsp?error=duplicate"
                );
            } else {
                throw new ServletException(
                        "Registration database error.",
                        e
                );
            }
        }
    }
}