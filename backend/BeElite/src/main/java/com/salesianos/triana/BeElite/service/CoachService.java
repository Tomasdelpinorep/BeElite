package com.salesianos.triana.BeElite.service;

import com.salesianos.triana.BeElite.dto.User.AddUser;
import com.salesianos.triana.BeElite.exception.NotFoundException;
import com.salesianos.triana.BeElite.model.Coach;
import jakarta.transaction.Transactional;
import lombok.RequiredArgsConstructor;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;
import com.salesianos.triana.BeElite.repository.CoachRepository;
import org.springframework.web.multipart.MultipartFile;

import java.io.IOException;
import java.time.LocalDateTime;
import java.util.List;
import java.util.Map;
import java.util.UUID;
import java.util.stream.Collectors;

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
        coach.setJoinDate(LocalDateTime.now());

        return coachRepository.save(coach);
    }

    @Transactional
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

    public Map<String, UUID> getAllNamesAndIdsMap(){
        List<Coach> coaches = coachRepository.findAll();
        return coaches.stream()
                .collect(Collectors.toMap(Coach::getName, Coach::getId));
    }
}
