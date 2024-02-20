package com.salesianos.triana.BeElite.validation.annotation;

import com.salesianos.triana.BeElite.validation.validator.CostRestrictionValidator;
import jakarta.validation.Constraint;
import jakarta.validation.Payload;

import java.lang.annotation.*;

@Target({ElementType.FIELD, ElementType.PARAMETER})
@Retention(RetentionPolicy.RUNTIME)
@Constraint(validatedBy = CostRestrictionValidator.class)
@Documented
public @interface CostRestriction {

    String message() default "Invalid value. The cost must be between 0.00€ and 100€";

    Class<?>[] groups() default {};

    Class<? extends Payload>[] payload() default {};
}