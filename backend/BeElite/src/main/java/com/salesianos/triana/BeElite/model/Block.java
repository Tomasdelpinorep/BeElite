package com.salesianos.triana.BeElite.model;

import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.RequiredArgsConstructor;

import java.util.List;

@Entity
@AllArgsConstructor
@RequiredArgsConstructor
@Builder
public class Block {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    private String movement;

    @ManyToOne
    @JoinColumn(name = "session_id")
    private Session session;

    @OneToMany(mappedBy = "block", cascade = CascadeType.ALL)
    private List<Set> sets;

    private Double rest_between_sets;

    private String instructions;
}
