package com.salesianos.triana.BeElite.dto.Session;

import com.salesianos.triana.BeElite.dto.Block.BlockDto;
import com.salesianos.triana.BeElite.model.Session;
import lombok.Builder;

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
                .programId(s.getId().getWeek_id().getProgram_id())
                .weekName(s.getId().getWeek_id().getWeek_name())
                .weekNumber(s.getId().getWeek_id().getWeek_number())
                .blocks(s.getBlocks() != null ?
                        s.getBlocks().stream().map(BlockDto::of).toList() :
                        List.of())
                .title(s.getTitle())
                .subtitle(s.getSubtitle())
                .sameDaySessionNumber(s.getSame_day_session_number())
                .build();
    }
}
