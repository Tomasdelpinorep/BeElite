package com.salesianos.triana.BeElite.validation.annotation;

import jakarta.validation.Payload;

public @interface UniqueProgramName {

    String message() default "Program name already in use.";

    Class<?>[] groups() default {};

    Class<? extends Payload>[] payload() default {};
}
