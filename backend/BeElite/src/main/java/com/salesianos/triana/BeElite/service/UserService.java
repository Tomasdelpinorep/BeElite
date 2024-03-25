package com.salesianos.triana.BeElite.service;

import com.salesianos.triana.BeElite.dto.User.AddUser;
import com.salesianos.triana.BeElite.model.Coach;
import com.salesianos.triana.BeElite.model.Usuario;
import com.salesianos.triana.BeElite.repository.UserRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.util.Optional;
import java.util.UUID;

@Service
@RequiredArgsConstructor
public class UserService {

    private final UserRepository userRepository;

    public Optional<Usuario> findById(UUID id){
        return userRepository.findById(id);
    }

    public boolean userExists(String username) {
        return userRepository.existsByUsernameIgnoreCase(username);
    }

    public boolean isEmailInUse(String email){return userRepository.existsByEmailIgnoreCase(email);}
}
