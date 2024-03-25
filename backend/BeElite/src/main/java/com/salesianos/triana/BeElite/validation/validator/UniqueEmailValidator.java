package com.salesianos.triana.BeElite.validation.validator;

import com.salesianos.triana.BeElite.repository.UserRepository;
import com.salesianos.triana.BeElite.service.UserService;
import com.salesianos.triana.BeElite.validation.annotation.UniqueProgramName;
import jakarta.validation.ConstraintValidator;
import jakarta.validation.ConstraintValidatorContext;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.util.StringUtils;

public class UniqueEmailValidator  implements ConstraintValidator<UniqueProgramName, String> {
    @Autowired
    private UserService userService;
    @Override
    public boolean isValid(String s, ConstraintValidatorContext constraintValidatorContext) {
        return StringUtils.hasText(s) && !userService.isEmailInUse(s);
    }
}
