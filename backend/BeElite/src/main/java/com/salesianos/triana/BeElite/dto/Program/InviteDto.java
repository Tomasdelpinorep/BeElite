package com.salesianos.triana.BeElite.dto.Program;

import com.salesianos.triana.BeElite.model.InvitationStatus;
import com.salesianos.triana.BeElite.model.Invite;
import lombok.Builder;

import java.time.LocalDateTime;
import java.util.UUID;

@Builder
public record InviteDto(UUID inviteId,
                        LocalDateTime createdAt,
                        String coachName,
                        String programName,
                        String athleteUsername,
                        String status) {

    public static InviteDto of(Invite i){
        return InviteDto.builder()
                .inviteId(i.getId())
                .createdAt(i.getCreatedAt())
                .coachName(i.getProgram().getCoach().getName())
                .programName(i.getProgram().getProgramName())
                .athleteUsername(i.getAthlete().getUsername())
                .status(i.getStatus())
                .build();
    }
}
