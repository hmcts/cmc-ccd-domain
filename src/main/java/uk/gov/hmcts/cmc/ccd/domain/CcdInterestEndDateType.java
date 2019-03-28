package uk.gov.hmcts.cmc.ccd.domain;

public enum CcdInterestEndDateType {
    SETTLED_OR_JUDGMENT("settled_or_judgment"),
    SUBMISSION("submission");

    private String value;

    CcdInterestEndDateType(String value) {
        this.value = value;
    }

    public String getValue() {
        return value;
    }
}
