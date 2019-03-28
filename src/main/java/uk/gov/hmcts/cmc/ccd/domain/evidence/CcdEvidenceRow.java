package uk.gov.hmcts.cmc.ccd.domain.evidence;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class CcdEvidenceRow {
    private CcdEvidenceType type;
    private String description;
}
