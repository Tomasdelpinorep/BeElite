package com.salesianos.triana.BeElite.service;

import com.salesianos.triana.BeElite.dto.Block.AthleteBlockDto;
import com.salesianos.triana.BeElite.dto.Session.AthleteSessionDto;
import com.salesianos.triana.BeElite.dto.User.AddUser;
import com.salesianos.triana.BeElite.exception.NotFoundException;
import com.salesianos.triana.BeElite.model.*;
import com.salesianos.triana.BeElite.model.Composite_Ids.AthleteBlockId;
import com.salesianos.triana.BeElite.model.Composite_Ids.AthleteSessionId;
import com.salesianos.triana.BeElite.repository.*;
import lombok.RequiredArgsConstructor;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;

import java.time.LocalDateTime;
import java.util.Comparator;
import java.util.List;
import java.util.UUID;

@Service
@RequiredArgsConstructor
public class AthleteService {

    private final PasswordEncoder passwordEncoder;
    private final AthleteRepository athleteRepository;
    private final CoachRepository coachRepository;
    private final ProgramRepository programRepository;
    private final AthleteSessionRepository athleteSessionRepository;
    private final AthleteBlockRepository athleteBlockRepository;

    public Athlete createAthlete(AddUser addAthlete) {

        Athlete user = new Athlete();
        user.setUsername(addAthlete.username());
        user.setPassword(passwordEncoder.encode(addAthlete.password()));
        user.setEmail(addAthlete.email());
        user.setName(addAthlete.name());
        user.setJoinDate(LocalDateTime.now());

        return athleteRepository.save(user);
    }

    public Athlete findByName(String athleteUsername) {
        return athleteRepository.findByUsername(athleteUsername).orElseThrow(() -> new NotFoundException("athlete"));
    }

    public Athlete findById(UUID id) {
        return athleteRepository.findById(id).orElseThrow(() -> new NotFoundException("athlete"));
    }

    public List<Athlete> findAthletesByProgram(String coachUsername, String programName) {
        Coach c = coachRepository.findByUsername(coachUsername).orElseThrow(() -> new NotFoundException("coach"));
        Program p = programRepository.findByCoachAndProgramName(c.getId(), programName).orElseThrow(() -> new NotFoundException("program"));

        return athleteRepository.findAthletesByProgram(p.getId());

    }

    public Athlete findOldestAthleteInProgram(String coachUsername) {
        Coach c = coachRepository.findByUsername(coachUsername).orElseThrow(() -> new NotFoundException("coach"));

        return athleteRepository.findOldestAthlete(c.getId());
    }

    public Page<Athlete> getAllAthletes(Pageable page) {
        return athleteRepository.findAll(page);
    }

    public static AthleteBlock toAthleteBlock(Block block, AthleteSession athleteSession) {
        return AthleteBlock.builder()
                .id(AthleteBlockId.of(block.getBlock_id().getBlock_number(), athleteSession.getId()))
                .block(block)
                .athleteSession(athleteSession)
                .isCompleted(false)
                .build();
    }

    public List<AthleteSessionDto> getUpcomingWorkouts(String athleteUsername) {
        UUID athleteId = athleteRepository.findByUsername(athleteUsername).orElseThrow(() -> new NotFoundException("athlete")).getId();

        List<AthleteSession> sessions = athleteSessionRepository.findUpcomingWorkoutsByUsername(athleteId);
        sessions.forEach(session -> session.getAthleteBlocks().sort(
                Comparator.comparingLong(block -> block.getId().getAthlete_block_number())
        ));

        return sessions.stream().map(AthleteSessionDto::of).toList();
    }

    public List<AthleteSessionDto> getPreviousWorkouts(String athleteUsername) {
        UUID athleteId = athleteRepository.findByUsername(athleteUsername).orElseThrow(() -> new NotFoundException("athlete")).getId();

        List<AthleteSession> sessions = athleteSessionRepository.findPreviousWorkoutsByUsername(athleteId);
        sessions.forEach(session -> session.getAthleteBlocks().sort(
                Comparator.comparingLong(block -> block.getId().getAthlete_block_number())
        ));

        return sessions.stream().map(AthleteSessionDto::of).toList();
    }

    public AthleteBlock saveAthleteBlock(AthleteBlockDto block) {
        AthleteBlock old = athleteBlockRepository.findById(block.blockId()).orElseThrow(() -> new NotFoundException("athlete block"));

        old.setFeedback(block.feedback());
        old.setCompleted(block.isCompleted());
        old.setCompleted(block.isCompleted());

        return athleteBlockRepository.save(old);
    }

    public AthleteSession getUpdatedAthleteSession(AthleteSessionId id) {
        AthleteSession updated = athleteSessionRepository.findById(id).orElseThrow(() -> new NotFoundException("athlete session"));

        updated.getAthleteBlocks().sort(Comparator.comparingLong(block -> block.getId().getAthlete_block_number()));
        return updated;
    }

    public AthleteSession setSessionAsDone(AthleteSessionId id) {
        AthleteSession session = athleteSessionRepository.findById(id).orElseThrow(() -> new NotFoundException("athlete session"));
        session.setCompleted(true);

        return athleteSessionRepository.save(session);
    }
}
