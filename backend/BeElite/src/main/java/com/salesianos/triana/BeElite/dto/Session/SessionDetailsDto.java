package com.salesianos.triana.BeElite.dto.Session;

import com.salesianos.triana.BeElite.dto.Block.BlockDto;
import com.salesianos.triana.BeElite.dto.Week.WeekDto;
import com.salesianos.triana.BeElite.model.Session;
import lombok.Builder;
import lombok.Getter;
import lombok.Setter;

import java.time.LocalDate;
import java.util.List;
import java.util.UUID;

@Builder
public record SessionCardDto(LocalDate date,
                                Long sessionNumber,
                                UUID programId,
                                String weekName,
                                Long weekNumber,
                                List<BlockDto> blocks,
                                String title,
                                String subtitle,
                                int sameDaySessionNumber) {

    public static SessionCardDto of(Session s){
        return SessionCardDto.builder()
                .date(s.getDate())
                .sessionNumber(s.getId().getSession_number())
                .programId(s.getId().getWeekId().getProgram_id())
                .weekName(s.getId().getWeekId().getWeek_name())
                .weekNumber(s.getId().getWeekId().getWeek_number())
                .blocks(s.getBlocks() != null ?
                        s.getBlocks().stream().map(BlockDto::of).toList() :
                        List.of())
                .title(s.getTitle())
                .subtitle(s.getSubtitle())
                .sameDaySessionNumber(s.getSame_day_session_number())
                .build();
    }
}
