package com.salesianos.triana.BeElite.dto.User;

import com.salesianos.triana.BeElite.dto.Program.ProgramDto;
import com.salesianos.triana.BeElite.model.Coach;
import com.salesianos.triana.BeElite.model.Program;
import jakarta.transaction.Transactional;
import lombok.Builder;
import org.apache.catalina.User;

import java.time.LocalDateTime;
import java.util.List;
import java.util.UUID;

@Builder
public record CoachDetailsDto(
        UUID id,
        String username,
        String name,
        String email,
        String profilePicUrl,
        LocalDateTime createdAt,
        List<UserDto> athletes,
        List<ProgramDto> programs
) {

    @Transactional
    public static CoachDetailsDto of(Coach c){
        return CoachDetailsDto.builder()
                .id(c.getId())
                .username(c.getUsername())
                .name(c.getName())
                .email(c.getEmail())
                .profilePicUrl(c.getProfilePicUrl())
                .createdAt(c.getJoinDate())
                .athletes(c.getPrograms().stream().flatMap(program -> program.getAthletes().stream()).map(UserDto::of).toList())
                .programs(c.getPrograms().stream().filter(Program::isVisible).map(ProgramDto::of).toList())
                .build();
    }
}
