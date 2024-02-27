package com.salesianos.triana.BeElite.dto.Program;

import com.salesianos.triana.BeElite.model.Coach;
import com.salesianos.triana.BeElite.model.Program;
import com.salesianos.triana.BeElite.validation.annotation.UniqueProgramName;
import jakarta.validation.constraints.NotEmpty;
import jakarta.validation.constraints.NotNull;

import java.time.LocalDate;
import java.util.UUID;

public record PostProgramDto(
        @NotEmpty(message = "Program name cannot be empty.")
        @UniqueProgramName(message = "Program name must be unique.")
        String programName,
        @NotEmpty(message = "Program description cannot be empty.")
        String description,
        @NotEmpty(message = "Image URL cannot be empty.")
        String image,
        LocalDate createdAt,
        @NotNull(message = "A program must be linked to a valid coach id.")
        UUID coach_id

) {
        public static Program toEntity(PostProgramDto newProgram, Coach c){
                return Program.builder()
                        .coach(c)
                        .createdAt(newProgram.createdAt())
                        .programName(newProgram.programName())
                        .description(newProgram.description())
                        .image(newProgram.image())
                        .build();
        }
}
