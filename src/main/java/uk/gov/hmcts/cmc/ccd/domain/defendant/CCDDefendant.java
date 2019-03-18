package uk.gov.hmcts.cmc.ccd.domain.defendant;

import lombok.Builder;
import lombok.Value;

import uk.gov.hmcts.cmc.ccd.domain.CCDAddress;
import uk.gov.hmcts.cmc.ccd.domain.CCDPartyType;

import java.time.LocalDate;

@Value
@Builder
public class CCDDefendant {
    private String letterHolderId;
    private String defendantId;
    private LocalDate responseDeadline;

    private CCDPartyType claimantProvidedType;
    private String claimantProvidedEmail;
    private CCDAddress claimantProvidedServiceAddress;
    private String claimantProvidedName;
    private CCDAddress claimantProvidedAddress;
    private CCDAddress claimantProvidedCorrespondenceAddress;
    private LocalDate claimantProvidedDateOfBirth;
    private String claimantProvidedContactPerson;
    private String claimantProvidedCompaniesHouseNumber;
    private String claimantProvidedTitle;
    private String claimantProvidedBusinessName;

    private String claimantProvidedRepresentativeOrganisationName;
    private CCDAddress claimantProvidedRepresentativeOrganisationAddress;
    private String claimantProvidedRepresentativeOrganisationPhone;
    private String claimantProvidedRepresentativeOrganisationEmail;
    private String claimantProvidedRepresentativeOrganisationDxAddress;

    private String representativeOrganisationName;
    private CCDAddress representativeOrganisationAddress;
    private String representativeOrganisationPhone;
    private String representativeOrganisationEmail;
    private String representativeOrganisationDxAddress;

    private CCDPartyType partyType;
    private String partyTitle;
    private String partyName;
    private LocalDate partyDateOfBirth;
    private String partyPhone;
    private String partyEmail;
    private CCDAddress partyAddress;
    private CCDAddress partyCorrespondenceAddress;
    private String partyBusinessName;
    private String partyContactPerson;
    private String partyCompaniesHouseNumber;

}
