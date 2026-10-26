package studyspotter;


import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

public class UserDAO {

    public User findByEmail(String email) throws SQLException { //SQL
        String sql = """
            SELECT u.user_id, u.email, u.password_hash, u.status,
            CASE
                WHEN s.user_id IS NOT NULL THEN 'STUDENT'
                WHEN o.user_id IS NOT NULL THEN 'OWNER'
                WHEN a.user_id IS NOT NULL THEN 'ADMIN'
                ELSE 'UNKNOWN'
            END AS role
            FROM Users u
            LEFT JOIN Student s
                ON u.user_id = s.user_id
            LEFT JOIN Owner o 
                ON u.user_id = o.user_id
            LEFT JOIN Admin a
                ON u.user_id = a.user_id
            WHERE u.email = ?
            """; //prevent SQL injection!!

        try (
        		
            Connection connection = DatabaseConnection.getConnection();
            PreparedStatement statement =
                    connection.prepareStatement(sql)
        ) {
            statement.setString(1, email);

            try (ResultSet result = statement.executeQuery()) {
                if (result.next()) {
                    return new User(
                            result.getInt("user_id"),
                            result.getString("email"),
                            result.getString("password_hash"),
                            result.getString("status"),
                            result.getString("role")
                    );
                }
            } //throw exception if failed
        }

        return null;
    }
}