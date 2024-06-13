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

import java.util.ArrayList;
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

    public Session save(String coachUsername, String programName, String weekName, Long weekNumber, PostSessionDto postSession) {
        Coach c = coachRepository.findByUsername(coachUsername).orElseThrow(() -> new NotFoundException("coach"));
        Program p = programRepository.findByCoachAndProgramName(c.getId(), programName).orElseThrow(() -> new NotFoundException("program"));
        Session s = sessionRepository.save(this.toEntity(postSession, WeekId.of(weekNumber, weekName, p.getId())));

        List<Block> blockEntities = postSession.blocks().stream().map(block -> BlockService.toEntity(block, s.getId(),s)).toList();

        for (Athlete athlete : p.getAthletes()) {
            // Initialize an empty list of blocks to add to each athlete's session
            List<AthleteBlock> athleteBlocks = new ArrayList<>();

            AthleteSession newAthleteSession = AthleteSession.builder()
                    .id(AthleteSessionId.of((long) athlete.getAthleteSessions().size() + 1, athlete.getId()))
                    .athlete(athlete)
                    .session(s)
                    .isCompleted(false)
                    .build();

            for(int i = 1; i < blockEntities.size(); i++){
                athleteBlocks.add(AthleteBlock.builder()
                        .id(AthleteBlockId.of((long) i, newAthleteSession.getId()))
                        .block(blockEntities.get(i-1))
                        .isCompleted(false)
                        .athleteSession(newAthleteSession)
                        .build());
            }

            newAthleteSession.setAthleteBlocks(athleteBlocks);
            athlete.getAthleteSessions().add(newAthleteSession);
            athleteRepository.save(athlete); // This should cascade changes to AthleteSessions
        }

        return s;
    }

    public Session edit(PostSessionDto editedSession, String coachUsername, String programName, String weekName, Long weekNumber) {
        Coach c = coachRepository.findByUsername(coachUsername).orElseThrow(() -> new NotFoundException("coach"));
        Program p = programRepository.findByCoachAndProgramName(c.getId(), programName).orElseThrow(() -> new NotFoundException("program"));
        WeekId weekId = WeekId.of(weekNumber, weekName, p.getId());

        Session originalSession = sessionRepository.findById(SessionId.of(editedSession.session_number(), weekId))
                .orElseThrow(() -> new NotFoundException("session"));

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
        sessionRepository.save(originalSession);

        //Update session to the athlete's session list
        for (Athlete athlete : p.getAthletes()) {
            for (AthleteSession athleteSession : athlete.getAthleteSessions()) {
                if (athleteSession.getSession().equals(originalSession)) {
                    athleteSession.getAthleteBlocks().clear();

                    for (Block block : originalSession.getBlocks()) {
                        AthleteBlock athleteBlock = AthleteService.toAthleteBlock(block, athleteSession);
                        athleteSession.getAthleteBlocks().add(athleteBlock);
                    }
                }
            }
            athleteRepository.save(athlete);
        }


        return originalSession;
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

    public Session toEntity(PostSessionDto postSession, WeekId weekId){
        SessionId sessionId = SessionId.of(postSession.session_number(), weekId);

        Session newSession = Session.builder()
                .id(sessionId)
                .date(postSession.date())
                .title(postSession.title())
                .subtitle(postSession.subtitle())
                .same_day_session_number(postSession.same_day_session_number())
                .week(Week.builder().id(weekId).build())
                .blocks(List.of())
                .build();
        List<Block> newSessionBlocks = postSession.blocks().stream().map(
                block -> BlockService.toEntity(block, sessionId, newSession)).toList();

        newSession.setBlocks(newSessionBlocks);
        return newSession;
    }

    private Block findCorrespondingBlock(Session editedSession, AthleteBlockId athleteBlockId) {
        for (Block editedBlock : editedSession.getBlocks()) {
            if (editedBlock.getBlock_id().equals(athleteBlockId)) {
                return editedBlock;
            }
        }
        return null;
    }

}
