package uk.gov.hmcts.cmc.ccd.domain;

public enum CcdInterestDateType {
    CUSTOM("custom"),
    SUBMISSION("submission");

    private String value;

    CcdInterestDateType(String value) {
        this.value = value;
    }

    public String getValue() {
        return value;
    }
}
