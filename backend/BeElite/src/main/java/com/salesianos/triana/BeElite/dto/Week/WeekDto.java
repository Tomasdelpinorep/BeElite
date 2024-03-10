package com.salesianos.triana.BeElite.dto.Week;

import com.salesianos.triana.BeElite.dto.Session.SessionDto;
import com.salesianos.triana.BeElite.model.Program;
import com.salesianos.triana.BeElite.model.Week;
import lombok.Builder;

import java.time.LocalDateTime;
import java.util.List;
import java.util.UUID;

@Builder
public record WeekDto(
        String weekName,
        String description,
        List<SessionDto> sessions,
        Long id,
        LocalDateTime created_at
) {

    public static WeekDto of(Week w){
        return WeekDto.builder()
                .weekName(w.getWeek_name())
                .description(w.getDescription())
                .sessions(w.getSessions() != null ?
                        w.getSessions().stream().map(SessionDto::of).toList() :
                        List.of())
                .id(w.getId())
                .created_at(w.getCreatedAt())
                .build();
    }
}
