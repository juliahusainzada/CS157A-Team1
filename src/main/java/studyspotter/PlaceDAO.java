package studyspotter;
import java.sql.Connection;
import java.sql.Statement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class PlaceDAO {
	
	public List<Place> getAllPlacesByRating() {
		List<Place> places = new ArrayList<>();
		
		String sql = "SELECT * FROM places ORDER BY overall_rating DESC";
		
		try (
			Connection connection = DatabaseConnection.getConnection();
			Statement statement = connection.createStatement();
			ResultSet rs = statement.executeQuery(sql);
		) {
			
			while (rs.next()) {
				Place place = new Place(
					rs.getInt("place_id"),
					rs.getString("name"),
					rs.getString("category"),
					rs.getString("address"),
                    rs.getString("city"),
                    rs.getString("state"),
                    rs.getString("zip_code"),
                    rs.getDouble("overall_rating"),
                    rs.getString("noise_level"),
                    rs.getString("outlet_level"),
                    rs.getString("wifi_level"),
                    rs.getString("image_url")
                );
				
				places.add(place);
			}
		} catch (SQLException e) {
			e.printStackTrace();
		}
		
		return places;
		
	}
}