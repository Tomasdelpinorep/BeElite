package com.salesianos.triana.BeElite.dto.User;

import com.salesianos.triana.BeElite.model.Athlete;
import jakarta.validation.constraints.NotEmpty;
import lombok.Builder;

@Builder
public record AthleteDto(
        @NotEmpty(message = "Athlete must have username.")
        String username,
        @NotEmpty(message = "Athlete must have a name.")
        String name,
        String profilePicUrl,
        @NotEmpty(message = "Athlete must have email.")
        String email
) {
    public static AthleteDto of(Athlete a){
        return AthleteDto.builder()
                .username(a.getUsername())
                .name(a.getName())
                .email(a.getEmail())
                .profilePicUrl(a.getProfilePicUrl())
                .build();
    }
}
