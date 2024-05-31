package com.salesianos.triana.BeElite.dto.Program;

import com.salesianos.triana.BeElite.model.Program;
import jakarta.transaction.Transactional;
import lombok.Builder;

import java.time.LocalDate;

@Builder
public record ProgramDto(
        String coachName,
        String coachUsername,
        String programName,
        String programDescription,
        String programPicUrl,
        LocalDate createdAt,
        int numberOfSessions,
        int numberOfAthletes,
        boolean isVisible) {

    @Transactional
    public static ProgramDto of(Program p) {
        return ProgramDto.builder()
                .coachName(p.getCoach().getName())
                .coachUsername(p.getCoach().getUsername())
                .programName(p.getProgramName())
                .programDescription(p.getDescription())
                .programPicUrl(p.getImage())
                .createdAt(p.getCreatedAt())
                .numberOfSessions(p.getWeeks() != null ?
                        p.getWeeks().stream().flatMap(week -> week.getSessions().stream()).mapToInt(session -> 1).sum()
                        : 0)
                .numberOfAthletes(p.getAthletes() != null ?
                        p.getAthletes().size()
                        : 0)
                .isVisible(p.isVisible())
                .build();
    }

    public static ProgramDto empty() {
        return ProgramDto.builder().build();
    }

}
