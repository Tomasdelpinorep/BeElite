package com.salesianos.triana.BeElite.model.Composite_Ids;

import jakarta.persistence.Column;
import jakarta.persistence.Embedded;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.RequiredArgsConstructor;

import java.io.Serializable;
import java.util.UUID;

@Getter
@AllArgsConstructor
@RequiredArgsConstructor
public class AthleteBlockId implements Serializable {

    @Column(name = "athlete_block_number")
    private Long athlete_block_number;

    @Embedded
    private AthleteSessionId athlete_session_id;

    public static AthleteBlockId of(Long athlete_block_number, AthleteSessionId athlete_session_id){
        return new AthleteBlockId(athlete_block_number, athlete_session_id);
    }
}
