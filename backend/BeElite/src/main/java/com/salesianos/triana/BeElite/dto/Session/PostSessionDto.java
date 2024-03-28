package com.salesianos.triana.BeElite.dto.Session;

import com.salesianos.triana.BeElite.dto.Block.BlockDto;
import com.salesianos.triana.BeElite.dto.Block.PostBlockDto;
import com.salesianos.triana.BeElite.model.Composite_Ids.SessionId;
import com.salesianos.triana.BeElite.model.Composite_Ids.WeekId;
import com.salesianos.triana.BeElite.model.Session;
import com.salesianos.triana.BeElite.model.Week;
import com.salesianos.triana.BeElite.service.BlockService;
import com.salesianos.triana.BeElite.service.SessionService;
import lombok.Builder;

import java.time.LocalDate;
import java.util.List;

@Builder
public record PostSessionDto(
        Long session_number,
        LocalDate date,
        String title,
        String subtitle,
        List<PostBlockDto> blocks,
        Integer same_day_session_number
) {

    public static PostSessionDto of(Session s){
        return PostSessionDto.builder()
                .session_number(s.getId().getSession_number())
                .date(s.getDate())
                .title(s.getTitle())
                .subtitle(s.getSubtitle())
                .blocks(s.getBlocks() != null ?
                        s.getBlocks().stream().map(PostBlockDto::of).toList() :
                        List.of())
                .same_day_session_number(s.getSame_day_session_number())
                .build();
    }
}
