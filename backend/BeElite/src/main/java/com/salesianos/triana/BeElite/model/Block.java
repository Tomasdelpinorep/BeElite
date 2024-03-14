package com.salesianos.triana.BeElite.model;

import com.salesianos.triana.BeElite.model.Composite_Ids.BlockId;
import jakarta.persistence.*;
import lombok.*;

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
    private Session session;

    @OneToMany(cascade = CascadeType.ALL)
    private List<Set> sets;

    private Double rest_between_sets;

    private String instructions;

    private boolean  is_completed;
}
