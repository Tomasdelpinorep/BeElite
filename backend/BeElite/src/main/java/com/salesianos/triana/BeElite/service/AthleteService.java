package com.salesianos.triana.BeElite.service;

import com.salesianos.triana.BeElite.dto.User.AddUser;
import com.salesianos.triana.BeElite.exception.NotFoundException;
import com.salesianos.triana.BeElite.model.Athlete;
import com.salesianos.triana.BeElite.repository.AthleteRepository;
import com.salesianos.triana.BeElite.repository.UserRepository;
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

    public Athlete createAthlete(AddUser addAthlete) {

        Athlete user = new Athlete();
        user.setUsername(addAthlete.username());
        user.setPassword(passwordEncoder.encode(addAthlete.password()));
        user.setEmail(addAthlete.email());
        user.setName(addAthlete.name());

        return athleteRepository.save(user);
    }

    public Athlete getDetails(Athlete user){
        return athleteRepository.findById(user.getId()).orElseThrow(() -> new NotFoundException("athlete"));
    }

    public Athlete findById(UUID id){
        return athleteRepository.findById(id).orElseThrow(() -> new NotFoundException("athlete"));
    }

}
