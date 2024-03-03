package com.salesianos.triana.BeElite.controller;

import com.salesianos.triana.BeElite.dto.Week.WeekDto;
import com.salesianos.triana.BeElite.model.Coach;
import com.salesianos.triana.BeElite.model.Week;
import com.salesianos.triana.BeElite.service.WeekService;
import lombok.RequiredArgsConstructor;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.web.PageableDefault;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequiredArgsConstructor
public class WeekController {
    private final WeekService weekService;

    @GetMapping("/coach/{coachUsername}/{programName}/weeks")
    @PreAuthorize("hasRole('COACH') and #coach.id == principal.id or hasRole('ADMIN')")
    public Page<WeekDto> getWeeksByProgram(@PageableDefault(page = 0, size = 10)Pageable page,
                                                     @AuthenticationPrincipal Coach coach,
                                                     @PathVariable String programName,
                                                     @PathVariable String coachUsername){
        Page<Week> pagedResult = weekService.findPageByProgram(page, programName, coachUsername);

        return pagedResult.map(WeekDto::of);
    }
}
