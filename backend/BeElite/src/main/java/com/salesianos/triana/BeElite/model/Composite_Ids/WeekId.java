package com.salesianos.triana.BeElite.model.Composite_Ids;

import com.salesianos.triana.BeElite.model.Program;
import jakarta.persistence.Column;
import jakarta.persistence.Embeddable;
import jakarta.persistence.JoinColumn;
import jakarta.persistence.ManyToOne;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

import java.io.Serializable;
import java.util.UUID;

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

    @Column(name = "program_id")
    private UUID program_id;

    public static WeekId of(Long week_number, String week_name, UUID program_id){
        return new WeekId(week_number,week_name, program_id);
    }
}
