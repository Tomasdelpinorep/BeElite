package com.salesianos.triana.BeElite.dto.User;

import com.salesianos.triana.BeElite.dto.Program.ProgramDto;
import com.salesianos.triana.BeElite.model.Coach;
import lombok.Builder;
import java.time.LocalDateTime;
import java.util.List;

@Builder
public record CoachDetailsDto(
        String username,
        String name,
        String email,
        String profilePicUrl,
        LocalDateTime createdAt,
        List<AthleteDto> athletes,
        List<ProgramDto> programs
) {

    public static CoachDetailsDto of(Coach c){
        return CoachDetailsDto.builder()
                .username(c.getUsername())
                .name(c.getName())
                .email(c.getEmail())
                .profilePicUrl(c.getProfilePicUrl())
                .createdAt(c.getCreatedAt())
                .athletes(c.getPrograms().stream().flatMap(program -> program.getAthletes().stream()).map(AthleteDto::of).toList())
                .programs(c.getPrograms().stream().map(ProgramDto::of).toList())
                .build();
    }
}
