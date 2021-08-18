package uk.gov.hmcts.cmc.ccd.domain.defendant;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import uk.gov.hmcts.cmc.ccd.domain.CcdAddress;
import uk.gov.hmcts.cmc.ccd.domain.CcdPartyType;

import java.time.LocalDate;

@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class CcdDefendant {
    private String letterHolderId;
    private String defendantId;
    private LocalDate responseDeadline;

    private CcdPartyType claimantProvidedType;
    private String claimantProvidedEmail;
    private CcdAddress claimantProvidedServiceAddress;
    private String claimantProvidedName;
    private CcdAddress claimantProvidedAddress;
    private CcdAddress claimantProvidedCorrespondenceAddress;
    private LocalDate claimantProvidedDateOfBirth;
    private String claimantProvidedContactPerson;
    private String claimantProvidedCompaniesHouseNumber;
    private String claimantProvidedTitle;
    private String claimantProvidedBusinessName;

    private String claimantProvidedRepresentativeOrganisationName;
    private CcdAddress claimantProvidedRepresentativeOrganisationAddress;
    private String claimantProvidedRepresentativeOrganisationPhone;
    private String claimantProvidedRepresentativeOrganisationEmail;
    private String claimantProvidedRepresentativeOrganisationDxAddress;

    private String representativeOrganisationName;
    private CcdAddress representativeOrganisationAddress;
    private String representativeOrganisationPhone;
    private String representativeOrganisationEmail;
    private String representativeOrganisationDxAddress;

    private CcdPartyType partyType;
    private String partyTitle;
    private String partyName;
    private LocalDate partyDateOfBirth;
    private String partyPhone;
    private String partyEmail;
    private CcdAddress partyAddress;
    private CcdAddress partyCorrespondenceAddress;
    private String partyBusinessName;
    private String partyContactPerson;
    private String partyCompaniesHouseNumber;

}
