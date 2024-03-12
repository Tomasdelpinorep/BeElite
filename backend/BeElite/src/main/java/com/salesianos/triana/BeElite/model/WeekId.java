package com.salesianos.triana.BeElite.model;

import jakarta.persistence.Column;
import jakarta.persistence.Embeddable;
import jakarta.persistence.JoinColumn;
import jakarta.persistence.ManyToOne;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import org.springframework.stereotype.Service;

import java.io.Serializable;
@AllArgsConstructor
@NoArgsConstructor
@Embeddable
@Getter
@Setter
public class WeekId implements Serializable {

    @Column(name = "week_number")
    private Long week_number;

    @Column(name = "week_name")
    private String week_name;

    @ManyToOne
    @JoinColumn(name = "program_id")
    private Program program;

    public static WeekId of(Long id, String week_name, Program program){
        return new WeekId(id,week_name,program);
    }
}
