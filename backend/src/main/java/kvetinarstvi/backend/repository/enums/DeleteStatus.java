package kvetinarstvi.backend.repository.enums;

public enum DELETE_RESULT {

    SUCCESS(1),
    NOT_FOUND(0),
    FAILURE(-1);

    private final int status;

    DELETE_RESULT(int status) {
        this.status = status;
    }

    public int getStatus() {
        return status;
    }

    // Static method to retrieve enum by custom code (recommended way to "lookup")
    public static Status fromCode(int code) {
        for (Status status : values()) {
            if (status.code == code) {
                return status;
            }
        }
        // Or throw IllegalArgumentException if code is not found
        return null;
    }}
