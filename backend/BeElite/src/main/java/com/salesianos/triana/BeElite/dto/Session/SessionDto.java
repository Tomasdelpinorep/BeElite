package com.salesianos.triana.BeElite.dto.Session;

import com.salesianos.triana.BeElite.model.Session;
import lombok.Builder;

import java.time.DayOfWeek;
import java.util.List;

@Builder
public record SessionDto(String dayOfWeek,
                         int sessionNumber)
{
    public static SessionDto empty(){
        return SessionDto.builder().build();
    }
    public static SessionDto of(Session s){
        return SessionDto.builder()
                .dayOfWeek(s.getDate().getDayOfWeek().toString())
                .sessionNumber(s.getSameDaySessionNumber())
                .build();
    }
}
