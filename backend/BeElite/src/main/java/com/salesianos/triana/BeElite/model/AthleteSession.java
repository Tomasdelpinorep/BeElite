package com.salesianos.triana.BeElite.model;

import com.salesianos.triana.BeElite.model.Composite_Ids.AthleteSessionId;
import jakarta.persistence.*;
import lombok.*;

import java.util.ArrayList;
import java.util.List;

@Entity
@Getter
@Setter
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class AthleteSession {

    @EmbeddedId
    private AthleteSessionId id;

    @ManyToOne
    @MapsId("athlete_id")
    private Athlete athlete;

    // Mapping to the original session from the athlete's program
    @ManyToOne
    @JoinColumns({
            @JoinColumn(name = "week_number", referencedColumnName = "week_number"),
            @JoinColumn(name = "week_name", referencedColumnName = "week_name"),
            @JoinColumn(name = "program_id", referencedColumnName = "program_id"),
            @JoinColumn(name = "session_number", referencedColumnName = "session_number")
    })
    private Session session;

    @OneToMany(mappedBy = "athleteSession", cascade = CascadeType.REMOVE, orphanRemoval = true)
    private List<AthleteBlock> athleteBlocks;

    private boolean isCompleted;
}
