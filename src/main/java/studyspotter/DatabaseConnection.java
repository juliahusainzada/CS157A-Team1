package studyspotter;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class DatabaseConnection {
	
    private static final String URL =
        "jdbc:mysql://localhost:3307/studyspotter?autoReconnect=true&useSSL=false";
    
    private static final String USER = "root";
    
    private static final String PASSWORD = "password"; //DO NOT COMMIT ACTUAL PASSWORD
    
    public static Connection getConnection() throws SQLException {
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
        } catch (ClassNotFoundException e) {
            throw new SQLException("MySQL JDBC driver not found.", e);
        }
        return DriverManager.getConnection(URL, USER, PASSWORD);
    }
}