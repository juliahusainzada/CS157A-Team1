package studyspotter;
import java.sql.Connection;
import java.sql.Statement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import java.sql.PreparedStatement;
import java.util.Set;

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
	
	// Check whether a study spot already exists within 50 meters
	public Place findNearbyPlace(double latitude, double longitude)
	        throws SQLException {
		
		// Check for duplicate study spots within 50 meters
		// ST_Distance_Sphere calculates the distance (in meters) between two coordinates
		// POINT uses longitude first, then latitude. The ? placeholders represent
		// the new spot's coordinates, which are provided through PreparedStatement
		// Return the closest matching spot, if one exists
		
	    String sql = """
	        SELECT *,
	            ST_Distance_Sphere(
	                POINT(longitude, latitude),
	                POINT(?, ?)
	            ) AS distance_meters
	        FROM Places
	        WHERE ST_Distance_Sphere(
	            POINT(longitude, latitude),
	            POINT(?, ?)
	        ) <= 50
	        ORDER BY distance_meters ASC
	        LIMIT 1
	        """;

	    try (
	        Connection connection = DatabaseConnection.getConnection();
	        PreparedStatement statement = connection.prepareStatement(sql)
	    ) {

	        // POINT uses longitude first, then latitude
	        statement.setDouble(1, longitude);
	        statement.setDouble(2, latitude);
	        statement.setDouble(3, longitude);
	        statement.setDouble(4, latitude);

	        try (ResultSet rs = statement.executeQuery()) {

	            if (rs.next()) {
	                return new Place(
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
	            }
	        }
	    }

	    return null;
	}
	
	// Insert a new study spot and its selected amenities into the database
	public int addPlace(
			String name,
	        String category,
	        String address,
	        double latitude,
	        double longitude,
	        Set<Integer> amenityIds) throws SQLException {
	    String insertPlace = """
	        INSERT INTO Places
	            (owner_user_id, name, category, address, latitude, longitude)
	        VALUES (NULL, ?, ?, ?, ?, ?)
	        """;

	    String insertAmenity = """
	        INSERT INTO PlaceAmenities (place_id, amenities_id)
	        VALUES (?, ?)
	        """;

	    try (Connection connection = DatabaseConnection.getConnection()) {
	        // Start transaction so both tables update together
	        connection.setAutoCommit(false);
	        try {
	            int placeId;
	            
	         // Check for an existing spot before inserting
	            Place duplicate = findNearbyPlace(latitude, longitude);
	            if (duplicate != null) {
	                throw new SQLException(
	                    "Duplicate spot found: " + duplicate.getName()
	                    + " (ID: " + duplicate.getPlaceId() + ")"
	                );
	            }
	            
	            // Insert new study spot
	            try (PreparedStatement statement =
	                    connection.prepareStatement(
	                        insertPlace,
	                        Statement.RETURN_GENERATED_KEYS)) {

	                statement.setString(1, name);
	                statement.setString(2, category);
	                statement.setString(3, address);
	                statement.setDouble(4, latitude);
	                statement.setDouble(5, longitude);
	                statement.executeUpdate();

	                // Retrieve automatically generated place_id
	                try (ResultSet keys = statement.getGeneratedKeys()) {
	                    if (!keys.next()) {
	                        throw new SQLException("Failed to retrieve place ID.");
	                    }
	                    
	                    placeId = keys.getInt(1);
	                }
	            }

	            // Insert selected amenities
	            try (PreparedStatement statement =
	                    connection.prepareStatement(insertAmenity)) {
	                for (int amenityId : amenityIds) {
	                    statement.setInt(1, placeId);
	                    statement.setInt(2, amenityId);
	                    statement.addBatch();
	                }

	                statement.executeBatch();

	            }

	            // Save both inserts
	            connection.commit();
	            return placeId;

	        } catch (SQLException e) {
	            // Undo changes if either insertion fails
	            connection.rollback();
	            throw e;
	        }
	    }
	}
}