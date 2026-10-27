package studyspotter.auth;

public class User { //create new User class and get info from db
    private int userId;
    private String email;
    private String passwordHash;
    private String status;
    private String role;

    public User(int userId, String email, String passwordHash, String status, String role) {
        this.userId = userId;
        this.email = email;
        this.passwordHash = passwordHash;
        this.status = status;
        this.role = role;
    }

    public int getUserId() {
        return userId;
    }
    public String getEmail() {
        return email;
    }

    public String getPasswordHash() {
    	
        return passwordHash;
    }

    public String getStatus() {
        return status;
    }

    
    public String getRole() {
        return role;
    }
}