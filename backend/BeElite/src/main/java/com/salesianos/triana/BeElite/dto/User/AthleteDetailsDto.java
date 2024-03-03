package com.salesianos.triana.BeElite.dto.User;

import com.salesianos.triana.BeElite.dto.Program.InviteDto;
import com.salesianos.triana.BeElite.dto.Program.ProgramDto;
import com.salesianos.triana.BeElite.model.Athlete;
import jakarta.validation.constraints.NotEmpty;
import lombok.Builder;

import java.util.List;
import java.util.Optional;

@Builder
public record AthleteDetailsDto(@NotEmpty(message = "Athlete must have username.")
                                String username,
                                @NotEmpty(message = "Athlete must have a name.")
                                String name,
                                String profilePicUrl,
                                @NotEmpty(message = "Athlete must have email.")
                                String email,
                                ProgramDto program,
                                UserDto coach,
                                int completed_sessions,
                                List<InviteDto> invites
                                )
{
    public static AthleteDetailsDto of(Athlete a){
        return AthleteDetailsDto.builder()
                .username(a.getUsername())
                .name(a.getName())
                .profilePicUrl(a.getProfilePicUrl())
                .email(a.getEmail())
                .program(a.getProgram() != null ? ProgramDto.of(a.getProgram()) : ProgramDto.empty())
                .coach(a.getProgram() != null ? UserDto.of(a.getProgram().getCoach()) : UserDto.empty())
                .completed_sessions(a.getCompleted_sessions())
                .invites(a.getInvites() != null ? a.getInvites().stream().map(InviteDto::of).toList() : InviteDto.emptyList())
                .build();
    }
}
