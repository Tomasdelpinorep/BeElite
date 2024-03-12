package com.salesianos.triana.BeElite.model;

import com.salesianos.triana.BeElite.service.WeekService;
import jakarta.persistence.*;
import lombok.*;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.annotation.CreatedDate;

import java.time.LocalDateTime;
import java.util.List;

@Entity
@RequiredArgsConstructor
@AllArgsConstructor
@Builder
@Getter
@Setter
public class Week {

    @EmbeddedId
    private WeekId id;

    private String description;

    @ManyToOne
    @MapsId("program_id")
    @JoinColumn(name = "program_id")
    private Program program;

    @OneToMany(mappedBy = "week", cascade = CascadeType.REMOVE)
    private List<Session> sessions;

    @CreatedDate
    LocalDateTime createdAt;

}
