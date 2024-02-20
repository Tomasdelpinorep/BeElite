package com.salesianos.triana.appbike.service;

import com.salesianos.triana.appbike.dto.User.AddUser;
import com.salesianos.triana.appbike.model.Athlete;
import com.salesianos.triana.appbike.model.Coach;
import lombok.RequiredArgsConstructor;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;
import com.salesianos.triana.appbike.repository.CoachRepository;
import java.util.UUID;

@Service
@RequiredArgsConstructor
public class CoachService {
    private final CoachRepository coachRepository;
    private final PasswordEncoder passwordEncoder;

    public Coach createCoach(AddUser addUser) {

        Coach coach = new Coach();
        coach.setUsername(addUser.username());
        coach.setPassword(passwordEncoder.encode(addUser.password()));
        coach.setEmail(addUser.email());
        coach.setNombre(addUser.name());

        return coachRepository.save(coach);
    }

    public Athlete getDetails(Athlete user){
        return coachRepository.findById(user.getId()).orElseThrow(() -> new NotFoundException("User"));
    }

    public Athlete findById(UUID id){
        return coachRepository.findById(id).orElseThrow(() -> new NotFoundException("Cannot find a user with the specified id."));
    }
}