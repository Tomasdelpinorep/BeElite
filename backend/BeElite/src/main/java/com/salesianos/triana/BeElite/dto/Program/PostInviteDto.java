package com.salesianos.triana.BeElite.dto.Program;

import com.salesianos.triana.BeElite.model.Invite;
import lombok.Builder;

import java.util.List;
import java.util.UUID;

@Builder
public record PostInviteDto(
        String athleteUsername,
        String programName,
        UUID coachId
) {

    public static PostInviteDto of(Invite i) {
        return PostInviteDto.builder()
                .athleteUsername(i.getAthlete().getUsername())
                .programName(i.getProgram().getProgramName())
                .coachId(i.getProgram().getCoach().getId())
                .build();
    }
}
