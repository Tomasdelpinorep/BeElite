package com.salesianos.triana.BeElite.controller;

import com.salesianos.triana.BeElite.dto.Week.EditWeekDto;
import com.salesianos.triana.BeElite.dto.Week.PostWeekDto;
import com.salesianos.triana.BeElite.dto.Week.WeekDto;
import com.salesianos.triana.BeElite.model.Coach;
import com.salesianos.triana.BeElite.model.Week;
import com.salesianos.triana.BeElite.service.WeekService;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.web.PageableDefault;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.support.ServletUriComponentsBuilder;

import java.net.URI;
import java.util.List;

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

    @GetMapping("/coach/{coachUsername}/{programName}/weeks/names")
    @PreAuthorize("hasRole('COACH') and #coach.id == principal.id or hasRole('ADMIN')")
    public List<String> getWeekNamesByProgram(@AuthenticationPrincipal Coach coach,
                                              @PathVariable String programName,
                                              @PathVariable String coachUsername){

        return weekService.findWeekNamesByProgram(programName, coachUsername);
    }

    @PostMapping("/coach/{coachUsername}/weeks/new")
    @PreAuthorize("hasRole('COACH') and #coach.id == principal.id or hasRole('ADMIN')")
    ResponseEntity<WeekDto> addWeek(@PathVariable String coachUsername,
                                    @AuthenticationPrincipal Coach coach,
                                    @Valid @RequestBody PostWeekDto newWeek){
        Week w = weekService.save(newWeek, coachUsername);

        URI createdUri = ServletUriComponentsBuilder
                .fromCurrentRequest()
                .buildAndExpand(w.getId()).toUri();

        return ResponseEntity.created(createdUri).body(WeekDto.of(w));
    }

    @PutMapping("/coach/{coachUsername}/weeks/edit")
    @PreAuthorize("hasRole('COACH') and #coach.id == principal.id or hasRole('ADMIN')")
    WeekDto editWeek(@PathVariable String coachUsername,
                                    @AuthenticationPrincipal Coach coach,
                                    @Valid @RequestBody EditWeekDto editedWeek){
        Week w = weekService.edit(editedWeek, coachUsername);

        return WeekDto.of(w);
    }
}
