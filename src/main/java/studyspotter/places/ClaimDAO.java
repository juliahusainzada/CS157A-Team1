package studyspotter.places;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.List;
import studyspotter.DatabaseConnection;

public class ClaimDAO {

    public List<PendingClaim> getPendingClaims(int ownerId) throws SQLException {
        List<PendingClaim> claims = new ArrayList<>();

        String sql = """
            SELECT cr.claim_id,
                   p.name AS place_name,
                   p.address,
                   cr.status,
                   cr.verification_document_url,
                   cr.created_at
            FROM ClaimRequests cr
            JOIN Places p ON cr.place_id = p.place_id
            WHERE cr.user_id = ?
              AND cr.status = 'Pending'
            ORDER BY cr.created_at DESC
            """;

        try (
            Connection connection = DatabaseConnection.getConnection();
            PreparedStatement statement = connection.prepareStatement(sql)
        ) {
            statement.setInt(1, ownerId);

            try (ResultSet result = statement.executeQuery()) {
                while (result.next()) {
                    claims.add(new PendingClaim(
                        result.getInt("claim_id"),
                        result.getString("place_name"),
                        result.getString("address"),
                        result.getString("status"),
                        result.getString("verification_document_url"),
                        result.getTimestamp("created_at")
                    ));
                }
            }
        }
        return claims;
    }

    public List<ApprovedBusiness> getApprovedBusinesses(int ownerId) throws SQLException {
        List<ApprovedBusiness> businesses = new ArrayList<>();

        String sql = """
            SELECT place_id,
                   name,
                   category,
                   address,
                   avg_star_rating
            FROM Places
            WHERE owner_user_id = ?
            ORDER BY name
            """;

        try (
            Connection connection = DatabaseConnection.getConnection();
            PreparedStatement statement = connection.prepareStatement(sql)
        ) {
            statement.setInt(1, ownerId);

            try (ResultSet result = statement.executeQuery()) {
                while (result.next()) {
                    businesses.add(new ApprovedBusiness(
                        result.getInt("place_id"),
                        result.getString("name"),
                        result.getString("category"),
                        result.getString("address"),
                        result.getBigDecimal("avg_star_rating")
                    ));
                }
            }
        }
        return businesses;
    }

    public static class PendingClaim {
        private int claimId;
        private String placeName;
        private String address;
        private String status;
        private String verificationUrl;
        private Timestamp createdAt;

        public PendingClaim(int claimId, String placeName,
                            String address, String status,
                            String verificationUrl,
                            Timestamp createdAt) {
            this.claimId = claimId;
            this.placeName = placeName;
            this.address = address;
            this.status = status;
            this.verificationUrl = verificationUrl;
            this.createdAt = createdAt;
        }

        public int getClaimId() {
            return claimId;
        }

        public String getPlaceName() {
            return placeName;
        }

        public String getAddress() {
            return address;
        }

        public String getStatus() {
            return status;
        }

        public String getVerificationUrl() {
            return verificationUrl;
        }

        public Timestamp getCreatedAt() {
            return createdAt;
        }
    }

    public static class ApprovedBusiness {
        private int placeId;
        private String name;
        private String category;
        private String address;
        private java.math.BigDecimal rating;

        public ApprovedBusiness(int placeId, String name,
                                String category, String address,
                                java.math.BigDecimal rating) {
            this.placeId = placeId;
            this.name = name;
            this.category = category;
            this.address = address;
            this.rating = rating;
        }

        public int getPlaceId() {
            return placeId;
        }

        public String getName() {
            return name;
        }

        public String getCategory() {
            return category;
        }

        public String getAddress() {
            return address;
        }

        public java.math.BigDecimal getRating() {
            return rating;
        }
    }
}