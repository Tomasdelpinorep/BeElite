package com.salesianos.triana.BeElite.dto.Session;

import com.salesianos.triana.BeElite.dto.Block.PostBlockDto;
import com.salesianos.triana.BeElite.model.Composite_Ids.SessionId;
import com.salesianos.triana.BeElite.model.Composite_Ids.WeekId;
import com.salesianos.triana.BeElite.model.Session;
import com.salesianos.triana.BeElite.model.Week;
import lombok.Builder;

import java.time.LocalDate;
import java.util.List;

public record PostSessionDto(
        Long session_number,
        LocalDate date,
        String title,
        String subtitle,
        List<PostBlockDto> blocks,
        Integer same_day_session_number
) {

    public static Session toEntity(PostSessionDto postSession, WeekId weekId){
        SessionId sessionId = SessionId.of(postSession.session_number, weekId);

        return Session.builder()
                .id(sessionId)
                .date(postSession.date)
                .title(postSession.title)
                .subtitle(postSession.subtitle)
                .blocks(postSession.blocks.stream().map(
                        block -> PostBlockDto.toEntity(block, sessionId)).toList())
                .same_day_session_number(postSession.same_day_session_number)
                .week(Week.builder().id(weekId).build())
                .build();
    }
}
