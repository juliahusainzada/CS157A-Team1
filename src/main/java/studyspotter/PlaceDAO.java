package studyspotter;
import java.sql.Connection;
import java.sql.Statement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class PlaceDAO {
	public List<Place> getFilteredPlaces(String noise, String outlets, String wifi) {
		List<Place> places = new ArrayList<>();
		
		String sql = "SELECT * FROM Places";
		String conditions = "";
		
		// Add noise filter
		if (noise != null && !noise.isEmpty()) {
		    if (noise.equals("Quiet")) {
		        conditions += "avg_noise_level <= 2";
		    } else if (noise.equals("Moderate")) {
		        conditions += "avg_noise_level > 2 AND avg_noise_level <= 3";
		    } else if (noise.equals("Loud")) {
		        conditions += "avg_noise_level > 3";
		    }
		}

		// Add outlets filter
		if (outlets != null && !outlets.isEmpty()) {
		    String outletCondition = "";
		    if (outlets.equals("Some")) {
		        outletCondition = "avg_outlet_density BETWEEN 1 AND 3";
		    } else if (outlets.equals("Plenty")) {
		        outletCondition = "avg_outlet_density >= 4";
		    }

		    if (!outletCondition.isEmpty()) {
		        if (!conditions.isEmpty()) {
		            conditions += " AND ";
		        }

		        conditions += outletCondition;
		    }
		}

		// Add Wi-Fi filter
		if (wifi != null && !wifi.isEmpty()) {
		    String wifiCondition = "";
		    if (wifi.equals("Basic")) {
		        wifiCondition = "avg_wifi_speed BETWEEN 1 AND 3";
		    } else if (wifi.equals("Strong")) {
		        wifiCondition = "avg_wifi_speed >= 4";
		    }

		    if (!wifiCondition.isEmpty()) {
		        if (!conditions.isEmpty()) {
		            conditions += " AND ";
		        }
		        
		        conditions += wifiCondition;
		    }
		}
		
		// If at least one filter exists, we add WHERE + conditions to filter DB
		if (!conditions.isEmpty()) {
			sql += " WHERE " + conditions;
		}
		
		sql += " ORDER BY avg_star_rating DESC";
		
		try (
			Connection connection = DatabaseConnection.getConnection();
			Statement statement = connection.createStatement();
			ResultSet rs = statement.executeQuery(sql);
		) {
			
			while (rs.next()) {
				Place place = new Place(
						rs.getInt("place_id"),
						(Integer) rs.getObject("owner_user_id"),
						rs.getString("name"),
						rs.getString("category"),
						rs.getString("address"),
	                    rs.getDouble("latitude"),
	                    rs.getDouble("longitude"),
	                    rs.getDouble("avg_star_rating"),
	                    rs.getDouble("avg_noise_level"),
	                    rs.getDouble("avg_outlet_density"),
	                    rs.getDouble("avg_seating_availability"),
	                    rs.getDouble("avg_wifi_speed"),
	                    rs.getDouble("avg_food_quality"),
	                    rs.getDouble("avg_ambience_score")
                );
				
				places.add(place);
			}
		} catch (SQLException e) {
			e.printStackTrace();
		}
		
		return places;
		
	}
	
	
	public List<Place> getAllPlacesByRating() {
		List<Place> places = new ArrayList<>();
		
		String sql = "SELECT * FROM Places ORDER BY avg_star_rating DESC";
		
		try (
			Connection connection = DatabaseConnection.getConnection();
			Statement statement = connection.createStatement();
			ResultSet rs = statement.executeQuery(sql);
		) {
			
			while (rs.next()) {
				Place place = new Place(
						rs.getInt("place_id"),
						(Integer) rs.getObject("owner_user_id"),
						rs.getString("name"),
						rs.getString("category"),
						rs.getString("address"),
	                    rs.getDouble("latitude"),
	                    rs.getDouble("longitude"),
	                    rs.getDouble("avg_star_rating"),
	                    rs.getDouble("avg_noise_level"),
	                    rs.getDouble("avg_outlet_density"),
	                    rs.getDouble("avg_seating_availability"),
	                    rs.getDouble("avg_wifi_speed"),
	                    rs.getDouble("avg_food_quality"),
	                    rs.getDouble("avg_ambience_score")
                );
				
				places.add(place);
			}
		} catch (SQLException e) {
			e.printStackTrace();
		}
		
		return places;
		
	}
}