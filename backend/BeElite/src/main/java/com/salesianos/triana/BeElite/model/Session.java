package com.salesianos.triana.BeElite.model;

import com.salesianos.triana.BeElite.model.Composite_Ids.SessionId;
import jakarta.persistence.*;
import lombok.*;

import java.time.LocalDate;
import java.util.List;

@Entity
@Builder
@RequiredArgsConstructor
@AllArgsConstructor
@Getter
@Setter
public class Session{

    @EmbeddedId
    private SessionId id;

    private LocalDate date;

    @OneToMany(mappedBy = "session", cascade = CascadeType.ALL)
    private List<Block> blocks;

    private String title;

    private String subtitle;

    private Integer same_day_session_number;
}
