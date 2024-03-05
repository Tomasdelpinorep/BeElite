package com.salesianos.triana.BeElite.service;

import com.salesianos.triana.BeElite.dto.Week.PostWeekDto;
import com.salesianos.triana.BeElite.exception.NotFoundException;
import com.salesianos.triana.BeElite.model.Coach;
import com.salesianos.triana.BeElite.model.Program;
import com.salesianos.triana.BeElite.model.Week;
import com.salesianos.triana.BeElite.repository.CoachRepository;
import com.salesianos.triana.BeElite.repository.ProgramRepository;
import com.salesianos.triana.BeElite.repository.WeekRepository;
import jakarta.persistence.EntityNotFoundException;
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
        Long weekId = generateCompositeId(newWeek.week_name(), p.getId());

        return weekRepository.save(PostWeekDto.toEntity(newWeek, p, weekId));
    }

    private Long generateCompositeId(String week_name, UUID program_id) {
        return (long) (weekRepository.countWeeksByNameAndProgram(week_name, program_id) + 1);
    }
}
