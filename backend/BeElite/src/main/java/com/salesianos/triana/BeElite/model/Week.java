package com.salesianos.triana.BeElite.model;

import jakarta.persistence.*;
import lombok.*;

import java.util.List;

@Entity
@RequiredArgsConstructor
@AllArgsConstructor
@Builder
@Getter
@Setter
@IdClass(WeekId.class)
public class Week {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Id
    private String week_name;

    private String description;

    @OneToMany(mappedBy = "week")
    private List<Session> sessions;

    @Id
    @ManyToOne
    @JoinColumn(name = "program_id")
    private Program program;
}
