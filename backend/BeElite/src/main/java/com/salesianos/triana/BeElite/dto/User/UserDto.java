package com.salesianos.triana.BeElite.dto.User;

import com.salesianos.triana.BeElite.model.Usuario;
import jakarta.transaction.Transactional;
import jakarta.validation.constraints.NotEmpty;
import lombok.Builder;

import java.time.LocalDate;
import java.time.LocalDateTime;

@Builder
public record UserDto(
        @NotEmpty(message = "Athlete must have username.")
        String username,
        @NotEmpty(message = "Athlete must have a name.")
        String name,
        String profilePicUrl,
        @NotEmpty(message = "Athlete must have email.")
        String email,
        LocalDate joinedProgramDate
) {

    @Transactional
    public static UserDto of(Usuario u){
        return UserDto.builder()
                .username(u.getUsername())
                .name(u.getName())
                .email(u.getEmail())
                .profilePicUrl(u.getProfilePicUrl())
                .joinedProgramDate(u.getJoinDate().toLocalDate())
                .build();
    }

    public static UserDto of(Usuario u, LocalDate joinedProgramDate){
        return UserDto.builder()
                .username(u.getUsername())
                .name(u.getName())
                .email(u.getEmail())
                .profilePicUrl(u.getProfilePicUrl())
                .joinedProgramDate(joinedProgramDate)
                .build();
    }

    public static UserDto empty(){
        return UserDto.builder().build();
    }
}
