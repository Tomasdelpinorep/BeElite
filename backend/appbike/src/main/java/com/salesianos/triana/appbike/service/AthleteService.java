package com.salesianos.triana.appbike.service;

import com.salesianos.triana.appbike.dto.User.AddUser;
import com.salesianos.triana.appbike.model.Athlete;
import com.salesianos.triana.appbike.repository.AthleteRepository;
import com.salesianos.triana.appbike.repository.UserRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;

import java.util.UUID;

@Service
@RequiredArgsConstructor
public class AthleteService {

    private final PasswordEncoder passwordEncoder;
    private final AthleteRepository athleteRepository;
    private final UserRepository userRepository;

    public Athlete createUser(AddUser addUser) {

        Athlete user = new Athlete();
        user.setUsername(addUser.username());
        user.setPassword(passwordEncoder.encode(addUser.password()));
        user.setEmail(addUser.email());
        user.setNombre(addUser.name());

        return athleteRepository.save(user);
    }

    public Athlete getDetails(Athlete user){
        return athleteRepository.findById(user.getId()).orElseThrow(() -> new NotFoundException("User"));
    }

    public Athlete findById(UUID id){
        return athleteRepository.findById(id).orElseThrow(() -> new NotFoundException("Cannot find a user with the specified id."));
    }

}
