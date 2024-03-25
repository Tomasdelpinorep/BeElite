package com.salesianos.triana.BeElite.service;

import com.salesianos.triana.BeElite.dto.User.AddUser;
import com.salesianos.triana.BeElite.exception.NotFoundException;
import com.salesianos.triana.BeElite.model.Athlete;
import com.salesianos.triana.BeElite.model.Coach;
import com.salesianos.triana.BeElite.model.Program;
import com.salesianos.triana.BeElite.repository.AthleteRepository;
import com.salesianos.triana.BeElite.repository.CoachRepository;
import com.salesianos.triana.BeElite.repository.ProgramRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.UUID;

@Service
@RequiredArgsConstructor
public class AthleteService {

    private final PasswordEncoder passwordEncoder;
    private final AthleteRepository athleteRepository;
    private final CoachRepository coachRepository;
    private final ProgramRepository programRepository;

    public Athlete createAthlete(AddUser addAthlete) {

        Athlete user = new Athlete();
        user.setUsername(addAthlete.username());
        user.setPassword(passwordEncoder.encode(addAthlete.password()));
        user.setEmail(addAthlete.email());
        user.setName(addAthlete.name());

        return athleteRepository.save(user);
    }

    public Athlete findByName(String athleteUsername){
        return athleteRepository.findByUsername(athleteUsername).orElseThrow(() -> new NotFoundException("athlete"));
    }

    public Athlete findById(UUID id){
        return athleteRepository.findById(id).orElseThrow(() -> new NotFoundException("athlete"));
    }

    public List<Athlete> findAthletesByProgram(String coachUsername, String programName){
        Coach c = coachRepository.findByUsername(coachUsername).orElseThrow(() -> new NotFoundException("coach"));
        Program p = programRepository.findByCoachAndProgramName(c.getId(), programName).orElseThrow(() -> new NotFoundException("program"));

        return athleteRepository.findAthletesByProgram(p.getId());

    }

}
