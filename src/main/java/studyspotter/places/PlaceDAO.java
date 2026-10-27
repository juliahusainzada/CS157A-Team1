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

public class PlaceDAO {
    // Load one venue for its dedicated details page.
    public Place getPlaceById(int placeId) throws SQLException {
        String sql = "SELECT * FROM Places WHERE place_id = ?";

        try (Connection connection = DatabaseConnection.getConnection();
             PreparedStatement statement = connection.prepareStatement(sql)) {

            statement.setInt(1, placeId);

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

    public boolean isBookmarked(int userId, int placeId) throws SQLException {
        String sql = "SELECT 1 FROM SavedPlaces WHERE user_id = ? AND place_id = ?";

        try (Connection connection = DatabaseConnection.getConnection();
             PreparedStatement statement = connection.prepareStatement(sql)) {
            statement.setInt(1, userId);
            statement.setInt(2, placeId);

            try (ResultSet rs = statement.executeQuery()) {
                return rs.next();
            }
        }
    }

    public void saveBookmark(int userId, int placeId) throws SQLException {
        // Repeated saves leave the existing bookmark and its timestamp unchanged.
        String sql = """
            INSERT INTO SavedPlaces (user_id, place_id)
            VALUES (?, ?)
            ON DUPLICATE KEY UPDATE saved_at = saved_at
            """;

        try (Connection connection = DatabaseConnection.getConnection();
             PreparedStatement statement = connection.prepareStatement(sql)) {
            statement.setInt(1, userId);
            statement.setInt(2, placeId);
            statement.executeUpdate();
        }
    }

    public void removeBookmark(int userId, int placeId) throws SQLException {
        String sql = "DELETE FROM SavedPlaces WHERE user_id = ? AND place_id = ?";

        try (Connection connection = DatabaseConnection.getConnection();
             PreparedStatement statement = connection.prepareStatement(sql)) {
            statement.setInt(1, userId);
            statement.setInt(2, placeId);
            statement.executeUpdate();
        }
    }

    public List<MenuItem> getMenuItems(int placeId) throws SQLException {
        List<MenuItem> menuItems = new ArrayList<>();
        String sql = """
            SELECT name, price, description, dietary_flags
            FROM MenuItems
            WHERE place_id = ?
            ORDER BY name, menu_item_id
            """;

        try (Connection connection = DatabaseConnection.getConnection();
             PreparedStatement statement = connection.prepareStatement(sql)) {
            statement.setInt(1, placeId);

            try (ResultSet rs = statement.executeQuery()) {
                while (rs.next()) {
                    menuItems.add(new MenuItem(
                        rs.getString("name"),
                        rs.getBigDecimal("price"),
                        rs.getString("description"),
                        rs.getString("dietary_flags")
                    ));
                }
            }
        }

        return menuItems;
    }

    public List<Review> getReviews(int placeId) throws SQLException {
        List<Review> reviews = new ArrayList<>();
        String sql = """
            SELECT rating, noise_level, outlet_count, seating, wifi_speed,
                   food_quality, ambiance, review_text, created_at
            FROM Reviews
            WHERE place_id = ?
            ORDER BY created_at DESC, review_id DESC
            """;

        try (Connection connection = DatabaseConnection.getConnection();
             PreparedStatement statement = connection.prepareStatement(sql)) {
            statement.setInt(1, placeId);

            try (ResultSet rs = statement.executeQuery()) {
                while (rs.next()) {
                    reviews.add(new Review(
                        rs.getInt("rating"),
                        rs.getInt("noise_level"),
                        rs.getInt("outlet_count"),
                        rs.getInt("seating"),
                        rs.getInt("wifi_speed"),
                        rs.getInt("food_quality"),
                        rs.getInt("ambiance"),
                        rs.getString("review_text"),
                        rs.getTimestamp("created_at").toLocalDateTime()
                    ));
                }
            }
        }

        return reviews;
    }

    public List<String> getAmenities(int placeId) throws SQLException {
        List<String> amenities = new ArrayList<>();
        String sql = """
            SELECT a.name
            FROM PlaceAmenities pa
            JOIN Amenities a ON a.amenity_id = pa.amenities_id
            WHERE pa.place_id = ?
            ORDER BY a.name
            """;

        try (Connection connection = DatabaseConnection.getConnection();
             PreparedStatement statement = connection.prepareStatement(sql)) {
            statement.setInt(1, placeId);

            try (ResultSet rs = statement.executeQuery()) {
                while (rs.next()) {
                    amenities.add(rs.getString("name"));
                }
            }
        }

        return amenities;
    }

    public List<Place> getFilteredPlaces(
            double latitude,
            double longitude,
            int radiusMiles,
            String noise,
            String outlets,
            String wifi,
            Integer minimumSeating,
            String dietary,
            String vibe,
            String sort) throws SQLException {

        List<Place> places = new ArrayList<>();
        List<Object> parameters = new ArrayList<>();

        // POINT uses longitude first; convert meters to miles for the UI
        StringBuilder sql = new StringBuilder("""
            SELECT p.*
            FROM (
                SELECT Places.*,
                    ST_Distance_Sphere(
                        POINT(longitude, latitude), POINT(?, ?)
                    ) / 1609.344 AS distance_miles
                FROM Places
            ) p
            WHERE p.distance_miles <= ?
            """);

        parameters.add(longitude);
        parameters.add(latitude);
        parameters.add(radiusMiles);

        // Apply the existing workability score ranges
        if ("Quiet".equals(noise)) {
            sql.append(" AND p.avg_noise_level BETWEEN 1 AND 2");
        } else if ("Moderate".equals(noise)) {
            sql.append(" AND p.avg_noise_level > 2 AND p.avg_noise_level <= 3");
        } else if ("Loud".equals(noise)) {
            sql.append(" AND p.avg_noise_level > 3");
        }

        if ("Some".equals(outlets)) {
            sql.append(" AND p.avg_outlet_density BETWEEN 1 AND 3");
        } else if ("Plenty".equals(outlets)) {
            sql.append(" AND p.avg_outlet_density >= 4");
        }

        if ("Basic".equals(wifi)) {
            sql.append(" AND p.avg_wifi_speed BETWEEN 1 AND 3");
        } else if ("Strong".equals(wifi)) {
            sql.append(" AND p.avg_wifi_speed >= 4");
        }

        if (minimumSeating != null) {
            sql.append(" AND p.avg_seating_availability >= ?");
            parameters.add(minimumSeating);
        }

        // EXISTS returns each venue once, even when several menu items match
        // Dietary flags are comma-separated labels, matching the existing schema
        if (dietary != null && !dietary.isEmpty()) {
            sql.append("""
                 AND EXISTS (
                    SELECT 1 FROM MenuItems m
                    WHERE m.place_id = p.place_id
                      AND FIND_IN_SET(?, REPLACE(m.dietary_flags, ', ', ',')) > 0
                )
                """);
            parameters.add(dietary);
        }

        // Check amenity names since that what 'vibe' relies on
        if (vibe != null && !vibe.isEmpty()) {
            sql.append("""
                 AND EXISTS (
                    SELECT 1 FROM PlaceAmenities pa
                    JOIN Amenities a ON a.amenity_id = pa.amenities_id
                    WHERE pa.place_id = p.place_id AND a.name = ?
                )
                """);
            parameters.add(vibe);
        }

        if ("distance".equals(sort)) {
            sql.append(" ORDER BY p.distance_miles ASC, p.avg_star_rating DESC, p.place_id ASC");
        } else {
            sql.append(" ORDER BY p.avg_star_rating DESC, p.distance_miles ASC, p.place_id ASC");
        }

        try (Connection connection = DatabaseConnection.getConnection();
             PreparedStatement statement = connection.prepareStatement(sql.toString())) {

            for (int i = 0; i < parameters.size(); i++) {
                statement.setObject(i + 1, parameters.get(i));
            }

            try (ResultSet rs = statement.executeQuery()) {
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
                    place.setDistanceMiles(rs.getDouble("distance_miles"));
                    places.add(place);
                }
            }
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