package studyspotter.places;
import java.sql.Timestamp;


public class Report {
    private int reportId;
    private String reason;
    private String status;
    private String reporterEmail;
    private String placeName;
    private String reviewText;
    private String targetUserEmail;
    private Timestamp createdAt;

    public Report(int reportId,
                   String reason,
                  String status,
                  String reporterEmail,
                  String placeName,
                  String reviewText,
                  String targetUserEmail,
                  Timestamp createdAt) {

        this.reportId = reportId;
        this.reason = reason;
        this.status = status;
        this.reporterEmail = reporterEmail;
        this.placeName = placeName;
        this.reviewText = reviewText;
        this.targetUserEmail = targetUserEmail;
        this.createdAt = createdAt;
    }

    public int getReportId() {
        return reportId;
    }

    public String getReason() {
        return reason;
    }

    public String getStatus() {
        return status;
    }

    public String getReporterEmail() {
        return reporterEmail;
    }

    public String getPlaceName() {
        return placeName;
    }

    public String getReviewText() {
        return reviewText;
    }

    public String getTargetUserEmail() {
        return targetUserEmail;
    }

    public Timestamp getCreatedAt() {
        return createdAt;
    }
}