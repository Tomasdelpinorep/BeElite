package com.salesianos.triana.BeElite.model;

import com.salesianos.triana.BeElite.model.Composite_Ids.AthleteBlockId;
import jakarta.persistence.*;
import lombok.*;

import java.util.ArrayList;
import java.util.List;

@Entity
@Builder
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
public class AthleteBlock {

    @EmbeddedId
    private AthleteBlockId id;

    @ManyToOne
    @MapsId("athlete_session_id")
    @JoinColumns({
            @JoinColumn(name = "athlete_session_number", referencedColumnName = "athlete_session_number"),
            @JoinColumn(name = "athlete_id", referencedColumnName = "athlete_id"),
    })
    private AthleteSession athleteSession;

    // Mapping to the original block
    @ManyToOne
    @JoinColumns({
            @JoinColumn(name = "week_number", referencedColumnName = "week_number"),
            @JoinColumn(name = "week_name", referencedColumnName = "week_name"),
            @JoinColumn(name = "program_id", referencedColumnName = "program_id"),
            @JoinColumn(name = "session_number", referencedColumnName = "session_number"),
            @JoinColumn(name = "block_number", referencedColumnName = "block_number")
    })
    private Block block;

    private boolean isCompleted;
}
