package com.salesianos.triana.BeElite.service;

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
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

@Service
@RequiredArgsConstructor
public class SessionService {

    private final CoachRepository coachRepository;
    private final ProgramRepository programRepository;
    private final WeekRepository weekRepository;
    private final SessionRepository sessionRepository;

    public Session findDetailsById(String coachName, String programName,
                                   String weekName, Long weekNumber, Long sessionNumber){

        Coach c = coachRepository.findByUsername(coachName).orElseThrow(() -> new NotFoundException("coach"));
        Program p = programRepository.findByCoachAndProgramName(c.getId(), programName).orElseThrow(() -> new NotFoundException("program"));
        Week w = weekRepository.findById(WeekId.of(weekNumber, weekName, p.getId())).orElseThrow(() -> new NotFoundException("week"));

        return sessionRepository.findById(SessionId.of(sessionNumber, WeekId.of(weekNumber, weekName, p.getId()))).orElseThrow(() -> new NotFoundException("session"));
    }
}
