package com.salesianos.triana.BeElite.dto.Session;

import com.salesianos.triana.BeElite.model.Session;
import lombok.Builder;

import java.time.DayOfWeek;
import java.util.List;

@Builder
public record SessionDto(String dayOfWeek,
                         Long sessionNumber,
                         int sameDaySessionNumber)
{
    public static SessionDto empty(){
        return SessionDto.builder().build();
    }
    public static SessionDto of(Session s){
        return SessionDto.builder()
                .dayOfWeek(s.getDate().getDayOfWeek().toString())
                .sessionNumber(s.getId().getSession_number())
                .sameDaySessionNumber(s.getSame_day_session_number())
                .build();
    }
}
