package com.salesianos.triana.BeElite.service;

import com.salesianos.triana.BeElite.dto.Block.PostBlockDto;
import com.salesianos.triana.BeElite.dto.Session.PostSessionDto;
import com.salesianos.triana.BeElite.exception.NotFoundException;
import com.salesianos.triana.BeElite.model.Coach;
import com.salesianos.triana.BeElite.model.Composite_Ids.SessionId;
import com.salesianos.triana.BeElite.model.Composite_Ids.WeekId;
import com.salesianos.triana.BeElite.model.Program;
import com.salesianos.triana.BeElite.model.Session;
import com.salesianos.triana.BeElite.model.Week;
import com.salesianos.triana.BeElite.repository.CoachRepository;
import com.salesianos.triana.BeElite.repository.ProgramRepository;
import com.salesianos.triana.BeElite.repository.WeekRepository;
import com.salesianos.triana.BeElite.repository.SessionRepository;
import jakarta.persistence.EntityNotFoundException;
import lombok.RequiredArgsConstructor;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.domain.Sort;
import org.springframework.stereotype.Service;

import java.util.ArrayList;
import java.util.stream.Collectors;

@Service
@RequiredArgsConstructor
public class SessionService {

    private final CoachRepository coachRepository;
    private final ProgramRepository programRepository;
    private final WeekRepository weekRepository;
    private final SessionRepository sessionRepository;

    public Page<Session> findCardPageById(Pageable page, String coachUsername, String programName,
                                         String weekName, Long weekNumber){

        Coach c = coachRepository.findByUsername(coachUsername).orElseThrow(() -> new NotFoundException("coach"));
        Program p = programRepository.findByCoachAndProgramName(c.getId(), programName).orElseThrow(() -> new NotFoundException("program"));

        Page<Session> pagedResult =  sessionRepository.findSessionCardPageById(page, WeekId.of(weekNumber, weekName, p.getId()));

        if(pagedResult.isEmpty())
            throw new EntityNotFoundException("No sessions found in this page.");

        return pagedResult;
    }

    public Session findPostDtoById(String coachUsername, String programName,
                                          String weekName, Long weekNumber, Long sessionNumber){
        Coach c = coachRepository.findByUsername(coachUsername).orElseThrow(() -> new NotFoundException("coach"));
        Program p = programRepository.findByCoachAndProgramName(c.getId(), programName).orElseThrow(() -> new NotFoundException("program"));

        SessionId sessionId = SessionId.of(sessionNumber, WeekId.of(weekNumber, weekName, p.getId()));
        return sessionRepository.findByIdOrderedByBlockNumberAsc(sessionId).orElseThrow(() -> new NotFoundException("session"));
    }

    public Session save(String coachUsername, String programName, String weekName, Long weekNumber, PostSessionDto postSession){
        Coach c = coachRepository.findByUsername(coachUsername).orElseThrow(() -> new NotFoundException("coach"));
        Program p = programRepository.findByCoachAndProgramName(c.getId(), programName).orElseThrow(() -> new NotFoundException("program"));
        WeekId weekId = WeekId.of(weekNumber, weekName, p.getId());

        return sessionRepository.save(PostSessionDto.toEntity(postSession, weekId));
    }

    public Session edit(PostSessionDto editedSession, String coachUsername,String programName, String weekName, Long weekNumber){
        Coach c = coachRepository.findByUsername(coachUsername).orElseThrow(() -> new NotFoundException("coach"));
        Program p = programRepository.findByCoachAndProgramName(c.getId(), programName).orElseThrow(() -> new NotFoundException("program"));
        WeekId weekId = WeekId.of(weekNumber, weekName, p.getId());

        Session originalSession = sessionRepository.findById(SessionId.of(editedSession.session_number(), weekId))
                .orElseThrow(() -> new NotFoundException("session"));

        originalSession.setDate(editedSession.date());
        originalSession.setTitle(editedSession.title());
        originalSession.setSubtitle(editedSession.subtitle());
        //Must return mutable ArrayList or else throws UnsupportedOperationException
        originalSession.setBlocks(editedSession.blocks().stream()
                .map(block -> PostBlockDto.toEntity(block, originalSession.getId()))
                .collect(Collectors.toCollection(ArrayList::new)));
        originalSession.setSame_day_session_number(editedSession.same_day_session_number());

        return sessionRepository.save(originalSession);
    }

    public void delete(String coachUsername,String programName, String weekName, Long weekNumber, Long sessionNumber){
        Coach c = coachRepository.findByUsername(coachUsername).orElseThrow(() -> new NotFoundException("coach"));
        Program p = programRepository.findByCoachAndProgramName(c.getId(), programName).orElseThrow(() -> new NotFoundException("program"));
        WeekId weekId = WeekId.of(weekNumber, weekName, p.getId());

        Session s = sessionRepository.findById(SessionId.of(sessionNumber, weekId)).orElseThrow(() -> new NotFoundException("session"));
        sessionRepository.delete(s);
    }
}
