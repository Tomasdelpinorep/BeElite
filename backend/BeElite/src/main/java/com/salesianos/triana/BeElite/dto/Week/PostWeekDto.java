package com.salesianos.triana.BeElite.dto.Week;

import com.salesianos.triana.BeElite.dto.Program.ProgramDto;
import com.salesianos.triana.BeElite.model.Program;
import com.salesianos.triana.BeElite.model.Week;
import jakarta.validation.constraints.NotEmpty;
import jakarta.validation.constraints.NotNull;

import java.time.LocalDateTime;

public record PostWeekDto(
        @NotEmpty(message = "Week must have name")
        String week_name,
        String description,
        @NotNull(message = "Week must have creation date and time.")
        LocalDateTime created_at,
        @NotNull(message = "Week must be part of a program.")
        ProgramDto program
) {

        public static Week toEntity(PostWeekDto newWeek, Program p, Long weekId){
                return Week.builder()
                        .id(weekId)
                        .createdAt(newWeek.created_at)
                        .week_name(newWeek.week_name)
                        .description(newWeek.description())
                        .program(p)
                        .build();
        }
}
