package studyspotter.places;

public class Review {
    private int rating;
    private int noiseLevel;
    private int outletCount;
    private int seating;
    private int wifiSpeed;
    private int foodQuality;
    private int ambiance;
    private String reviewText;
    private java.time.LocalDateTime createdAt;

    public Review(
            int rating,
            int noiseLevel,
            int outletCount,
            int seating,
            int wifiSpeed,
            int foodQuality,
            int ambiance,
            String reviewText,
            java.time.LocalDateTime createdAt) {
        this.rating = rating;
        this.noiseLevel = noiseLevel;
        this.outletCount = outletCount;
        this.seating = seating;
        this.wifiSpeed = wifiSpeed;
        this.foodQuality = foodQuality;
        this.ambiance = ambiance;
        this.reviewText = reviewText;
        this.createdAt = createdAt;
    }

    public int getRating() {
        return rating;
    }

    public int getNoiseLevel() {
        return noiseLevel;
    }

    public int getOutletCount() {
        return outletCount;
    }

    public int getSeating() {
        return seating;
    }

    public int getWifiSpeed() {
        return wifiSpeed;
    }

    public int getFoodQuality() {
        return foodQuality;
    }

    public int getAmbiance() {
        return ambiance;
    }

    public String getReviewText() {
        return reviewText;
    }

    public java.time.LocalDateTime getCreatedAt() {
        return createdAt;
    }
}
