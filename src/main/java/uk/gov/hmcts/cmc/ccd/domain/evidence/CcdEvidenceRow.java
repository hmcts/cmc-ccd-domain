package uk.gov.hmcts.cmc.ccd.domain.evidence;

import lombok.Data;

@Data
public class CcdEvidenceRow {
    private CcdEvidenceType type;
    private String description;
}
