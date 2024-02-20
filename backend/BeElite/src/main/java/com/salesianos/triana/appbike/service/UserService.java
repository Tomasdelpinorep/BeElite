package com.salesianos.triana.appbike.service;

import com.salesianos.triana.appbike.model.User;
import com.salesianos.triana.appbike.repository.UserRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.util.Optional;
import java.util.UUID;

@Service
@RequiredArgsConstructor
public class UserService {

    private final UserRepository userRepository;

    public Optional<User> findById(UUID id){
        return userRepository.findById(id);
    }

    public boolean userExists(String username) {
        return userRepository.existsByUsernameIgnoreCase(username);
    }


}
