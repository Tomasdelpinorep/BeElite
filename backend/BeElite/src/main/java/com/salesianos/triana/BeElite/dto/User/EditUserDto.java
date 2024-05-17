package com.salesianos.triana.BeElite.dto.User;

import com.salesianos.triana.BeElite.model.Coach;
import jakarta.validation.constraints.Email;
import jakarta.validation.constraints.NotNull;

public record EditUserDto(@NotNull String name,
                          @Email @NotNull String email) {
}
