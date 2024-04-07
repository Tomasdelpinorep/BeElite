package com.salesianos.triana.BeElite.dto.Program;

import com.salesianos.triana.BeElite.model.InvitationStatus;
import com.salesianos.triana.BeElite.model.Invite;
import jakarta.persistence.criteria.CriteriaBuilder;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.NoArgsConstructor;
import lombok.RequiredArgsConstructor;

import java.time.LocalDateTime;

@Builder
public record InviteDto(LocalDateTime createdAt,
                        String programName,
                        String athleteUsername,
                        InvitationStatus status) {

    public static InviteDto of(Invite i){
        return InviteDto.builder()
                .createdAt(i.getCreatedAt())
                .programName(i.getProgram().getProgramName())
                .athleteUsername(i.getAthlete().getUsername())
                .status(i.getStatus())
                .build();
    }
}
