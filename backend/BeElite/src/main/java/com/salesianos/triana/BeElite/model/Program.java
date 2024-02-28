package com.salesianos.triana.BeElite.model;

import jakarta.persistence.*;
import lombok.*;
import org.hibernate.annotations.UuidGenerator;
import org.springframework.data.annotation.CreatedDate;

import java.time.LocalDate;
import java.util.List;
import java.util.UUID;

@Entity
@RequiredArgsConstructor
@Getter
@Setter
@ToString
@AllArgsConstructor
@Builder
public class Program {

    @Id
    @GeneratedValue(generator = "UUID")
    @UuidGenerator
    @Column(columnDefinition = "uuid")
    private UUID id;

    private String programName;

    @ManyToOne
    @JoinColumn(name = "coach_id")
    private Coach coach;

    @OneToMany(mappedBy = "program", cascade = CascadeType.ALL)
    @ToString.Exclude
    private List<Week> weeks;

    private String description;

    private String image;

    @OneToMany(mappedBy = "program")
    @ToString.Exclude
    private List<Athlete> athletes;

    @CreatedDate
    private LocalDate createdAt;

    public void removeAthletes(){
        if(!athletes.isEmpty()){
            for(Athlete athlete : athletes){
                athlete.setProgram(null);
            }
            athletes.clear();
        }
    }
}
