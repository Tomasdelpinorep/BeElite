package com.salesianos.triana.BeElite.dto.Week;

import com.salesianos.triana.BeElite.dto.Program.ProgramDto;
import com.salesianos.triana.BeElite.model.Program;
import com.salesianos.triana.BeElite.model.Week;
import jakarta.validation.constraints.NotEmpty;
import jakarta.validation.constraints.NotNull;
import lombok.Getter;
import lombok.Setter;

import java.time.LocalDateTime;

@Getter
@Setter
public class EditWeekDto{
        @NotEmpty(message = "Week must have name")
        String week_name;
        String original_name;
        String description;
        @NotNull(message = "Week must have creation date and time.")
        LocalDateTime created_at;
        @NotNull(message = "Week must be part of a program.")
        ProgramDto program;
        Long week_number;
        public static Week toEntity(EditWeekDto editedWeek, Program p){
                return Week.builder()
                        .id(editedWeek.week_number)
                        .createdAt(editedWeek.created_at)
                        .week_name(editedWeek.week_name)
                        .description(editedWeek.description)
                        .program(p)
                        .build();
        }
}
