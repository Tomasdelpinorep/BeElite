package com.salesianos.triana.BeElite.controller;

import com.salesianos.triana.BeElite.dto.Session.SessionCardDto;
import com.salesianos.triana.BeElite.service.SessionService;
import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequiredArgsConstructor
public class SessionController {

    private final SessionService sessionService;

    @GetMapping("/{coachName}/{programName}/{weekName}/{weekNumber}/sessions/{sessionNumber}")
    public SessionCardDto getSessionDetails(@PathVariable String coachName,
                                               @PathVariable String programName,
                                               @PathVariable String weekName,
                                               @PathVariable Long weekNumber,
                                               @PathVariable Long sessionNumber){
        return SessionCardDto.of(sessionService.findDetailsById(coachName, programName, weekName, weekNumber,sessionNumber));
    }

}
