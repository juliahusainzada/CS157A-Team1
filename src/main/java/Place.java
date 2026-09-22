public class Place {
	private int placeId;
	private String name;
    private String category;
    private String address;
    private String city;
    private String state;
    private String zipCode;
    private double overallRating;
    private String noiseLevel;
    private String outletLevel;
    private String wifiLevel;
    private String imageUrl;
    
    public Place(int placeId, 
    		String name, 
    		String category,
    		String address, 
    		String city, 
    		String state, 
    		String zipCode,
            double overallRating, 
            String noiseLevel,
            String outletLevel, 
            String wifiLevel, 
            String imageUrl) 
    {
    	
    	this.placeId = placeId;
        this.name = name;
        this.category = category;
        this.address = address;
        this.city = city;
        this.state = state;
        this.zipCode = zipCode;
        this.overallRating = overallRating;
        this.noiseLevel = noiseLevel;
        this.outletLevel = outletLevel;
        this.wifiLevel = wifiLevel;
        this.imageUrl = imageUrl;
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

    public String getCity() {
        return city;
    }

    public String getState() {
        return state;
    }

    public String getZipCode() {
        return zipCode;
    }

    public double getOverallRating() {
        return overallRating;
    }

    public String getNoiseLevel() {
        return noiseLevel;
    }

    public String getOutletLevel() {
        return outletLevel;
    }

    public String getWifiLevel() {
        return wifiLevel;
    }

    public String getImageUrl() {
        return imageUrl;
    }
}
