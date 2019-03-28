package uk.gov.hmcts.cmc.ccd.domain;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.math.BigDecimal;

@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class CcdAmountRow {
    private String reason;
    private BigDecimal amount;
}
