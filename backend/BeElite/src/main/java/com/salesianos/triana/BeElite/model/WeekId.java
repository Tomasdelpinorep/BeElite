package com.salesianos.triana.BeElite.model;

import lombok.AllArgsConstructor;
import lombok.NoArgsConstructor;

import java.io.Serializable;
@AllArgsConstructor
@NoArgsConstructor
public class WeekId implements Serializable {
    private Long id;
    private String week_name;

    private Program program;

    public static WeekId of(Long id, String week_name, Program program){
        return new WeekId(id,week_name,program);
    }
}
