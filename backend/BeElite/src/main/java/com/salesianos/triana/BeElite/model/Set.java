package com.salesianos.triana.BeElite.model;

import com.salesianos.triana.BeElite.model.Composite_Ids.SetId;
import jakarta.persistence.*;
import lombok.*;

@Entity
@RequiredArgsConstructor
@AllArgsConstructor
@Getter
@Setter
@Builder
public class Set {

    @EmbeddedId
    private SetId set_id;

    private int number_of_sets;

    private int number_of_reps;

    private double percentage;

    //Name the columns because if not they will be named like block_session_week_name, absolutely horrid stuff
    @ManyToOne
    @MapsId("block_id")
    @JoinColumns({
            @JoinColumn(name = "block_number", referencedColumnName = "block_number"),
            @JoinColumn(name = "session_number", referencedColumnName = "session_number"),
            @JoinColumn(name = "week_number", referencedColumnName = "week_number"),
            @JoinColumn(name = "week_name", referencedColumnName = "week_name"),
            @JoinColumn(name = "program_id", referencedColumnName = "program_id")
    })
    private Block block;
}
