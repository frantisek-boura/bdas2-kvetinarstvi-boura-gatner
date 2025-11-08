package kvetinarstvi.backend.repository.enums;

public enum DeleteStatus {

    SUCCESS(1),
    NOT_FOUND(0),
    FAILURE(-1);

    private final int status;

    DeleteStatus(int status) {
        this.status = status;
    }

    public int getStatus() {
        return status;
    }

    public static DeleteStatus fromCode(int code) {
        for (DeleteStatus deleteStatus : values()) {
            if (deleteStatus.status == code) {
                return deleteStatus;
            }
        }

        return FAILURE;
    }}
