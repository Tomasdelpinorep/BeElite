package com.salesianos.triana.BeElite.dto.Week;

import com.salesianos.triana.BeElite.dto.Session.SessionDto;
import com.salesianos.triana.BeElite.model.Program;
import com.salesianos.triana.BeElite.model.Week;
import lombok.Builder;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.List;
import java.util.UUID;

@Builder
public record WeekDto(
        String weekName,
        String description,
        List<SessionDto> sessions,
        Long weekNumber,
        LocalDateTime created_at,
        List<LocalDate> span
) {

    public static WeekDto of(Week w){
        return WeekDto.builder()
                .weekName(w.getId().getWeek_name())
                .description(w.getDescription())
                .sessions(w.getSessions() != null ?
                        w.getSessions().stream().map(SessionDto::of).toList() :
                        List.of())
                .weekNumber(w.getId().getWeek_number())
                .created_at(w.getCreatedAt())
                .span(w.getSpan())
                .build();
    }
}
