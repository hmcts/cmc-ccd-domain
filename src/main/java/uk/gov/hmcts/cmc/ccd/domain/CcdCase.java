package uk.gov.hmcts.cmc.ccd.domain;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import uk.gov.hmcts.cmc.ccd.domain.defendant.CcdDefendant;
import uk.gov.hmcts.cmc.ccd.domain.evidence.CcdEvidenceRow;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.util.List;

@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class CcdCase {

    private String externalId;
    private String reason;

    private AmountType amountType;
    private BigDecimal amountLowerValue;
    private BigDecimal amountHigherValue;
    private List<CcdCollectionElement<CcdAmountRow>> amountBreakDown;
    private BigDecimal totalAmount;
    private CcdNotKnown notKnown;

    private CcdInterestType interestType;
    private BigDecimal interestBreakDownAmount;
    private String interestBreakDownExplanation;
    private BigDecimal interestRate;
    private String interestReason;
    private BigDecimal interestSpecificDailyAmount;
    private CcdInterestDateType interestDateType;
    private LocalDate interestClaimStartDate;
    private String interestStartDateReason;
    private CcdInterestEndDateType interestEndDateType;

    private String paymentId;
    private BigDecimal paymentAmount;
    private String paymentReference;
    private String paymentStatus;
    private LocalDate paymentDateCreated;
    private String feeAccountNumber;

    private String preferredCourt;
    private String personalInjuryGeneralDamages;
    private String housingDisrepairCostOfRepairDamages;
    private String housingDisrepairOtherDamages;
    private String sotSignerName;
    private String sotSignerRole;

    private List<CcdCollectionElement<CcdClaimant>> claimants;
    private List<CcdCollectionElement<CcdDefendant>> defendants;
    private List<CcdCollectionElement<CcdTimelineEvent>> timeline;
    private List<CcdCollectionElement<CcdEvidenceRow>> evidence;
}
