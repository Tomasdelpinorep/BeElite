package com.salesianos.triana.BeElite.model;

import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.RequiredArgsConstructor;
import java.time.LocalDate;
import java.util.List;

@Entity
@Builder
@RequiredArgsConstructor
@AllArgsConstructor
public class Session {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    private LocalDate date;

    @ManyToOne
    @JoinColumns({
            @JoinColumn(name = "week_id", referencedColumnName = "id"),
            @JoinColumn(name = "week_name", referencedColumnName = "week_name")
    })
    private Week week;

    @OneToMany(mappedBy = "session", cascade = CascadeType.ALL)
    private List<Block> blocks;

    private String title;

    private String subtitle;
}
