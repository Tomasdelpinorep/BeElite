package com.salesianos.triana.BeElite.model.Composite_Ids;

import jakarta.persistence.Column;
import jakarta.persistence.Embedded;

import java.io.Serializable;

public class AthleteSetId implements Serializable {
    @Column(name = "athlete_set_number")
    private Long athlete_set_number;

    @Embedded
    private AthleteBlockId athlete_block_id;
}
