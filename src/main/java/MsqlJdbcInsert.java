import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.Statement;

public class MsqlJdbcInsert {

	public static void main(String[] args) throws Exception {


        Connection connection = DriverManager.getConnection("jdbc:mysql://DB_HOST:DB_PORT/DB_NAME?serverTimezone=UTC", "DB_USER", "DB_PASSWORD");
		
		// Insert row
		java.util.Date now = new java.util.Date();
		java.sql.Date sqlDate = new java.sql.Date(now.getTime());
		String insertSql = "INSERT INTO USER (idusers, email, timestamp) "
				          + "VALUES ('0002', test2@email.com' " + sqlDate + "')";
		Statement statement = connection.createStatement();
		statement.execute(insertSql);
		
		// Query 
		
		String querySql = "SELECT * FROM USER";
		Statement st=connection.createStatement();
		ResultSet rs=st.executeQuery(querySql);
		while(rs.next())
		{
		    // rs.getString(1); //or rs.getString("column name");
			int idusers = rs.getInt("idusers");
            String email = rs.getString("email");
            String Date = rs.getString("timestamp");

            System.out.println(idusers);
            System.out.println(email);
            System.out.println(Date);
		}
		
		// Close connection
		statement.close();
		rs.close();
		connection.close();
		

	}

}
