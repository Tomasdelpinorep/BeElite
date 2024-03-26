package com.salesianos.triana.BeElite.model.Composite_Ids;

import jakarta.persistence.Column;
import jakarta.persistence.Embedded;
import jakarta.persistence.EmbeddedId;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.RequiredArgsConstructor;

import java.io.Serializable;
import java.util.UUID;

@Getter
@AllArgsConstructor
@RequiredArgsConstructor
public class AthleteSessionId implements Serializable {
    @Column(name = "athlete_session_number")
    private Long athlete_session_number;

    @Embedded
    @Column(name = "athlete_id")
    private UUID athlete_id;

    public static AthleteSessionId of(Long athlete_session_number, UUID athlete_id){
        return new AthleteSessionId(athlete_session_number, athlete_id);
    }
}
