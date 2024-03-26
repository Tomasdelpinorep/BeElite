package com.salesianos.triana.BeElite.service;

import com.salesianos.triana.BeElite.dto.Block.PostBlockDto;
import com.salesianos.triana.BeElite.dto.Session.PostSessionDto;
import com.salesianos.triana.BeElite.dto.Set.PostSetDto;
import com.salesianos.triana.BeElite.exception.NotFoundException;
import com.salesianos.triana.BeElite.model.*;
import com.salesianos.triana.BeElite.model.Composite_Ids.*;
import com.salesianos.triana.BeElite.repository.*;
import jakarta.persistence.EntityNotFoundException;
import jakarta.transaction.Transactional;
import lombok.RequiredArgsConstructor;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
@Transactional
@RequiredArgsConstructor
public class SessionService {

    private final CoachRepository coachRepository;
    private final ProgramRepository programRepository;
    private final AthleteRepository athleteRepository;
    private final SessionRepository sessionRepository;
    private final AthleteSessionRepository athleteSessionRepository;
    private final AthleteBlockRepository athleteBlockRepository;

    public Page<AthleteSession> findSessionCardPageByIdAndAthleteUsername(Pageable page, String athleteUsername){
        Page<AthleteSession> pagedResult =  athleteSessionRepository.findByAthleteUsernameUpUntilTodayOrderedByDate(page, athleteUsername);

        if(pagedResult.isEmpty())
            throw new EntityNotFoundException("No sessions found for this athlete's program.");

        return pagedResult;
    }

    public Session findPostDtoById(String coachUsername, String programName,
                                          String weekName, Long weekNumber, Long sessionNumber){
        Coach c = coachRepository.findByUsername(coachUsername).orElseThrow(() -> new NotFoundException("coach"));
        Program p = programRepository.findByCoachAndProgramName(c.getId(), programName).orElseThrow(() -> new NotFoundException("program"));

        SessionId sessionId = SessionId.of(sessionNumber, WeekId.of(weekNumber, weekName, p.getId()));
        return sessionRepository.findByIdOrderedByBlockNumberAsc(sessionId).orElseThrow(() -> new NotFoundException("session"));
    }

    @Transactional
    public Session save(String coachUsername, String programName, String weekName, Long weekNumber, PostSessionDto postSession) {
        Coach c = coachRepository.findByUsername(coachUsername).orElseThrow(() -> new NotFoundException("coach"));
        Program p = programRepository.findByCoachAndProgramName(c.getId(), programName).orElseThrow(() -> new NotFoundException("program"));
        Session s = sessionRepository.save(PostSessionDto.toEntity(postSession, WeekId.of(weekNumber, weekName, p.getId())));

        for (Athlete athlete : p.getAthletes()) {
            AthleteSession newAthleteSession = AthleteSession.builder()
                    .id(AthleteSessionId.of(athleteSessionRepository.countNumberOfSessionsPerAthlete(athlete.getId()) + 1,
                            athlete.getId()))
                    .athlete(athlete)
                    .session(s)
                    .isCompleted(false)
                    .build();

            List<AthleteBlock> athleteBlocks = postSession.blocks().stream()
                    .map(block -> AthleteBlock.builder()
                            .id(AthleteBlockId.of(athleteBlockRepository.countNumberOfBlocksPerAthleteSession(
                                            athlete.getId(), newAthleteSession.getId().getAthlete_session_number()) + 1,
                                    newAthleteSession.getId()))
                            .block(PostBlockDto.toEntity(block, s.getId()))
                            .isCompleted(false)
                            .athleteSession(newAthleteSession)
                            .build())
                    .toList();

            newAthleteSession.setAthleteBlocks(athleteBlocks);
            athlete.getAthleteSessions().add(newAthleteSession);
            athleteRepository.save(athlete); // This should cascade changes to AthleteSessions

            athleteBlocks.forEach(athleteBlockRepository::save); // Save all AthleteBlocks
            athleteSessionRepository.save(newAthleteSession);
        }

        return s;
    }


    public Session edit(PostSessionDto editedSession, String coachUsername, String programName, String weekName, Long weekNumber) {
        Coach c = coachRepository.findByUsername(coachUsername).orElseThrow(() -> new NotFoundException("coach"));
        Program p = programRepository.findByCoachAndProgramName(c.getId(), programName).orElseThrow(() -> new NotFoundException("program"));
        WeekId weekId = WeekId.of(weekNumber, weekName, p.getId());

        Session originalSession = sessionRepository.findById(SessionId.of(editedSession.session_number(), weekId))
                .orElseThrow(() -> new NotFoundException("session"));

        //Remove the old session from the athlete's session list
        for(Athlete athlete : p.getAthletes()){
            athlete.getAthleteSessions().removeIf(athleteSession -> athleteSession.getSession().getId().equals(originalSession.getId()));
        }

        //Update the session with the new data
        originalSession.getBlocks().clear();

        for (PostBlockDto editedBlock : editedSession.blocks()) {
            Block newBlock = new Block();
            newBlock.setBlock_id(BlockId.of(originalSession.getId(), editedBlock.block_number()));
            newBlock.setSession(originalSession);
            newBlock.setMovement(editedBlock.movement());
            newBlock.setInstructions(editedBlock.block_instructions());
            newBlock.setRest_between_sets(editedBlock.rest_between_sets());

            for (PostSetDto editedSet : editedBlock.sets()) {
                Set newSet = new Set();
                newSet.setSet_id(SetId.of(editedSet.set_number(), newBlock.getBlock_id()));
                newSet.setNumber_of_sets(editedSet.number_of_sets());
                newSet.setNumber_of_reps(editedSet.number_of_reps());
                newSet.setPercentage(editedSet.percentage());
                newSet.setBlock(newBlock);
                newBlock.getSets().add(newSet);
            }

            originalSession.getBlocks().add(newBlock);
        }

        originalSession.setDate(editedSession.date());
        originalSession.setTitle(editedSession.title());
        originalSession.setSubtitle(editedSession.subtitle());
        originalSession.setSame_day_session_number(editedSession.same_day_session_number());

        //Add back the updated session to the athlete's session list
        for(Athlete athlete : p.getAthletes()){
            AthleteSession updatedAthleteSession = AthleteSession.builder()
                    .id(AthleteSessionId.of(athleteSessionRepository.countNumberOfSessionsPerAthlete(athlete.getId()) + 1,athlete.getId()))
                    .athlete(athlete)
                    .session(originalSession)
                    .isCompleted(false)
                    .build();

            //Add the blocks to the new session being added to the athletes
            for(Block block : originalSession.getBlocks()){
                AthleteBlock athleteBlock = AthleteBlock.builder()
                        .id(AthleteBlockId.of(athleteBlockRepository.countNumberOfBlocksPerAthleteSession(
                                athlete.getId(), updatedAthleteSession.getId().getAthlete_session_number()) + 1,
                                updatedAthleteSession.getId()))
                        .block(block)
                        .isCompleted(false)
                        .athleteSession(updatedAthleteSession)
                        .build();

                athleteBlockRepository.save(athleteBlock);
                updatedAthleteSession.getAthleteBlocks().add(athleteBlock);
            }
            athleteSessionRepository.save(updatedAthleteSession);
            athlete.getAthleteSessions().add(updatedAthleteSession);
            athleteRepository.save(athlete);
        }

        return sessionRepository.save(originalSession);
    }



    public void delete(String coachUsername,String programName, String weekName, Long weekNumber, Long sessionNumber){
        Coach c = coachRepository.findByUsername(coachUsername).orElseThrow(() -> new NotFoundException("coach"));
        Program p = programRepository.findByCoachAndProgramName(c.getId(), programName).orElseThrow(() -> new NotFoundException("program"));
        WeekId weekId = WeekId.of(weekNumber, weekName, p.getId());

        Session s = sessionRepository.findById(SessionId.of(sessionNumber, weekId)).orElseThrow(() -> new NotFoundException("session"));

        //Must also remove the session from the session list
        for(Athlete athlete : p.getAthletes()){
            athlete.getAthleteSessions().removeIf(athleteSession -> athleteSession.getSession().getId().equals(s.getId()));
        }

        sessionRepository.delete(s);
    }
}
