package com.salesianos.triana.BeElite.validation.validator;

import com.salesianos.triana.BeElite.service.ProgramService;
import com.salesianos.triana.BeElite.validation.annotation.UniqueProgramName;
import jakarta.validation.ConstraintValidator;
import jakarta.validation.ConstraintValidatorContext;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.util.StringUtils;

import java.lang.annotation.Annotation;

public class UniqueProgramNameValidator implements ConstraintValidator<UniqueProgramName, String> {

    @Autowired
    private ProgramService programService;

    @Override
    public boolean isValid(String s, ConstraintValidatorContext constraintValidatorContext) {
        return StringUtils.hasText(s) && !programService.programExists(s);
    }
}
