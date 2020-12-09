package uk.gov.hmcts.cmc.ccd.domain;

public enum CcdDirectionOrderType {
    STANDARD("standard directions order"),
    BESPOKE("bespoke order");

    private String value;

    CcdDirectionOrderType(String value) {
        this.value = value;
    }

    public String getValue() {
        return value;
    }
}
