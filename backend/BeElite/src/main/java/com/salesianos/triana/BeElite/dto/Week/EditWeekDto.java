package com.salesianos.triana.BeElite.dto.Week;

import com.salesianos.triana.BeElite.dto.Program.ProgramDto;
import com.salesianos.triana.BeElite.model.Program;
import com.salesianos.triana.BeElite.model.Week;
import com.salesianos.triana.BeElite.model.Composite_Ids.WeekId;
import jakarta.validation.constraints.NotEmpty;
import jakarta.validation.constraints.NotNull;
import lombok.Getter;
import lombok.Setter;

import java.time.LocalDateTime;
import java.util.UUID;

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
        public static Week toEntity(EditWeekDto editedWeek, UUID p_id){
                return Week.builder()
                        .id(WeekId.of(editedWeek.getWeek_number(), editedWeek.getWeek_name(), p_id))
                        .createdAt(editedWeek.created_at)
                        .description(editedWeek.description)
                        .build();
        }
}
