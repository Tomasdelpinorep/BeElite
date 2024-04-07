package com.salesianos.triana.BeElite.dto.Program;

import com.salesianos.triana.BeElite.dto.User.UserDto;
import com.salesianos.triana.BeElite.dto.Week.WeekDto;
import com.salesianos.triana.BeElite.model.Program;
import lombok.Builder;

import java.time.LocalDate;
import java.util.List;

@Builder
public record ProgramDetailsDto(String programName,
                                List<WeekDto> weeks,
                                String description,
                                String image,
                                UserDto coach,
                                List<UserDto> athletes,
                                LocalDate createdAt,
                                List<InviteDto> invitesSent
                                ) {
    public static ProgramDetailsDto of(Program p){
        return ProgramDetailsDto.builder()
                .programName(p.getProgramName())
                .weeks(p.getWeeks() != null ?
                        p.getWeeks().stream().map(WeekDto::of).toList() :
                        List.of())
                .description(p.getDescription())
                .image(p.getImage())
                .coach(UserDto.of(p.getCoach()))
                .athletes(p.getAthletes() != null ?
                        p.getAthletes().stream().map(UserDto::of).toList() :
                        List.of())
                .createdAt(p.getCreatedAt())
                .invitesSent(p.getInvitesSent() != null ?
                        p.getInvitesSent().stream().map(InviteDto::of).toList() :
                        List.of())
                .build();
    }
}
