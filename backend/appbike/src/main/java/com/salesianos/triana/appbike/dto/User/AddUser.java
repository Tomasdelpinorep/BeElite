package com.salesianos.triana.appbike.dto.User;

import com.salesianos.triana.appbike.validation.annotation.UniqueUsername;
import jakarta.validation.constraints.Email;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.Size;

public record AddUser(
        @NotBlank(message = "Username cannot be blank.")
        @UniqueUsername
        String username,

        @NotBlank(message = "Password cannot be blank.")
        @Size(min = 6, message = "Password must be at least 6 characters long.")
        String password,
        @NotBlank(message = "Password cannot be blank.")
        @Size(min = 6, message = "Password must be at least 6 characters long.")
        String verifyPassword,

        @NotBlank(message = "Email cannot be blank")
        @Email(message = "Must be a valid email address.")
        String email,

        @NotBlank(message = "Name cannot be blank.")
        String name
) {
}
