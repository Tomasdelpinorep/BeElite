package com.salesianos.triana.BeElite.dto.Program;

import com.salesianos.triana.BeElite.model.Invite;
import lombok.Builder;
import lombok.Data;
import lombok.EqualsAndHashCode;

import java.util.UUID;

@Builder
public record InviteDto(
        UUID programId,
        UUID athleteId
) {

    public static InviteDto of(Invite i){
        return InviteDto.builder()
                .athleteId(i.getAthlete().getId())
                .programId(i.getProgram().getId())
                .build();
    }
}
