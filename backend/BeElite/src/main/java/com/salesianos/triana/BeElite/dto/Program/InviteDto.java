package com.salesianos.triana.BeElite.dto.Program;

import com.salesianos.triana.BeElite.model.Invite;
import lombok.Builder;
import lombok.Data;
import lombok.EqualsAndHashCode;

import java.util.List;
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

    public static List<InviteDto> emptyList(){
        return List.of(InviteDto.builder().build());
    }
}
