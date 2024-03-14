package com.salesianos.triana.BeElite.service;

import com.salesianos.triana.BeElite.dto.Week.EditWeekDto;
import com.salesianos.triana.BeElite.dto.Week.PostWeekDto;
import com.salesianos.triana.BeElite.exception.NotFoundException;
import com.salesianos.triana.BeElite.model.*;
import com.salesianos.triana.BeElite.model.Composite_Ids.SessionId;
import com.salesianos.triana.BeElite.model.Composite_Ids.WeekId;
import com.salesianos.triana.BeElite.repository.CoachRepository;
import com.salesianos.triana.BeElite.repository.ProgramRepository;
import com.salesianos.triana.BeElite.repository.SessionRepository;
import com.salesianos.triana.BeElite.repository.WeekRepository;
import jakarta.persistence.EntityNotFoundException;
import jakarta.transaction.Transactional;
import lombok.RequiredArgsConstructor;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.data.domain.Sort;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.UUID;

@Service
@RequiredArgsConstructor
public class WeekService {
    private final WeekRepository weekRepository;
    private final ProgramRepository programRepository;
    private final CoachRepository coachRepository;

    public Page<Week> findPageByProgram(Pageable page, String programName, String coachUsername){
        Sort sort = Sort.by(Sort.Direction.DESC, "created_at");
        Pageable sortedPage = PageRequest.of(page.getPageNumber(), page.getPageSize(), sort);

        Coach c = coachRepository.findByUsername(coachUsername).orElseThrow(() -> new NotFoundException("coach"));
        Program p = programRepository.findByCoachAndProgramName(c.getId(), programName).orElseThrow(() -> new NotFoundException("program"));
        Page<Week> pagedResult = weekRepository.findPageByProgram(sortedPage, p.getId());

        if(pagedResult.isEmpty())
            throw new EntityNotFoundException("No weeks found in this page.");

        return pagedResult;
    }

    public List<String> findWeekNamesByProgram(String programName, String coachUsername){
        Coach c = coachRepository.findByUsername(coachUsername).orElseThrow(() -> new NotFoundException("coach"));
        Program p = programRepository.findByCoachAndProgramName(c.getId(), programName).orElseThrow(() -> new NotFoundException("program"));

        return weekRepository.findWeekNamesByProgram(p.getId());
    }

    public Week save(PostWeekDto newWeek, String coachUsername){
        Coach c = coachRepository.findByUsername(coachUsername).orElseThrow(() -> new NotFoundException("coach"));
        Program p = programRepository.findByCoachAndProgramName(c.getId(), newWeek.program().program_name())
                .orElseThrow(() -> new NotFoundException("program"));
        Long weekId = generateWeekNumber(newWeek.week_name(), p.getId());

        return weekRepository.save(PostWeekDto.toEntity(newWeek, p.getId(), weekId));
    }

    public Week edit(EditWeekDto editedWeek, String coachUsername) {
        Coach c = coachRepository.findByUsername(coachUsername)
                .orElseThrow(() -> new NotFoundException("coach"));
        Program p = programRepository.findByCoachAndProgramName(c.getId(), editedWeek.getProgram().program_name())
                .orElseThrow(() -> new NotFoundException("program"));

        Week originalWeekEntity = weekRepository.findById(WeekId.of(editedWeek.getWeek_number(), editedWeek.getOriginal_name(), p.getId()))
                .orElseThrow(() -> new NotFoundException("week"));

        // Create a new week entity if the name has been edited, else update the original week entity
        if (!editedWeek.getWeek_name().equalsIgnoreCase(editedWeek.getOriginal_name())) {
            editedWeek.setWeek_number((long) (weekRepository.countWeeksByNameAndProgram(editedWeek.getWeek_name(), p.getId()) + 1));
            Week editedWeekEntity = EditWeekDto.toEntity(editedWeek, p.getId());

            // Must save the new Week entity before updating sessions
            editedWeekEntity = weekRepository.save(editedWeekEntity);

            // Here I update both the embedded session id to its new week
            for (Session session : originalWeekEntity.getSessions()) {
                SessionId sessionId = session.getId();
                if (sessionId != null) {
                    sessionId.setWeek_id(WeekId.of(editedWeek.getWeek_number(), editedWeek.getWeek_name(), p.getId()));
                }
            }

            weekRepository.delete(originalWeekEntity);
            return weekRepository.save(editedWeekEntity);

        } else {
            originalWeekEntity.setDescription(editedWeek.getDescription());
            return weekRepository.save(originalWeekEntity);
        }
    }


    private Long generateWeekNumber(String week_name, UUID program_id) {
        return (long) (weekRepository.countWeeksByNameAndProgram(week_name, program_id) + 1);
    }

    @Transactional
    public void deleteWeek(String coachUsername, String programName, String weekName, Long weekNumber){
        Coach c = coachRepository.findByUsername(coachUsername).orElseThrow(() -> new NotFoundException("coach"));
        Program p = programRepository.findByCoachAndProgramName(c.getId(),  programName).orElseThrow(() -> new NotFoundException("program"));

        Week w = weekRepository.findById(WeekId.of(weekNumber, weekName, p.getId())).orElseThrow(() -> new NotFoundException("week"));
        weekRepository.delete(w);
    }
}
