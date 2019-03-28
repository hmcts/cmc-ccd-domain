package uk.gov.hmcts.cmc.ccd.domain;

import lombok.Data;

import java.math.BigDecimal;

@Data
public class CcdAmountRow {
    private String reason;
    private BigDecimal amount;
}
