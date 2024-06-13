package com.salesianos.triana.BeElite.dto.Session;

import com.salesianos.triana.BeElite.dto.Block.AthleteBlockDto;
import com.salesianos.triana.BeElite.model.AthleteSession;
import com.salesianos.triana.BeElite.model.Composite_Ids.AthleteSessionId;
import com.salesianos.triana.BeElite.model.Composite_Ids.SessionId;
import lombok.Builder;
import lombok.Getter;

import java.time.LocalDate;
import java.util.List;

@Builder
public record AthleteSessionDto(
        AthleteSessionId sessionId,
        LocalDate date,
        String title,
        String subtitle,
        int sameDaySessionNumber,
        List<AthleteBlockDto> blocks,
        boolean isCompleted
) {
    public static AthleteSessionDto of(AthleteSession a){
        return AthleteSessionDto.builder()
                .sessionId(AthleteSessionId.of(a.getId().getAthlete_session_number(), a.getId().getAthlete_id()))
                .date(a.getSession().getDate())
                .title(a.getSession().getTitle())
                .subtitle(a.getSession().getTitle())
                .sameDaySessionNumber(a.getSession().getSame_day_session_number())
                .blocks(a.getAthleteBlocks() == null ? List.of() : a.getAthleteBlocks().stream().map(AthleteBlockDto::of).toList())
                .isCompleted(a.isCompleted())
                .build();
    }

}
