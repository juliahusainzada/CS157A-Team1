package studyspotter.places;
public class Place {
	private int placeId;
    private Integer ownerUserId;
    private String name;
    private String category;
    private String address;
    private double latitude;
    private double longitude;
    private Double distanceMiles;
    private double avgStarRating;
    private double avgNoiseLevel;
    private double avgOutletDensity;
    private double avgSeatingAvailability;
    private double avgWifiSpeed;
    private double avgFoodQuality;
    private double avgAmbienceScore;
    
    public Place(
            int placeId,
            Integer ownerUserId,
            String name,
            String category,
            String address,
            double latitude,
            double longitude,
            double avgStarRating,
            double avgNoiseLevel,
            double avgOutletDensity,
            double avgSeatingAvailability,
            double avgWifiSpeed,
            double avgFoodQuality,
            double avgAmbienceScore) {

        this.placeId = placeId;
        this.ownerUserId = ownerUserId;
        this.name = name;
        this.category = category;
        this.address = address;
        this.latitude = latitude;
        this.longitude = longitude;
        this.avgStarRating = avgStarRating;
        this.avgNoiseLevel = avgNoiseLevel;
        this.avgOutletDensity = avgOutletDensity;
        this.avgSeatingAvailability = avgSeatingAvailability;
        this.avgWifiSpeed = avgWifiSpeed;
        this.avgFoodQuality = avgFoodQuality;
        this.avgAmbienceScore = avgAmbienceScore;

    }

    public int getPlaceId() {
        return placeId;
    }

    public Integer getOwnerUserId() {
        return ownerUserId;
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

    public double getLatitude() {
        return latitude;
    }

    public double getLongitude() {
        return longitude;
    }

    public Double getDistanceMiles() {
        return distanceMiles;
    }

    public void setDistanceMiles(double distanceMiles) {
        this.distanceMiles = distanceMiles;
    }

    public double getAvgStarRating() {
        return avgStarRating;
    }

    public double getAvgNoiseLevel() {
        return avgNoiseLevel;
    }

    public double getAvgOutletDensity() {
        return avgOutletDensity;
    }

    public double getAvgSeatingAvailability() {
        return avgSeatingAvailability;
    }

    public double getAvgWifiSpeed() {
        return avgWifiSpeed;
    }

    public double getAvgFoodQuality() {
        return avgFoodQuality;
    }

    public double getAvgAmbienceScore() {
        return avgAmbienceScore;
    }

}