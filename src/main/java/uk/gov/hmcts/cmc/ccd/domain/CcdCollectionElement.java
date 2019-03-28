package uk.gov.hmcts.cmc.ccd.domain;

import lombok.Data;

@Data
public class CcdCollectionElement<T> {
    private String id;
    private T value;
}
