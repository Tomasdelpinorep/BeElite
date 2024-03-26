package com.salesianos.triana.BeElite.model;

import com.salesianos.triana.BeElite.model.Composite_Ids.AthleteSetId;
import jakarta.persistence.*;
import lombok.*;

@Entity
@Builder
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
public class AthleteSet {

    @EmbeddedId
    AthleteSetId id;

    // Mapping to original Set entity from the athlete's program
    @ManyToOne
    @JoinColumns({
            @JoinColumn(name = "week_number", referencedColumnName = "week_number"),
            @JoinColumn(name = "week_name", referencedColumnName = "week_name"),
            @JoinColumn(name = "program_id", referencedColumnName = "program_id"),
            @JoinColumn(name = "session_number", referencedColumnName = "session_number"),
            @JoinColumn(name = "block_number", referencedColumnName = "block_number"),
            @JoinColumn(name = "set_number", referencedColumnName = "set_number")
    })
    private Set set;

    @ManyToOne
    @MapsId("athlete_block_id")
    private AthleteBlock athleteBlock;

    // Not a necessary class for what I'm gonna do but it would be if I ever decide to give some sort of ability to customize each block for
    // each athlete, say I want a block for X athlete to have 3 sets fewer and less weight because only that athletes competes next weekend.
}
