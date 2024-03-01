package com.salesianos.triana.BeElite.service;

import com.salesianos.triana.BeElite.dto.User.AddUser;
import com.salesianos.triana.BeElite.model.Admin;
import com.salesianos.triana.BeElite.repository.AdminRepository;
import com.salesianos.triana.BeElite.repository.AthleteRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;

@Service
@RequiredArgsConstructor
public class AdminService {

    private final PasswordEncoder passwordEncoder;
    private final AdminRepository adminRepository;

    public Admin createAdmin(AddUser addUser){
        Admin a = Admin.builder()
                .username(addUser.username())
                .name(addUser.name())
                .password(passwordEncoder.encode(addUser.password()))
                .email(addUser.email())
                .build();

        return adminRepository.save(a);
    }
}
