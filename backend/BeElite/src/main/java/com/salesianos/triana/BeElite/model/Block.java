package com.salesianos.triana.BeElite.model;

import com.salesianos.triana.BeElite.model.Composite_Ids.BlockId;
import jakarta.persistence.*;
import lombok.*;

import java.util.ArrayList;
import java.util.List;

@Entity
@AllArgsConstructor
@RequiredArgsConstructor
@Getter
@Setter
@Builder
public class Block {

    @EmbeddedId
    private BlockId block_id;

    private String movement;

    @ManyToOne
    @MapsId("session_id")
    @JoinColumns({
            @JoinColumn(name = "session_number", referencedColumnName = "session_number"),
            @JoinColumn(name = "week_number", referencedColumnName = "week_number"),
            @JoinColumn(name = "week_name", referencedColumnName = "week_name"),
            @JoinColumn(name = "program_id", referencedColumnName = "program_id")
    })
    private Session session;

    @OneToMany(mappedBy = "block", cascade = CascadeType.ALL, orphanRemoval = true)
    private List<Set> sets = new ArrayList<>();

    private Double rest_between_sets;

    private String instructions;
}
