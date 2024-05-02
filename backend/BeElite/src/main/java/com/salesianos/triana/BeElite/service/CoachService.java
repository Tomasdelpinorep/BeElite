package com.salesianos.triana.BeElite.service;

import com.salesianos.triana.BeElite.dto.User.AddUser;
import com.salesianos.triana.BeElite.exception.NotFoundException;
import com.salesianos.triana.BeElite.model.Coach;
import lombok.RequiredArgsConstructor;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;
import com.salesianos.triana.BeElite.repository.CoachRepository;
import org.springframework.web.multipart.MultipartFile;

import java.io.IOException;
import java.util.List;
import java.util.UUID;

@Service
@RequiredArgsConstructor
public class CoachService {
    private final CoachRepository coachRepository;
    private final PasswordEncoder passwordEncoder;

    public Coach createCoach(AddUser addUser){
        Coach coach = new Coach();
        coach.setUsername(addUser.username());
        coach.setPassword(passwordEncoder.encode(addUser.password()));
        coach.setEmail(addUser.email());
        coach.setName(addUser.name());

        return coachRepository.save(coach);
    }

    public Coach findByUsername(String coachUsername){
        return coachRepository.findByUsername(coachUsername).orElseThrow(() -> new NotFoundException("coach"));
    }

    public Coach findById(UUID id){
        return coachRepository.findById(id).orElseThrow(() -> new NotFoundException("coach"));
    }

    public int getTotalSessionsCompleted(String coachUsername){
        Coach c = coachRepository.findByUsername(coachUsername).orElseThrow(() -> new NotFoundException("coach"));
        return coachRepository.getTotalSessionsCompleted(c.getId());
    }

    public Page<Coach> getAllCoaches(Pageable page){
        return coachRepository.findAll(page);
    }
}
