package uk.gov.hmcts.cmc.ccd.domain.defendant;

public enum CcdDefenceType {
    DISPUTE("dispute"),
    ALREADY_PAID("already paid");

    private String value;

    CcdDefenceType(String value) {
        this.value = value;
    }

    public String getValue() {
        return value;
    }
}
