package uk.gov.hmcts.cmc.ccd.domain;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.LocalDate;

@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class CcdClaimant {
    private CcdPartyType partyType;
    private String partyEmail;
    private String partyName;
    private String partyPhone;
    private CcdAddress partyAddress;
    private CcdAddress partyCorrespondenceAddress;
    private LocalDate partyDateOfBirth;
    private String partyContactPerson;
    private String partyCompaniesHouseNumber;
    private String partyTitle;
    private String partyBusinessName;
    private String representativeOrganisationName;
    private CcdAddress representativeOrganisationAddress;
    private String representativeOrganisationPhone;
    private String representativeOrganisationEmail;
    private String representativeOrganisationDxAddress;

}
