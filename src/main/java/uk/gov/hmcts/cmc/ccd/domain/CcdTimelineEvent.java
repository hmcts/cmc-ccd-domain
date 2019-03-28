package uk.gov.hmcts.cmc.ccd.domain;

import lombok.Data;

@Data
public class CcdTimelineEvent {

    private String date;
    private String description;

}
