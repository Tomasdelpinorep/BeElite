package com.salesianos.triana.BeElite.validation.annotation;

import jakarta.validation.Payload;

public @interface UniqueEmail {
    String message() default "Email name already in use.";

    Class<?>[] groups() default {};

    Class<? extends Payload>[] payload() default {};
}
