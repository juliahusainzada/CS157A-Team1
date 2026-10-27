package studyspotter.places;

public class MenuItem {
    private String name;
    private java.math.BigDecimal price;
    private String description;
    private String dietaryFlags;

    public MenuItem(
            String name,
            java.math.BigDecimal price,
            String description,
            String dietaryFlags) {
        this.name = name;
        this.price = price;
        this.description = description;
        this.dietaryFlags = dietaryFlags;
    }

    public String getName() {
        return name;
    }

    public java.math.BigDecimal getPrice() {
        return price;
    }

    public String getDescription() {
        return description;
    }

    public String getDietaryFlags() {
        return dietaryFlags;
    }
}
