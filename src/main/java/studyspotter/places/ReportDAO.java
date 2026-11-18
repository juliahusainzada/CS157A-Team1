package studyspotter.places; 
import java.sql.Connection;
import java.sql.Statement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import java.sql.PreparedStatement;
import java.util.Set;

import studyspotter.DatabaseConnection;

public class ReportDAO { 

	public List<Report> getOpenReports() throws SQLException {
	    List<Report> reports = new ArrayList<>();
	    String sql = """
	        SELECT r.report_id, r.reason,
	               r.status,
	               r.created_at,
	               reporter.email AS reporter_email,
	               p.name AS place_name,
	               review.review_text,
	               target.email AS target_user_email
	        FROM Reports r
	        JOIN Users reporter
	            ON r.reporter_id = reporter.user_id
	        LEFT JOIN Places p
	            ON r.place_id = p.place_id
	        LEFT JOIN Reviews review
	            ON r.review_id = review.review_id
	        LEFT JOIN Users target
	            ON r.target_user_id = target.user_id
	        WHERE r.status IN ('Open', 'Under Review')
	        ORDER BY r.created_at ASC
	        """;
	
	    try (
	        Connection connection = DatabaseConnection.getConnection();
	        PreparedStatement statement = connection.prepareStatement(sql);
	        ResultSet result = statement.executeQuery()
	    ) {
	        while (result.next()) { 
	            reports.add(new Report(
	                result.getInt("report_id"),
	                result.getString("reason"),
	                result.getString("status"),
	                result.getString("reporter_email"),
	                result.getString("place_name"),
	                result.getString("review_text"),
	                result.getString("target_user_email"),
	                result.getTimestamp("created_at")
	            ));
	        }
	    }
	
	    return reports;
	}
}
