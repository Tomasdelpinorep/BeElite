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
@IdClass(WeekId.class)
public class Week {

    @Id
    private Long id;

    @Id
    private String week_name;

    private String description;

    @OneToMany(mappedBy = "week", cascade = CascadeType.REMOVE)
    private List<Session> sessions;

    @Id
    @ManyToOne
    @JoinColumn(name = "program_id")
    private Program program;

    @CreatedDate
    LocalDateTime createdAt;

}
