package com.salesianos.triana.BeElite.dto.Week;

import com.salesianos.triana.BeElite.dto.Program.ProgramDto;
import com.salesianos.triana.BeElite.model.Program;
import com.salesianos.triana.BeElite.model.Week;
import com.salesianos.triana.BeElite.model.Composite_Ids.WeekId;
import jakarta.validation.constraints.NotEmpty;
import jakarta.validation.constraints.NotNull;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.List;
import java.util.UUID;

public record PostWeekDto(
        @NotEmpty(message = "Week must have name")
        String week_name,
        String description,
        @NotNull(message = "Week must have creation date and time.")
        LocalDateTime created_at,
        @NotNull(message = "Week must be part of a program.")
        ProgramDto program,

        @NotNull(message = "Week must have a valid span.")
        List<LocalDate>span
) {

        public static Week toEntity(PostWeekDto newWeek, UUID p_id, Long weekNumber){
                return Week.builder()
                        .id(WeekId.of(weekNumber, newWeek.week_name, p_id))
                        .createdAt(newWeek.created_at)
                        .description(newWeek.description())
                        .span(newWeek.span)
                        .program(Program.builder().id(p_id).build())
                        .build();
        }
}
